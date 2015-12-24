//
//  NSValueTransformer+MotifCGPoint.m
//  Motif
//
//  Created by Eric Horacek on 6/6/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "NSValueTransformer+ValueTransformerRegistration.h"

#import "NSValueTransformer+MotifCGPoint.h"

typedef CGPoint TransformedValueCType;
static const char * const TransformedValueObjCType = @encode(CGPoint);

@implementation NSValueTransformer (MotifCGPoint)

+ (void)load {
    [self
        mtf_registerValueTransformerWithName:MTFPointFromNumberTransformerName
        transformedValueObjCType:TransformedValueObjCType
        reverseTransformedValueClass:NSNumber.class
        returningTransformedValueWithBlock:^(NSNumber *numberValue) {
            typeof(TransformedValueCType) value = {
                .x = numberValue.floatValue,
                .y = numberValue.floatValue,
            };

            return [NSValue value:&value withObjCType:TransformedValueObjCType];
        }];

        [self
         mtf_registerValueTransformerWithName:MTFPointFromArrayTransformerName
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
                 .x = values[0].floatValue,
                 .y = values[1].floatValue,
             };
             
             return [NSValue value:&value withObjCType:TransformedValueObjCType];
        }];

    [self
        mtf_registerValueTransformerWithName:MTFPointFromDictionaryTransformerName
        transformedValueObjCType:TransformedValueObjCType
        reverseTransformedValueClass:NSDictionary.class
        returningTransformedValueWithBlock:^(NSDictionary<NSString *, NSNumber *> *values) {
            for (__unused id value in [values objectEnumerator]) {
                NSAssert(
                    [value isKindOfClass:NSNumber.class],
                    @"Value objects must be kind of class NSNumber");
            }

            NSArray<NSString *> *validProperties = @[@"x", @"y"];

            // Ensure that the passed properties have valid keys
            NSMutableSet<NSString *> *passedInvalidPropertyNames = [NSMutableSet setWithArray:values.allKeys];
            [passedInvalidPropertyNames minusSet:[NSSet setWithArray:validProperties]];
            NSAssert(
                passedInvalidPropertyNames.count == 0,
                @"Invalid property name(s): %@",
                passedInvalidPropertyNames);

            typeof(TransformedValueCType) value = {
                .x = values[validProperties[0]].floatValue,
                .y = values[validProperties[1]].floatValue
            };
            
            return [NSValue value:&value withObjCType:TransformedValueObjCType];
        }];
}

@end

NSString * const MTFPointFromNumberTransformerName = @"MTFPointFromNumberTransformerName";

NSString * const MTFPointFromArrayTransformerName = @"MTFPointFromArrayTransformerName";

NSString * const MTFPointFromDictionaryTransformerName = @"MTFPointFromDictionaryTransformerName";
