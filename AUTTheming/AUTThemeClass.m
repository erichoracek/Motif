//
//  AUTThemeClass.m
//  AUTTheming
//
//  Created by Eric Horacek on 12/22/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <libextobjc/EXTRuntimeExtensions.h>
#import "AUTThemeClass.h"
#import "AUTThemeClass_Private.h"
#import "AUTTheme.h"
#import "AUTTheme_Private.h"
#import "AUTThemeConstant.h"
#import "NSString+ThemeSymbols.h"
#import "NSValueTransformer+TypeFiltering.h"
#import "AUTThemeClassApplicable.h"
#import "NSObject+ThemeClassAppliersPrivate.h"
#import "NSObject+ThemeClassName.h"

@implementation AUTThemeClass

#pragma mark - NSObject

- (instancetype)init
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    // Ensure that exception is thrown when just `init` is called.
    self = [self initWithName:nil propertiesConstants:nil];
#pragma clang diagnostic pop
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    return [self isEqualToThemeClass:object];
}

- (NSUInteger)hash
{
    return (self.name.hash ^ self.propertiesConstants.hash);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ {%@: %@, %@: %@}",
        NSStringFromClass([self class]),
        NSStringFromSelector(@selector(name)), self.name,
        NSStringFromSelector(@selector(properties)), self.properties
    ];
}

#pragma mark - AUTThemeClass

#pragma mark Public

@dynamic properties;

- (NSDictionary *)properties
{
    NSMutableDictionary *properties = [NSMutableDictionary new];
    [self.resolvedPropertiesConstants enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, AUTThemeConstant *propertyConstant, BOOL *stop) {
        properties[propertyName] = propertyConstant.value;
    }];
    return [properties copy];
}


- (BOOL)applyToObject:(id)object
{
    NSParameterAssert(object);
    
    if (!object) {
        return NO;
    }
    
    NSDictionary *properties = self.properties;
    NSMutableSet *unappliedProperties = [NSMutableSet setWithArray:properties.allKeys];
    
    // Apply each of the class appliers registered on the applicant's class
    for (id <AUTThemeClassApplicable> classApplier in [[object class] aut_themeClassAppliers]) {
        if ([classApplier shouldApplyClass:self]) {
            [classApplier applyClass:self toObject:object];
            NSSet *appliedProperties = [NSSet setWithArray:classApplier.properties];
            [unappliedProperties minusSet:appliedProperties];
        }
    }
    
    // If no theme class appliers were found, attempt to locate a property on the applicant's class with the same name
    // as the theme class property. If one is found, us KVC to set its value.
    for (NSString *property in [unappliedProperties copy]) {
        
        // Traverse the class hierarchy from the applicant's class up by superclass
        Class applicantClass = [object class];
        do {
            // Locate any properties of the same name on the applicant's class hierarchy
            objc_property_t objc_property = class_getProperty(applicantClass, property.UTF8String);
            if (objc_property == NULL) {
                continue;
            }
            
            // Create a property attributes struct to figure out attributes of the properties
            ext_propertyAttributes *propertyAttributes = ext_copyPropertyAttributes(objc_property);
            if (propertyAttributes == NULL) {
                continue;
            }
            
            Class propertyClass = propertyAttributes->objectClass;
            const char *propertyObjCType = propertyAttributes->type;
            id value = properties[property];
            
            // Locate a value transformer that can be used to transform from the theme class property value to the
            // type of the property that was located
            NSValueTransformer *valueTransformer;
            if (propertyClass) {
                valueTransformer = [NSValueTransformer aut_valueTransformerForTransformingObject:value toClass:propertyClass];
            } else if (propertyObjCType) {
                valueTransformer = [NSValueTransformer aut_valueTransformerForTransformingObject:value toObjCType:propertyObjCType];
            }
            
            free(propertyAttributes);
            
            // If a value transformer is found, use KVC to set the transformed theme class property value on the
            // applicant object, and break out of this loop
            if (valueTransformer) {
                id transformedValue = [valueTransformer transformedValue:value];
                [object setValue:transformedValue forKey:property];
                [unappliedProperties minusSet:[NSSet setWithObject:property]];
                break;
            }
            
            id propertyValue = [object valueForKey:property];
            if (propertyValue && [value isKindOfClass:[AUTThemeClass class]]) {
                AUTThemeClass *themeClass = (AUTThemeClass *)value;
                [themeClass applyToObject:propertyValue];
                [unappliedProperties minusSet:[NSSet setWithObject:property]];
                break;
            }
            
        } while ((applicantClass = [applicantClass superclass]));
    }
    
    // If no appliers are found for properties specified in the class, attempt to set the property value via setValue:forKeyPath:
    for (NSString *property in [unappliedProperties copy]) {
        // Must be wrapped in try-catch, since setValue:forKeyPath: throws exceptions when keyPath doesn't exist
        @try {
            id value = properties[property];
            [object setValue:value forKeyPath:property];
        }
        @catch (NSException *exception) {
            __unused NSString *className = NSStringFromClass([object class]);
            NSAssert3(NO, @"'%@' doesn't have a theme applier for the property '%@' or doesn't implement the keypath '%@'. You must support one of them.", className, property, property);
        }
    }
    
    [object aut_setThemeClassName:self.name];
    
    return YES;
}

#pragma mark Private

- (BOOL)isEqualToThemeClass:(AUTThemeClass *)themeClass
{
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

- (instancetype)initWithName:(NSString *)name propertiesConstants:(NSDictionary *)propertiesConstants
{
    self = [super init];
    if (self) {
        self.name = name;
        self.propertiesConstants = propertiesConstants;
    }
    return self;
}

@dynamic resolvedPropertiesConstants;

- (NSDictionary *)resolvedPropertiesConstants
{
    NSMutableDictionary *propertiesConstants = [NSMutableDictionary new];
    [self.propertiesConstants enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, AUTThemeConstant *propertyConstant, BOOL *stop) {
        // Resolve references to superclass into the properties constants dictionary
        if (propertyName.aut_isSuperclassProperty && [propertyConstant.value isKindOfClass:[AUTThemeClass class]]) {
            AUTThemeClass *superclass = (AUTThemeClass *)propertyConstant.value;
            [propertiesConstants addEntriesFromDictionary:superclass.resolvedPropertiesConstants];
        } else {
            propertiesConstants[propertyName] = propertyConstant;
        }
    }];
    return [propertiesConstants copy];
}

@end
