//
//  NSValueTransformer+MotifCGSize.m
//  Motif
//
//  Created by Eric Horacek on 6/4/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "NSValueTransformer+ValueTransformerRegistration.h"

#import "NSValueTransformer+MotifCGSize.h"

typedef CGSize TransformedValueCType;
static const char * const TransformedValueObjCType = @encode(CGSize);

@implementation NSValueTransformer (MotifCGSize)

+ (void)load {
    [self
        mtf_registerValueTransformerWithName:MTFCGSizeFromNumberTransformerName
        transformedValueObjCType:TransformedValueObjCType
        reverseTransformedValueClass:NSNumber.class
        returningTransformedValueWithBlock:^(NSNumber *numberValue) {
            typeof(TransformedValueCType) value = {
                .width = numberValue.floatValue,
                .height = numberValue.floatValue,
            };

            return [NSValue value:&value withObjCType:TransformedValueObjCType];
        }];

    [self
        mtf_registerValueTransformerWithName:MTFCGSizeFromArrayTransformerName
        transformedValueObjCType:TransformedValueObjCType
        reverseTransformedValueClass:NSArray.class
        returningTransformedValueWithBlock:^(NSArray *values) {
            NSAssert(values.count == 2, @"Values array must have two elements");

            for (__unused id value in values) {
                NSAssert(
                    [value isKindOfClass:NSNumber.class],
                    @"Value elements must be kind of class NSNumber");
            }

            typeof(TransformedValueCType) value = {
                .width = [values[0] floatValue],
                .height = [values[1] floatValue]
            };

            return [NSValue value:&value withObjCType:TransformedValueObjCType];
        }];

    [self
        mtf_registerValueTransformerWithName:MTFCGSizeFromDictionaryTransformerName
        transformedValueObjCType:TransformedValueObjCType
        reverseTransformedValueClass:NSDictionary.class
        returningTransformedValueWithBlock:^(NSDictionary *values) {
            for (__unused id value in [values objectEnumerator]) {
                NSAssert(
                    [value isKindOfClass:NSNumber.class],
                    @"Value objects must be kind of class NSNumber");
            }

            NSArray *validProperties = @[@"width", @"height"];

            // Ensure that the passed properties have valid keys
            NSMutableSet *passedInvalidPropertyNames = [NSMutableSet setWithArray:values.allKeys];
            [passedInvalidPropertyNames minusSet:[NSSet setWithArray:validProperties]];
            NSAssert(
                passedInvalidPropertyNames.count == 0,
                @"Invalid property name(s): %@",
                passedInvalidPropertyNames);

            typeof(TransformedValueCType) value = {
                .width = [values[validProperties[0]] floatValue],
                .height = [values[validProperties[1]] floatValue]
            };

            return [NSValue value:&value withObjCType:TransformedValueObjCType];
        }];
}

@end

NSString * const MTFCGSizeFromNumberTransformerName = @"MTFCGSizeFromNumberTransformerName";

NSString * const MTFCGSizeFromArrayTransformerName = @"MTFCGSizeFromArrayTransformerName";

NSString * const MTFCGSizeFromDictionaryTransformerName = @"MTFCGSizeFromDictionaryTransformerName";
