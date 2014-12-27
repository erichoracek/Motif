//
//  AUTThemeClass.m
//  AUTTheming
//
//  Created by Eric Horacek on 12/22/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import "AUTThemeClass.h"
#import "AUTThemeClass+Private.h"
#import "AUTTheme.h"
#import "AUTTheme+Private.h"
#import "AUTThemeConstant.h"

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

#pragma mark - AUTThemeClass

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

@dynamic properties;

- (NSDictionary *)properties
{
    NSMutableDictionary *properties = [NSMutableDictionary new];
    [self.propertiesConstants enumerateKeysAndObjectsUsingBlock:^(id key, AUTThemeConstant *themeConstant, BOOL *stop) {
        if ([key isEqualToString:AUTThemeSuperclassKey]) {
            AUTThemeClass *superclass = themeConstant.mappedValue;
            [properties addEntriesFromDictionary:superclass.properties];
        } else {
            properties[key] = themeConstant.mappedValue;
        }
    }];
    return [properties copy];
}

@dynamic resolvedPropertiesConstants;

- (NSDictionary *)resolvedPropertiesConstants
{
    NSMutableDictionary *propertiesConstants = [NSMutableDictionary new];
    [self.propertiesConstants enumerateKeysAndObjectsUsingBlock:^(id key, AUTThemeConstant *themeConstant, BOOL *stop) {
        if ([key isEqualToString:AUTThemeSuperclassKey]) {
            AUTThemeClass *superclass = themeConstant.mappedValue;
            [propertiesConstants addEntriesFromDictionary:superclass.resolvedPropertiesConstants];
        }
        propertiesConstants[key] = themeConstant;
    }];
    return [propertiesConstants copy];
}

@end
