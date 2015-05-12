//
//  MTFThemeClass.m
//  Motif
//
//  Created by Eric Horacek on 12/22/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import "MTFRuntimeExtensions.h"
#import "MTFThemeClass.h"
#import "MTFThemeClass_Private.h"
#import "MTFTheme.h"
#import "MTFTheme_Private.h"
#import "MTFThemeConstant.h"
#import "NSString+ThemeSymbols.h"
#import "NSValueTransformer+TypeFiltering.h"
#import "MTFThemeClassApplicable.h"
#import "NSObject+ThemeClassAppliersPrivate.h"
#import "NSObject+ThemeClassName.h"

@implementation MTFThemeClass

#pragma mark - NSObject

- (instancetype)init {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    // Ensure that exception is thrown when just `init` is called.
    return [self initWithName:nil propertiesConstants:nil];
#pragma clang diagnostic pop
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:self.class]) {
        return NO;
    }
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

@dynamic properties;

- (NSDictionary *)properties {
    NSMutableDictionary *properties = [NSMutableDictionary new];
    [self.resolvedPropertiesConstants enumerateKeysAndObjectsUsingBlock:^(
        NSString *name,
        MTFThemeConstant *constant,
        BOOL *_) {
            properties[name] = constant.value;
        }];
    return [properties copy];
}

- (BOOL)applyToObject:(id)object {
    NSParameterAssert(object);
    
    if (!object) {
        return NO;
    }
    
    NSDictionary *properties = self.properties;
    NSMutableSet *unappliedProperties = [NSMutableSet
        setWithArray:properties.allKeys];
    
    // Apply each of the class appliers registered on the applicant's class
    NSArray *classAppliers = [[object class] mtf_themeClassAppliers];
    for (id <MTFThemeClassApplicable> classApplier in classAppliers) {
        if ([classApplier shouldApplyClass:self]) {
            [classApplier applyClass:self toObject:object];
            NSSet *appliedProperties = [NSSet
                setWithArray:classApplier.properties];
            [unappliedProperties minusSet:appliedProperties];
        }
    }
    
    // If no theme class appliers were found, attempt to locate a property on
    // the applicant's class with the same name as the theme class property. If
    // one is found, us KVC to set its value.
    for (NSString *property in [unappliedProperties copy]) {
        
        // Traverse the class hierarchy from the applicant's class up by
        // superclass
        Class applicantClass = [object class];
        do {
            // Locate any properties of the same name on the applicant's class
            // hierarchy
            objc_property_t objc_property = class_getProperty(
                applicantClass,
                property.UTF8String);
            
            if (objc_property == NULL) {
                continue;
            }
            
            // Create a property attributes struct to figure out attributes of
            // the properties
            mtf_propertyAttributes *propertyAttributes = NULL;
            propertyAttributes = mtf_copyPropertyAttributes(objc_property);
            if (propertyAttributes == NULL) {
                continue;
            }
            
            Class propertyClass = propertyAttributes->objectClass;
            const char *propertyObjCType = propertyAttributes->type;
            id value = properties[property];
            
            // Locate a value transformer that can be used to transform from the
            // theme class property value to the type of the property that was
            // located
            NSValueTransformer *valueTransformer;
            if (propertyClass) {
                valueTransformer = [NSValueTransformer
                    mtf_valueTransformerForTransformingObject:value
                    toClass:propertyClass];
            } else if (propertyObjCType) {
                valueTransformer = [NSValueTransformer
                    mtf_valueTransformerForTransformingObject:value
                    toObjCType:propertyObjCType];
            }
            
            free(propertyAttributes);
            
            // If a value transformer is found, use KVC to set the transformed
            // theme class property value on the applicant object, and break
            // out of this loop
            if (valueTransformer) {
                id transformedValue = [valueTransformer transformedValue:value];
                [object setValue:transformedValue forKey:property];
                [unappliedProperties minusSet:[NSSet setWithObject:property]];
                break;
            }
            
            id propertyValue = [object valueForKey:property];
            BOOL isPropertyTypeThemeClass = (propertyClass == MTFThemeClass.class);
            BOOL isValueThemeClass = [value isKindOfClass:MTFThemeClass.class];

            // If the property currently set to a value and the property being
            // applied is a theme class reference, directly apply the theme
            // class to the property value, unless the property type is a theme
            // class
            if (propertyValue && isValueThemeClass && !isPropertyTypeThemeClass) {
                MTFThemeClass *themeClass = (MTFThemeClass *)value;
                [themeClass applyToObject:propertyValue];
                [unappliedProperties minusSet:[NSSet setWithObject:property]];
                break;
            }
            
        } while ((applicantClass = [applicantClass superclass]));
    }
    
    // If no appliers are found for properties specified in the class, attempt
    // to set the property value via setValue:forKeyPath:
    for (NSString *property in [unappliedProperties copy]) {
        // Must be wrapped in try-catch, since setValue:forKeyPath: throws
        // exceptions when keyPath doesn't exist
        @try {
            id value = properties[property];
            [object setValue:value forKeyPath:property];
        }
        @catch (NSException *exception) {
            __unused NSString *className = NSStringFromClass([object class]);
            NSAssert(
                NO,
                @"Failed to apply the theme class named '%@' to an instance of "
                    "'%@'. '%@' or any of its ancestors must either:\n"
                    "- Have a readwrite property named '%@'\n"
                    "- Have an applier block registered for the '%@' property\n"
                    "- Be key-value coding compliant for setting the key '%@'",
                self.name,
                className,
                className,
                property,
                property,
                property);
        }
    }
    
    [object mtf_setThemeClassName:self.name];
    
    return YES;
}

#pragma mark Private

@synthesize propertiesConstants = _propertiesConstants;

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

- (instancetype)initWithName:(NSString *)name propertiesConstants:(NSDictionary *)propertiesConstants {
    self = [super init];
    if (self) {
        _name = name;
        _propertiesConstants = propertiesConstants;
    }
    return self;
}

@dynamic resolvedPropertiesConstants;

- (NSDictionary *)resolvedPropertiesConstants {
    NSMutableDictionary *propertiesConstants = [NSMutableDictionary new];
    [self.propertiesConstants enumerateKeysAndObjectsUsingBlock:^(
        NSString *name,
        MTFThemeConstant *constant,
        BOOL *_) {
            // Resolve references to superclass into the properties constants
            // dictionary
            if (name.mtf_isSuperclassProperty) {
                MTFThemeClass *superclass = (MTFThemeClass *)constant.value;
                // In the case of the symbol generator, the superclasses could
                // not be resolved, and thus may strings rather than references
                if ([superclass isKindOfClass:MTFThemeClass.class]) {
                    NSMutableDictionary *superclassProperties = [superclass.resolvedPropertiesConstants mutableCopy];
                    // Ensure that subclasses are able to override properties
                    // by removing keys from the resolved properties constants
                    [superclassProperties removeObjectsForKeys:propertiesConstants.allKeys];
                    [propertiesConstants
                        addEntriesFromDictionary:superclassProperties];
                }
            } else {
                propertiesConstants[name] = constant;
            }
        }];
    return [propertiesConstants copy];
}

@end
