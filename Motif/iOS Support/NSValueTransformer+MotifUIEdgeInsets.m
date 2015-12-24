//
//  NSValueTransformer+MotifUIEdgeInsets.m
//  Motif
//
//  Created by Eric Horacek on 6/2/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "NSValueTransformer+ValueTransformerRegistration.h"

#import "NSValueTransformer+MotifUIEdgeInsets.h"

typedef UIEdgeInsets TransformedValueCType;
static const char * const TransformedValueObjCType = @encode(TransformedValueCType);

@implementation NSValueTransformer (MotifUIEdgeInsets)

+ (void)load {
    [self
        mtf_registerValueTransformerWithName:MTFEdgeInsetsFromNumberTransformerName
        transformedValueObjCType:TransformedValueObjCType
        reverseTransformedValueClass:NSNumber.class
        returningTransformedValueWithBlock:^(NSNumber *numberValue) {
            typeof(TransformedValueCType) value = {
                .top = numberValue.floatValue,
                .left = numberValue.floatValue,
                .bottom = numberValue.floatValue,
                .right = numberValue.floatValue,
            };

            return [NSValue value:&value withObjCType:TransformedValueObjCType];
        }];

    [self
        mtf_registerValueTransformerWithName:MTFEdgeInsetsFromArrayTransformerName
        transformedValueObjCType:TransformedValueObjCType
        reverseTransformedValueClass:NSArray.class
        returningTransformedValueWithBlock:^(NSArray<NSNumber *> *values) {
            NSAssert(values.count <= 4, @"Values array must have at most four elements");
            NSAssert(values.count > 1, @"Values array must have more than one elements");

            for (__unused id value in values) {
                NSAssert(
                    [value isKindOfClass:NSNumber.class],
                    @"Value elements must be kind of class NSNumber");
            }

            typeof(TransformedValueCType) value = {
                .top = values[0].floatValue,
                .right = values[1].floatValue,
            };

            if (values.count == 2) {
                value.bottom = values[0].floatValue;
                value.left = values[1].floatValue;
            } else {
                value.bottom = values[2].floatValue;
                value.left = (values.count == 4) ? values[3].floatValue : 0.0f;
            }

            return [NSValue value:&value withObjCType:TransformedValueObjCType];
        }];

    [self
        mtf_registerValueTransformerWithName:MTFEdgeInsetsFromDictionaryTransformerName
        transformedValueObjCType:TransformedValueObjCType
        reverseTransformedValueClass:NSDictionary.class
        returningTransformedValueWithBlock:^(NSDictionary<NSString *, NSNumber *> *values) {
            for (__unused id value in [values objectEnumerator]) {
                NSAssert(
                    [value isKindOfClass:NSNumber.class],
                    @"Value objects must be kind of class NSNumber");
            }

            NSArray<NSString *> *validProperties = @[@"top", @"right", @"bottom", @"left"];

            // Ensure that the passed properties have valid keys
            NSMutableSet<NSString *> *passedInvalidPropertyNames = [NSMutableSet setWithArray:values.allKeys];
            [passedInvalidPropertyNames minusSet:[NSSet setWithArray:validProperties]];
            NSAssert(
                passedInvalidPropertyNames.count == 0,
                @"Invalid property name(s): %@",
                passedInvalidPropertyNames);

            typeof(TransformedValueCType) value = {
                .top = values[validProperties[0]].floatValue,
                .right = values[validProperties[1]].floatValue,
                .bottom = values[validProperties[2]].floatValue,
                .left = values[validProperties[3]].floatValue,
            };

            return [NSValue value:&value withObjCType:TransformedValueObjCType];
        }];
}

@end

NSString * const MTFEdgeInsetsFromNumberTransformerName = @"MTFEdgeInsetsFromNumberTransformerName";

NSString * const MTFEdgeInsetsFromArrayTransformerName = @"MTFEdgeInsetsFromArrayTransformerName";

NSString * const MTFEdgeInsetsFromDictionaryTransformerName = @"MTFEdgeInsetsFromDictionaryTransformerName";
