//
//  MTFThemeClass.m
//  Motif
//
//  Created by Eric Horacek on 12/22/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import "NSValueTransformer+TypeFiltering.h"
#import "NSObject+ThemeClassAppliersPrivate.h"
#import "NSObject+ThemeClass.h"
#import "NSString+ThemeSymbols.h"

#import "MTFRuntimeExtensions.h"
#import "MTFThemeClass.h"
#import "MTFThemeClass_Private.h"
#import "MTFTheme.h"
#import "MTFTheme_Private.h"
#import "MTFThemeConstant.h"
#import "MTFThemeClassApplicable.h"
#import "MTFErrors.h"
#import "MTFValueTransformerErrorHandling.h"

@implementation MTFThemeClass

#pragma mark - NSObject

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Use the designated initializer instead" userInfo:nil];
}

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;

    if (![object isKindOfClass:self.class]) return NO;

    return [self isEqualToThemeClass:object];
}

- (NSUInteger)hash {
    return (self.name.hash ^ self.propertiesConstants.hash);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ {%@: %@, %@: %@}",
        NSStringFromClass(self.class),
        NSStringFromSelector(@selector(name)), self.name,
        NSStringFromSelector(@selector(properties)), self.properties
    ];
}

#pragma mark - MTFThemeClass

#pragma mark Public

