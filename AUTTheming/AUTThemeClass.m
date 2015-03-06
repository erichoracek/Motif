//
//  AUTThemeClass.m
//  AUTTheming
//
//  Created by Eric Horacek on 12/22/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import "AUTThemeClass.h"
#import "AUTThemeClass_Private.h"
#import "AUTTheme.h"
#import "AUTTheme_Private.h"
#import "AUTThemeConstant.h"
#import "NSString+ThemeSymbols.h"

@implementation AUTThemeClass

#pragma mark - NSObject

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
        if (propertyName.aut_isSuperclassProperty) {
            AUTThemeClass *superclass = (AUTThemeClass *)propertyConstant.value;
            [propertiesConstants addEntriesFromDictionary:superclass.resolvedPropertiesConstants];
        } else {
            propertiesConstants[propertyName] = propertyConstant;
        }
    }];
    return [propertiesConstants copy];
}

@end
