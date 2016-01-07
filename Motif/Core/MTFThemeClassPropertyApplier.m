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
#import "MTFErrors.h"

#import "MTFThemeClassPropertyApplier.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MTFThemeClassPropertyApplier

#pragma mark - Lifecycle

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Use the designated initializer instead" userInfo:nil];
}

- (instancetype)initWithProperty:(NSString *)property applierBlock:(MTFThemePropertyApplierBlock)applierBlock {
    NSParameterAssert(property != nil);
    NSParameterAssert(applierBlock != nil);

    self = [super init];

    _property = [property copy];
    _applierBlock = [applierBlock copy];

    return self;
}

#pragma mark - MTFThemePropertyApplier <MTFThemeClassApplicable>

- (nullable NSSet<NSString *> *)applyClass:(MTFThemeClass *)themeClass to:(id)applicant error:(NSError **)error {
    NSParameterAssert(themeClass != nil);
    NSParameterAssert(applicant != nil);

    id value = themeClass.properties[self.property];
    if (value == nil) return [NSSet set];

    return self.applierBlock(value, applicant, error) ? self.properties : nil;
}

- (NSSet<NSString *> *)properties {
    return [NSSet setWithObject:self.property];
}

@end

@implementation MTFThemeClassValueClassPropertyApplier

#pragma mark - Lifecycle

- (instancetype)initWithProperty:(NSString *)property valueClass:(Class)valueClass applierBlock:(MTFThemePropertyApplierBlock)applierBlock {
    NSParameterAssert(property != nil);
    NSParameterAssert(valueClass != Nil);
    NSParameterAssert(applierBlock != nil);

    self = [super initWithProperty:property applierBlock:applierBlock];

    _valueClass = valueClass;

    return self;
}

#pragma mark - MTFThemePropertyApplier <MTFThemeClassApplicable>

- (nullable NSSet<NSString *> *)applyClass:(MTFThemeClass *)themeClass to:(id)applicant error:(NSError **)error {
    NSParameterAssert(themeClass != nil);
    NSParameterAssert(applicant != nil);

    NSDictionary<NSString *, id> *transformedValueByProperty = [self.class
        valueForApplyingProperty:self.property
        asClass:self.valueClass
        fromThemeClass:themeClass
        error:error];

    if (transformedValueByProperty == nil) return nil;
    if (transformedValueByProperty.count == 0) return [NSSet set];

    id transformedValue = transformedValueByProperty[self.property];
    return self.applierBlock(transformedValue, applicant, error) ? self.properties : nil;
}

#pragma mark - MTFThemeClassValueClassPropertyApplier

+ (nullable NSDictionary<NSString *, id> *)valueForApplyingProperty:(NSString *)property asClass:(Class)valueClass fromThemeClass:(MTFThemeClass *)themeClass error:(NSError **)error {
    NSParameterAssert(property != nil);
    NSParameterAssert(valueClass != Nil);
    NSParameterAssert(themeClass != nil);

    MTFThemeConstant *constant = themeClass.resolvedPropertiesConstants[property];
    if (constant == nil) return [NSDictionary dictionary];

    id value = constant.value;
    if ([value isKindOfClass:valueClass]) return @{ property: value };

    NSValueTransformer *transformer = [NSValueTransformer
        mtf_valueTransformerForTransformingObject:value
        toClass:valueClass];

    if (transformer == nil) {
        if (error != NULL) {
            NSString *description = [NSString stringWithFormat:
                @"Unable to locate a value transformer to transform from %@ "\
                    "to %@ for property '%@'. Ensure that a value transformer "\
                    "capable of this transformation is registered via one of "\
                    "the mtf_registerValueTransformerWithName... methods.",
                [constant.value class],
                valueClass,
                property];

            *error = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToApplyTheme userInfo:@{
                NSLocalizedDescriptionKey: description,
            }];
        }

        return nil;
    }

    NSValue *transformedValue = [constant transformedValueFromTransformer:transformer error:error];
    if (transformedValue == nil) return nil;

    return @{ property: transformedValue };
}

@end

@implementation MTFThemeClassValueObjCTypePropertyApplier

#pragma mark - Lifecycle

- (instancetype)initWithProperty:(NSString *)property valueObjCType:(const char *)valueObjCType applierBlock:(MTFThemePropertyApplierBlock)applierBlock {
    NSParameterAssert(applierBlock != nil);
    NSParameterAssert(valueObjCType != NULL);
    NSParameterAssert(applierBlock != nil);

    self = [super initWithProperty:property applierBlock:applierBlock];

    _valueObjCType = valueObjCType;

    return self;
}

#pragma mark - MTFThemePropertyApplier <MTFThemeClassApplicable>

- (nullable NSSet<NSString *> *)applyClass:(MTFThemeClass *)themeClass to:(id)applicant error:(NSError **)error {
    NSParameterAssert(themeClass != nil);
    NSParameterAssert(applicant != nil);

    NSDictionary<NSString *, id> *transformedValueByProperty = [self.class
        valueForApplyingProperty:self.property
        asObjCType:self.valueObjCType
        fromThemeClass:themeClass
        error:error];

    if (transformedValueByProperty == nil) return nil;
    if (transformedValueByProperty.count == 0) return [NSSet set];

    id transformedValue = transformedValueByProperty[self.property];
    return self.applierBlock(transformedValue, applicant, error) ? self.properties : nil;
}

#pragma mark - MTFThemeClassValueObjCTypePropertyApplier

+ (nullable NSDictionary<NSString *, id> *)valueForApplyingProperty:(NSString *)property asObjCType:(const char *)objCType fromThemeClass:(MTFThemeClass *)themeClass error:(NSError **)error {
    NSParameterAssert(property != nil);
    NSParameterAssert(objCType != NULL);
    NSParameterAssert(themeClass != nil);

    MTFThemeConstant *constant = themeClass.resolvedPropertiesConstants[property];
    if (constant == nil) return [NSDictionary dictionary];

    id value = constant.value;
    if ([value isKindOfClass:NSValue.class]) {
        NSValue *valueAsValue = (NSValue *)value;

        if (strcmp(valueAsValue.objCType, objCType) == 0) return @{ property: value };
    }

    NSValueTransformer *transformer = [NSValueTransformer
        mtf_valueTransformerForTransformingObject:value
        toObjCType:objCType];

    if (transformer == nil) {
        if (error != NULL) {
            NSString *description = [NSString stringWithFormat:
                @"Unable to locate a value transformer to transform from %@ to "\
                    "%@ for property '%@'. Ensure that a value transformer "\
                    "capable of this transformation is registered via one of the "\
                    "mtf_registerValueTransformerWithName... methods.",
                [constant.value class],
                @(objCType),
                property];

            *error = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToApplyTheme userInfo:@{
                NSLocalizedDescriptionKey: description,
            }];
        }

        return nil;
    }

    NSValue *transformedValue = [constant transformedValueFromTransformer:transformer error:error];
    if (transformedValue == nil) return nil;

    return @{ property: transformedValue };
}

@end

NS_ASSUME_NONNULL_END
