//
//  NSValueTransformer+MotifCGPoint.m
//  Motif
//
//  Created by Eric Horacek on 6/6/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "NSValueTransformer+Registration.h"

#import "NSValueTransformer+MotifCGPoint.h"

typedef CGPoint TransformedValueCType;
static const char * const TransformedValueObjCType = @encode(CGPoint);
static NSString * const TypeDescription = @"Point";

@implementation NSValueTransformer (MotifCGPoint)

+ (void)load {
    [self
        mtf_registerValueTransformerWithName:MTFPointFromNumberTransformerName
        transformedValueObjCType:TransformedValueObjCType
        reverseTransformedValueClass:NSNumber.class
        transformationBlock:^(NSNumber *numberValue, NSError **error) {
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
         transformationBlock:^ NSValue * (NSArray<NSNumber *> *values, NSError **error) {
            if (values.count != 2) {
                return [self
                    mtf_populateTransformationError:error
                    withDescriptionFormat:@"%@ array must have two elements", TypeDescription];
            }

            for (id value in values) {
                if (![value isKindOfClass:NSNumber.class]) {
                    return [self
                        mtf_populateTransformationError:error
                        withDescriptionFormat:@"%@ array elements must be kind of class NSNumber", TypeDescription];
                }
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
        transformationBlock:^ NSValue * (NSDictionary<NSString *, NSNumber *> *values, NSError **error) {
            for (id value in [values objectEnumerator]) {
                if (![value isKindOfClass:NSNumber.class]) {
                    return [self
                        mtf_populateTransformationError:error
                        withDescriptionFormat:@"%@ dictionary values must be kind of class NSNumber", TypeDescription];
                }
            }

            NSArray<NSString *> *validKeys = @[ @"x", @"y" ];

            // Ensure that the passed properties have valid keys
            NSMutableSet<NSString *> *invalidKeys = [NSMutableSet setWithArray:values.allKeys];
            [invalidKeys minusSet:[NSSet setWithArray:validKeys]];
            if (invalidKeys.count > 0) {
                return [self
                    mtf_populateTransformationError:error
                    withDescriptionFormat:@"%@ invalid dictionary key(s): %@", TypeDescription, invalidKeys];
            }

            typeof(TransformedValueCType) value = {
                .x = values[validKeys[0]].floatValue,
                .y = values[validKeys[1]].floatValue
            };
            
            return [NSValue value:&value withObjCType:TransformedValueObjCType];
        }];
}

@end

NSString * const MTFPointFromNumberTransformerName = @"MTFPointFromNumberTransformerName";

NSString * const MTFPointFromArrayTransformerName = @"MTFPointFromArrayTransformerName";

NSString * const MTFPointFromDictionaryTransformerName = @"MTFPointFromDictionaryTransformerName";
