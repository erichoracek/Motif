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

@interface MTFThemeClassPropertiesApplier ()

@property (readonly, nonatomic, strong) NSOrderedSet *orderedProperties;

@end

@implementation MTFThemeClassPropertiesApplier

#pragma mark - Lifecycle

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Use the designated initializer instead" userInfo:nil];
}

- (instancetype)initWithProperties:(NSArray<NSString *> *)properties applierBlock:(MTFThemePropertiesApplierBlock)applierBlock {
    NSParameterAssert(properties != nil);
    NSParameterAssert(applierBlock != nil);
    
    self = [super init];

    NSArray *copiedProperties = [[NSArray alloc] initWithArray:properties copyItems:YES];
    _orderedProperties = [NSOrderedSet orderedSetWithArray:copiedProperties];
    _applierBlock = [applierBlock copy];

    return self;
}

#pragma mark - MTFThemeClassPropertiesApplier

- (BOOL)shouldApplyValuesByProperties:(NSDictionary<NSString *, id> *)valuesByProperties {
    NSParameterAssert(valuesByProperties != nil);

    NSSet<NSString *> *propertiesToApply = [NSSet setWithArray:valuesByProperties.allKeys];

    // Only apply when all keys are present
    return [self.properties isSubsetOfSet:propertiesToApply];
}

#pragma mark - MTFThemeClassPropertiesApplier <MTFThemeClassApplicable>

- (NSSet<NSString *> *)properties {
    return self.orderedProperties.set;
}

- (nullable NSSet<NSString *> *)applyClass:(MTFThemeClass *)themeClass to:(id)object error:(NSError **)error {
    NSParameterAssert(themeClass != nil);
    NSParameterAssert(object != nil);

    NSDictionary<NSString *, id> *properties = themeClass.properties;
    NSMutableDictionary<NSString *, id> *filteredValuesForProperties = [NSMutableDictionary dictionary];

    [self.orderedProperties enumerateObjectsUsingBlock:^(NSString * property, NSUInteger _, BOOL *stop) {
        id value = properties[property];
        if (value == nil) return;
        filteredValuesForProperties[property] = value;
    }];

    if (![self shouldApplyValuesByProperties:filteredValuesForProperties]) return [NSSet set];
    
    return self.applierBlock([filteredValuesForProperties copy], object, error) ? self.properties : nil;
}

@end

@implementation MTFThemeClassTypedValuesPropertiesApplier

#pragma mark - Lifecycle

- (instancetype)initWithProperties:(NSArray<NSString *> *)properties applierBlock:(MTFThemePropertiesApplierBlock)applierBlock {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Use the designated initializer instead" userInfo:nil];
}

- (instancetype)initWithProperties:(NSArray<NSString *> *)properties valueTypes:(NSArray *)valueTypes applierBlock:(MTFThemePropertiesApplierBlock __nonnull)applierBlock {
    NSParameterAssert(valueTypes != nil);
    NSAssert(properties.count == valueTypes.count, @"Properties and value classes/ObjC types must be of same length");

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

- (nullable NSSet<NSString *> *)applyClass:(MTFThemeClass *)themeClass to:(id)object error:(NSError **)error {
    NSParameterAssert(themeClass != nil);
    NSParameterAssert(object != nil);

    NSMutableDictionary<NSString *, id> *transformedValuesByProperties = [NSMutableDictionary dictionary];

    __block BOOL transformationSuccess = YES;
    __block NSError *transformationError;

    [self.orderedProperties enumerateObjectsUsingBlock:^(NSString *property, NSUInteger index, BOOL *stop) {
        Class valueClass = [self classForPropertyAtIndex:index];
        const char *objCType = [self objCTypeForPropertyAtIndex:index];

        NSDictionary<NSString *, id> *transformedValueByProperty;
        NSError *error;

        if (valueClass != Nil) {
            transformedValueByProperty = [MTFThemeClassValueClassPropertyApplier
                valueForApplyingProperty:property
                asClass:valueClass
                fromThemeClass:themeClass
                error:&error];
        } else if (objCType != NULL) {
            transformedValueByProperty = [MTFThemeClassValueObjCTypePropertyApplier
                valueForApplyingProperty:property
                asObjCType:objCType
                fromThemeClass:themeClass
                error:&error];
        }

        if (transformedValueByProperty == nil) {
            transformationSuccess = NO;
            transformationError = error;
            *stop = YES;
            return;
        }

        [transformedValuesByProperties addEntriesFromDictionary:transformedValueByProperty];
    }];

    if (!transformationSuccess) {
        if (error != NULL) {
            *error = transformationError;
        }
        return nil;
    }

    if (![self shouldApplyValuesByProperties:transformedValuesByProperties]) return [NSSet set];
    
    return self.applierBlock([transformedValuesByProperties copy], object, error) ? self.properties : nil;
}

@end

NS_ASSUME_NONNULL_END