- (BOOL)applyTo:(id)applicant error:(NSError **)error {
    NSParameterAssert(applicant != nil);

    // If the theme class has already been applied to the applicant, do no
    // reapply.
    if ([applicant mtf_themeClass] == self) return YES;

    // Contains the names of properties that were not able to be applied to the
    // object.
    NSMutableSet<NSString *> *unappliedProperties = [NSMutableSet setWithArray:self.properties.allKeys];

    // Contains the errors that occurred while applying properties to the
    // object.
    NSMutableArray<NSError *> *errors = [NSMutableArray array];

    // Contains the names of properties that were not able to be applied to the
    // object.
    NSMutableSet<NSString *> *propertiesWithErrors = [NSMutableSet set];

    // First, attempt to apply each of the class appliers registered on the
    // applicant's class.
    for (id<MTFThemeClassApplicable> classApplier in [[applicant class] mtf_themeClassAppliers]) {
        NSError *applierError;
        NSSet<NSString *> *appliedProperties = [classApplier applyClass:self to:applicant error:&applierError];
        
        if (appliedProperties != nil) {
            [unappliedProperties minusSet:appliedProperties];
        } else {
            [unappliedProperties minusSet:classApplier.properties];
            [propertiesWithErrors unionSet:classApplier.properties];

            if (applierError != nil) {
                [errors addObject:applierError];
            }
        }
    }

    NSDictionary<NSString *, MTFThemeConstant *> *resolvedPropertiesConstants = self.resolvedPropertiesConstants;
    
    // Second, for each of the properties that had no appliers, attempt to
    // locate a property on the applicant's class with the same name as the
    // theme class property. If one is found, use KVC to set its value.
    for (NSString *property in [unappliedProperties copy]) {
        // Traverse the class hierarchy from the applicant's class up by
        // superclasses.
        Class applicantClass = [applicant class];
        do {
            // Locate the first property of the same name as the theme class
            // property in the applicant's class hierarchy.
            objc_property_t objc_property = class_getProperty(
                applicantClass,
                property.UTF8String);
            
            if (objc_property == NULL) continue;
            
            // Build a property attributes struct to figure out the type of the
            // property.
            mtf_propertyAttributes *propertyAttributes = NULL;
            propertyAttributes = mtf_copyPropertyAttributes(objc_property);
            if (propertyAttributes == NULL) continue;

            Class propertyClass = propertyAttributes->objectClass;
            const char *propertyObjCType = propertyAttributes->type;
            MTFThemeConstant *constant = resolvedPropertiesConstants[property];

            // If it's an Obj-C class object property:
            if (propertyClass != Nil) {
                // If the constant value can be set directly as the value of the
                // property without transformation, do so immediately and break
                // out of the loop.
                if ([constant.value isKindOfClass:propertyClass]) {
                    [unappliedProperties removeObject:property];
                    [applicant setValue:constant.value forKey:property];
                    break;
                }
            }
            // If it's an Obj-C NSValue type:
            else if (propertyObjCType != NULL) {
                // Whether the property is an C numeric type.
                BOOL isPropertyNumericCType = (
                    strlen(propertyObjCType) == 1
                    && strchr("cislqCISLQfdB", propertyObjCType[0])
                );

                // If it's a numeric C type with an NSNumber equivalent,
                // set it with KVC as no transformation is needed.
                if (isPropertyNumericCType && [constant.value isKindOfClass:NSNumber.class]) {
                    [unappliedProperties removeObject:property];
                    [applicant setValue:constant.value forKey:property];
                    break;
                }
            }

            // Attempt to locate a value transformer that can be used to
            // transform from the theme class property value to to the type of
            // the property.
            NSValueTransformer *valueTransformer;

            // If it's an Obj-C class object property:
            if (propertyClass != Nil) {
                valueTransformer = [NSValueTransformer
                    mtf_valueTransformerForTransformingObject:constant.value
                    toClass:propertyClass];
            }
            // If it's an Obj-C NSValue type:
            else if (propertyObjCType != NULL) {
                valueTransformer = [NSValueTransformer
                    mtf_valueTransformerForTransformingObject:constant.value
                    toObjCType:propertyObjCType];
            }
            
            free(propertyAttributes);
            
            // If a value transformer is found for the property, use KVC to set
            // the transformed theme class property value on the applicant
            // object, and break out of this loop.
            if (valueTransformer != nil) {
                [unappliedProperties removeObject:property];

                NSError *valueTransformationError;
                id transformedValue = [constant transformedValueFromTransformer:valueTransformer error:&valueTransformationError];

                if (transformedValue != nil) {
                    [applicant setValue:transformedValue forKey:property];
                    break;
                }

                [propertiesWithErrors addObject:property];

                if (valueTransformationError != nil) {
                    [errors addObject:valueTransformationError];
                }

                break;
            }
            
            id propertyValue = [applicant valueForKey:property];
            BOOL isPropertyTypeThemeClass = (propertyClass == MTFThemeClass.class);
            BOOL isValueThemeClass = [constant.value isKindOfClass:MTFThemeClass.class];

            // If the property currently set to a value and the property being
            // applied is a theme class reference, apply the theme class
            // directly to the property value, unless the property type is a
            // theme class itself.
            if (propertyValue && isValueThemeClass && !isPropertyTypeThemeClass) {
                MTFThemeClass *themeClass = (MTFThemeClass *)constant.value;

                [unappliedProperties removeObject:property];

                NSError *applyPropertyError;
                if (![themeClass applyTo:propertyValue error:&applyPropertyError]) {
                    [propertiesWithErrors addObject:property];

                    if (applyPropertyError != nil) {
                        [errors addObject:applyPropertyError];
                    }
                }

                break;
            }
            
        } while ((applicantClass = [applicantClass superclass]));
    }

    BOOL logFailures = getenv("MTF_LOG_THEME_APPLICATION_ERRORS") != NULL;

    // If no appliers nor Obj-C properties were found for any of the properties
    // specified in the theme class, application was unsuccessful.
    if (unappliedProperties.count > 0) {
        if (error == NULL && !logFailures) return NO;

        NSMutableDictionary *unappliedValuesByProperties = [NSMutableDictionary dictionary];
        for (NSString *property in unappliedProperties.allObjects) {
            unappliedValuesByProperties[property] = self.properties[property];
        }

        NSString *description = [NSString stringWithFormat:
            @"Failed to apply the properties %@ from the theme class "\
                "named '%@' to an instance of %@. %@ or any of its "\
                "ancestors must either: (1) Have a readwrite property "\
                "with the same name as the unapplied properties. (2) Have "\
                "an applier block registered for the unapplied properties.",
            [unappliedProperties.allObjects componentsJoinedByString:@", "],
            self.name,
            [applicant class],
            [applicant class]];

        NSError *failedToApplyThemeError = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToApplyTheme userInfo:@{
            NSLocalizedDescriptionKey: description,
            MTFUnappliedPropertiesErrorKey: unappliedValuesByProperties,
            MTFThemeClassNameErrorKey: self.name,
            MTFApplicantErrorKey: applicant,
        }];

        if (error != NULL) {
            *error = failedToApplyThemeError;
        }

        if (logFailures) {
            NSLog(@"Motif: Theme class application failed: %@", failedToApplyThemeError);
        }

        return NO;
    }

    // If any of the appliers or transformers produced an error, application was
    // unsuccessful.
    if (propertiesWithErrors.count > 0) {
        if (error == NULL && !logFailures) return NO;

        NSMutableDictionary *valuesByPropertiesWithErrors = [NSMutableDictionary dictionary];
        for (NSString *property in propertiesWithErrors) {
            valuesByPropertiesWithErrors[property] = self.properties[property];
        }

        NSString *description = [NSString stringWithFormat:
            @"Failed to apply theme class properties %@ from the theme class "\
                "named '%@' to an instance of %@.",
            [propertiesWithErrors.allObjects componentsJoinedByString:@", "],
            self.name,
            [applicant class]];

        NSError *failedToApplyThemeError = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToApplyTheme userInfo:@{
            NSLocalizedDescriptionKey: description,
            MTFUnappliedPropertiesErrorKey: valuesByPropertiesWithErrors,
            MTFThemeClassNameErrorKey: self.name,
            MTFUnderlyingErrorsErrorKey: errors,
            MTFApplicantErrorKey: applicant,
        }];

        if (error != NULL) {
            *error = failedToApplyThemeError;
        }

        if (logFailures) {
            NSLog(@"Motif: Theme class application failed: %@", failedToApplyThemeError);
        }

        return NO;
    }

    [applicant mtf_setThemeClass:self];
    
    return YES;
}

