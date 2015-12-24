//
//  MTFThemeClassPropertiesApplier.m
//  Motif
//
//  Created by Eric Horacek on 6/7/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <objc/runtime.h>

#import "NSDictionary+IntersectingKeys.h"
#import "NSValueTransformer+TypeFiltering.h"

#import "MTFThemeConstant.h"
#import "MTFThemeClass_Private.h"
#import "MTFThemeClassPropertyApplier.h"

#import "MTFThemeClassPropertiesApplier.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MTFThemeClassPropertiesApplier

#pragma mark - Lifecycle

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Use the designated initializer instead" userInfo:nil];
}

- (instancetype)initWithProperties:(NSArray<NSString *> *)properties applierBlock:(MTFThemePropertiesApplierBlock)applierBlock {
    NSParameterAssert(properties != nil);
    NSParameterAssert(applierBlock != nil);
    
    self = [super init];

    _properties = [[NSArray alloc] initWithArray:properties copyItems:YES];
    _applierBlock = [applierBlock copy];

    return self;
}

#pragma mark - MTFThemeClassPropertiesApplier

- (BOOL)shouldApplyClass:(MTFThemeClass *)themeClass {
    NSSet<NSString *> *applierPropertiesKeys = [NSSet setWithArray:self.properties];
    NSSet<NSString *> *classPropertiesKeys = [NSSet setWithArray:themeClass.properties.allKeys];

    // Only apply when all keys are present
    return [applierPropertiesKeys isSubsetOfSet:classPropertiesKeys];
}

#pragma mark - MTFThemeClassPropertiesApplier <MTFThemeClassApplicable>

@synthesize properties = _properties;

- (BOOL)applyClass:(MTFThemeClass *)themeClass toObject:(id)object {
    NSParameterAssert(themeClass != nil);
    NSParameterAssert(object != nil);

    if (![self shouldApplyClass:themeClass]) return NO;

    NSMutableDictionary<NSString *, id> *valuesForProperties = [[NSMutableDictionary alloc] init];
    NSDictionary<NSString *, id> *properties = themeClass.properties;

    [self.properties enumerateObjectsUsingBlock:^(NSString *property, NSUInteger index, BOOL *stop) {
        id value = properties[property];

        if (value != nil) {
            valuesForProperties[property] = value;
        }
    }];
    
    self.applierBlock([valuesForProperties copy], object);

    return YES;
}

@end

@implementation MTFThemeClassTypedValuesPropertiesApplier

#pragma mark - Lifecycle

- (instancetype)initWithProperties:(NSArray<NSString *> *)properties applierBlock:(MTFThemePropertiesApplierBlock)applierBlock {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Use the designated initializer instead" userInfo:nil];
}

- (instancetype)initWithProperties:(NSArray<NSString *> *)properties valueTypes:(NSArray *)valueTypes applierBlock:(MTFThemePropertiesApplierBlock __nonnull)applierBlock {
    NSParameterAssert(valueTypes);
    NSAssert(
        properties.count == valueTypes.count,
        @"Properties and value classes/ObjC types must be of same length");

    for (__unused id valueClassOrObjCType in valueTypes) {
        NSAssert(
            class_isMetaClass(object_getClass(valueClassOrObjCType)) ||
            [valueClassOrObjCType isKindOfClass:NSString.class],
            @"valueTypes must be either a class or an Objective-C "
                "type.");
    }

    self = [super initWithProperties:properties applierBlock:applierBlock];

    _valueTypes = [valueTypes copy];

    return self;
}

#pragma mark - MTFThemeClassTypedValuesPropertiesApplier

- (nullable Class)classForPropertyAtIndex:(NSUInteger)index {
    Class class = self.valueTypes[index];
    
    // Check for whether the passed object is of type Class
    if (class_isMetaClass(object_getClass(class))) return class;

    return nil;
}

- (nullable const char *)objCTypeForPropertyAtIndex:(NSUInteger)index {
    NSString *name = self.valueTypes[index];

    if ([name isKindOfClass:NSString.class]) return name.UTF8String;

    return nil;
}

#pragma mark - MTFThemeClassTypedValuesPropertiesApplier

- (BOOL)applyClass:(MTFThemeClass *)themeClass toObject:(id)object {
    NSParameterAssert(themeClass != nil);
    NSParameterAssert(object != nil);

    if (![self shouldApplyClass:themeClass]) return NO;

    NSMutableDictionary<NSString *, id> *valuesForProperties = [[NSMutableDictionary alloc] init];

    __block BOOL shouldApply = YES;
    [self.properties enumerateObjectsUsingBlock:^(NSString *property, NSUInteger index, BOOL *stop) {
        Class valueClass = [self classForPropertyAtIndex:index];
        const char *objCType = [self objCTypeForPropertyAtIndex:index];
        id value;

        if (valueClass != Nil) {
            value = [MTFThemeClassValueClassPropertyApplier
                valueForApplyingProperty:property
                withValueClass:valueClass
                fromThemeClass:themeClass];
        } else if (objCType != NULL) {
            value = [MTFThemeClassValueObjCTypePropertyApplier
                valueForApplyingProperty:property
                withValueObjCType:objCType
                fromThemeClass:themeClass];
        }

        if (value == nil) {
            shouldApply = NO;
            *stop = YES;
            return;
        } else {
            valuesForProperties[property] = value;
            return;
        }
    }];

    if (!shouldApply) return NO;
    
    self.applierBlock([valuesForProperties copy], object);

    return YES;
}

@end

NS_ASSUME_NONNULL_END
