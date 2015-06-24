//
//  MTFThemeClassPropertyApplier.m
//  Motif
//
//  Created by Eric Horacek on 6/7/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "MTFThemeClass.h"
#import "MTFThemeClass_Private.h"
#import "MTFThemeConstant.h"
#import "NSValueTransformer+TypeFiltering.h"

#import "MTFThemeClassPropertyApplier.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MTFThemeClassPropertyApplier

#pragma mark - Lifecycle

- (instancetype)init {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    // Ensure that exception is thrown when just `init` is called.
    return [self initWithProperty:nil applierBlock:nil];
#pragma clang diagnostic pop
}

- (instancetype)initWithProperty:(NSString *)property applierBlock:(MTFThemePropertyApplierBlock)applierBlock {
    NSParameterAssert(property != nil);
    NSParameterAssert(applierBlock != nil);

    self = [super init];
    if (self == nil) return nil;

    _property = [property copy];
    _applierBlock = [applierBlock copy];

    return self;
}

#pragma mark - MTFThemePropertyApplier <MTFThemeClassApplicable>

- (BOOL)applyClass:(MTFThemeClass *)themeClass toObject:(id)object {
    NSParameterAssert(themeClass != nil);
    NSParameterAssert(object != nil);

    id value = themeClass.properties[self.property];
    if (value == nil) return NO;

    self.applierBlock(value, object);

    return YES;
}

- (NSArray *)properties {
    return @[self.property];
}

@end

@implementation MTFThemeClassValueClassPropertyApplier

#pragma mark - Lifecycle

- (instancetype)initWithProperty:(NSString *)property applierBlock:(MTFThemePropertyApplierBlock)applierBlock {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    // Ensure that exception is thrown when just `initWithProperty:applierBlock:` is called.
    return [self initWithProperty:nil valueClass:nil applierBlock:nil];
#pragma clang diagnostic pop
}

- (instancetype)initWithProperty:(NSString *)property valueClass:(Class)valueClass applierBlock:(MTFThemePropertyApplierBlock)applierBlock {
    NSParameterAssert(property != nil);
    NSParameterAssert(valueClass != Nil);
    NSParameterAssert(applierBlock != nil);

    self = [super initWithProperty:property applierBlock:applierBlock];
    if (self == nil) return nil;

    _valueClass = valueClass;

    return self;
}

#pragma mark - MTFThemePropertyApplier <MTFThemeClassApplicable>

- (BOOL)applyClass:(MTFThemeClass *)themeClass toObject:(id)object {
    NSParameterAssert(themeClass != nil);
    NSParameterAssert(object != nil);

    id value = [self.class
        valueForApplyingProperty:self.property
        withValueClass:self.valueClass
        fromThemeClass:themeClass];
        
    if (value == nil) return NO;

    self.applierBlock(value, object);
    return YES;
}

#pragma mark - MTFThemeClassValueClassPropertyApplier

+ (nullable id)valueForApplyingProperty:(NSString *)property withValueClass:(Class)valueClass fromThemeClass:(MTFThemeClass *)themeClass {
    NSParameterAssert(property != nil);
    NSParameterAssert(valueClass != Nil);
    NSParameterAssert(themeClass != nil);

    MTFThemeConstant *constant = themeClass.resolvedPropertiesConstants[property];
    if (constant == nil) return nil;

    id value = constant.value;
    if ([value isKindOfClass:valueClass]) return value;

    NSValueTransformer *transformer = [NSValueTransformer
        mtf_valueTransformerForTransformingObject:value
        toClass:valueClass];

    if (transformer) return [constant transformedValueFromTransformer:transformer];

    return nil;
}

@end

@implementation MTFThemeClassValueObjCTypePropertyApplier

#pragma mark - Lifecycle

- (instancetype)initWithProperty:(NSString *)property applierBlock:(MTFThemePropertyApplierBlock)applierBlock {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    // Ensure that exception is thrown when just `initWithProperty:applierBlock:` is called.
    return [self initWithProperty:nil valueObjCType:NULL applierBlock:nil];
#pragma clang diagnostic pop
}

- (instancetype)initWithProperty:(NSString *)property valueObjCType:(const char *)valueObjCType applierBlock:(MTFThemePropertyApplierBlock)applierBlock {
    NSParameterAssert(applierBlock != nil);
    NSParameterAssert(valueObjCType != NULL);
    NSParameterAssert(applierBlock != nil);

    self = [super initWithProperty:property applierBlock:applierBlock];
    if (self == nil) return nil;

    _valueObjCType = valueObjCType;

    return self;
}

#pragma mark - MTFThemePropertyApplier <MTFThemeClassApplicable>

- (BOOL)applyClass:(MTFThemeClass *)themeClass toObject:(id)object {
    NSParameterAssert(themeClass != nil);
    NSParameterAssert(object != nil);

    id value = [self.class
        valueForApplyingProperty:self.property
        withValueObjCType:self.valueObjCType
        fromThemeClass:themeClass];

    if (value == nil) return NO;

    self.applierBlock(value, object);
    return YES;
}

#pragma mark - MTFThemeClassValueObjCTypePropertyApplier

+ (nullable id)valueForApplyingProperty:(NSString *)property withValueObjCType:(const char *)valueObjCType fromThemeClass:(MTFThemeClass *)themeClass {
    NSParameterAssert(property != nil);
    NSParameterAssert(valueObjCType != NULL);
    NSParameterAssert(themeClass != nil);

    MTFThemeConstant *constant = themeClass.resolvedPropertiesConstants[property];
    if (constant == nil) return nil;

    id value = constant.value;
    if ([value isKindOfClass:NSValue.class]) {
        NSValue *valueAsValue = (NSValue *)value;

        if (strcmp(valueAsValue.objCType, valueObjCType) == 0) return value;
    }

    NSValueTransformer *transformer = [NSValueTransformer
        mtf_valueTransformerForTransformingObject:value
        toObjCType:valueObjCType];

    if (transformer) return [constant transformedValueFromTransformer:transformer];

    return nil;
}

@end

NS_ASSUME_NONNULL_END