#pragma mark Private

- (BOOL)isEqualToThemeClass:(MTFThemeClass *)themeClass {
    if (!themeClass) {
        return NO;
    }
    BOOL haveEqualNames = (
        (!self.name && !themeClass.name)
        || [self.name isEqualToString:themeClass.name]
    );
    BOOL haveEqualPropertiesConstants = (
        (!self.propertiesConstants && !themeClass.propertiesConstants)
        || [self.propertiesConstants isEqual:themeClass.propertiesConstants]
    );
    return (
        haveEqualNames
        && haveEqualPropertiesConstants
    );
}

- (instancetype)initWithName:(NSString *)name propertiesConstants:(NSDictionary<NSString *, MTFThemeConstant *> *)propertiesConstants {
    self = [super init];

    _name = name;
    _propertiesConstants = propertiesConstants;
    _resolvedPropertiesConstants = [self createResolvedPropertiesConstantsFromPropertiesConstants:_propertiesConstants];
    _properties = [self createPropertiesFromResolvedPropertiesConstants:_resolvedPropertiesConstants];

    return self;
}

- (void)setPropertiesConstants:(NSDictionary<NSString *,MTFThemeConstant *> *)propertiesConstants {
    NSParameterAssert(propertiesConstants != nil);

    _propertiesConstants = propertiesConstants;
    _resolvedPropertiesConstants = [self createResolvedPropertiesConstantsFromPropertiesConstants:_propertiesConstants];
    _properties = [self createPropertiesFromResolvedPropertiesConstants:_resolvedPropertiesConstants];
}

- (NSDictionary<NSString *, MTFThemeConstant *> *)createResolvedPropertiesConstantsFromPropertiesConstants:(NSDictionary<NSString *, MTFThemeConstant *> *)propertiesConstants {
    NSParameterAssert(propertiesConstants != nil);

    NSMutableDictionary<NSString *, MTFThemeConstant *> *resolvedPropertiesConstants = [NSMutableDictionary dictionary];

    [propertiesConstants enumerateKeysAndObjectsUsingBlock:^(NSString *name, MTFThemeConstant *constant, BOOL *_) {
        // Resolve references to superclass into the properties constants
        // dictionary
        if (name.mtf_isSuperclassProperty) {
            MTFThemeClass *superclass = (MTFThemeClass *)constant.value;
            // In the case of the symbol generator, the superclasses could
            // not be resolved, and thus may strings rather than references
            if ([superclass isKindOfClass:MTFThemeClass.class]) {
                NSMutableDictionary<NSString *, MTFThemeConstant *> *superclassProperties = [superclass.resolvedPropertiesConstants mutableCopy];
                // Ensure that subclasses are able to override properties
                // by removing keys from the resolved properties constants
                [superclassProperties removeObjectsForKeys:propertiesConstants.allKeys];
                [resolvedPropertiesConstants addEntriesFromDictionary:superclassProperties];
            }
        } else {
            resolvedPropertiesConstants[name] = constant;
        }
    }];

    return [resolvedPropertiesConstants copy];
}

- (NSDictionary<NSString *, id> *)createPropertiesFromResolvedPropertiesConstants:(NSDictionary<NSString *, MTFThemeConstant *> *)resolvedPropertiesConstants {
    NSParameterAssert(resolvedPropertiesConstants != nil);

    NSMutableDictionary<NSString *, id> *properties = [NSMutableDictionary dictionary];

    [resolvedPropertiesConstants enumerateKeysAndObjectsUsingBlock:^(NSString *name, MTFThemeConstant *constant, BOOL *_) {
        properties[name] = constant.value;
    }];

    return [properties copy];
}

@end
