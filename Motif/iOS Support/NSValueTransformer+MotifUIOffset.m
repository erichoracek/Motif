//
//  NSValueTransformer+MotifUIOffset.m
//  Motif
//
//  Created by Eric Horacek on 6/6/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "NSValueTransformer+ValueTransformerRegistration.h"

#import "NSValueTransformer+MotifUIOffset.h"

typedef UIOffset TransformedValueCType;
static const char * const TransformedValueObjCType = @encode(UIOffset);

@implementation NSValueTransformer (MotifUIOffset)

+ (void)load {
    [self
        mtf_registerValueTransformerWithName:MTFOffsetFromNumberTransformerName
        transformedValueObjCType:TransformedValueObjCType
        reverseTransformedValueClass:NSNumber.class
        returningTransformedValueWithBlock:^(NSNumber *numberValue) {
            typeof(TransformedValueCType) value = {
                .horizontal = numberValue.floatValue,
                .vertical = numberValue.floatValue,
            };

            return [NSValue value:&value withObjCType:TransformedValueObjCType];
        }];

        [self
            mtf_registerValueTransformerWithName:MTFOffsetFromArrayTransformerName
            transformedValueObjCType:TransformedValueObjCType
            reverseTransformedValueClass:NSArray.class
            returningTransformedValueWithBlock:^(NSArray<NSNumber *> *values) {
                NSAssert(values.count == 2, @"Values array must have two elements");

                for (__unused id value in values) {
                    NSAssert(
                        [value isKindOfClass:NSNumber.class],
                        @"Value elements must be kind of class NSNumber");
                }

                typeof(TransformedValueCType) value = {
                    .horizontal = values[0].floatValue,
                    .vertical = values[1].floatValue,
                };
                
                return [NSValue value:&value withObjCType:TransformedValueObjCType];
            }];

        [self
            mtf_registerValueTransformerWithName:MTFOffsetFromDictionaryTransformerName
            transformedValueObjCType:TransformedValueObjCType
            reverseTransformedValueClass:NSDictionary.class
            returningTransformedValueWithBlock:^(NSDictionary<NSString *, NSNumber *> *values) {
                for (__unused id value in [values objectEnumerator]) {
                    NSAssert(
                        [value isKindOfClass:NSNumber.class],
                        @"Value objects must be kind of class NSNumber");
                }

                NSArray<NSString *> *validProperties = @[@"horizontal", @"vertical"];

                // Ensure that the passed properties have valid keys
                NSMutableSet<NSString *> *passedInvalidPropertyNames = [NSMutableSet setWithArray:values.allKeys];
                [passedInvalidPropertyNames minusSet:[NSSet setWithArray:validProperties]];
                NSAssert(
                    passedInvalidPropertyNames.count == 0,
                    @"Invalid property name(s): %@",
                    passedInvalidPropertyNames);

                typeof(TransformedValueCType) value = {
                    .horizontal = values[validProperties[0]].floatValue,
                    .vertical = values[validProperties[1]].floatValue,
                };
                
                return [NSValue value:&value withObjCType:TransformedValueObjCType];
            }];
}

@end

NSString * const MTFOffsetFromNumberTransformerName = @"MTFOffsetFromNumberTransformerName";

NSString * const MTFOffsetFromArrayTransformerName = @"MTFOffsetFromArrayTransformerName";

NSString * const MTFOffsetFromDictionaryTransformerName = @"MTFOffsetFromDictionaryTransformerName";
