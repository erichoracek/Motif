//
//  NSValueTransformer+MotifCGSize.m
//  Motif
//
//  Created by Eric Horacek on 6/4/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "NSValueTransformer+Registration.h"

#import "NSValueTransformer+MotifCGSize.h"

typedef CGSize TransformedValueCType;
static const char * const TransformedValueObjCType = @encode(CGSize);
static NSString * const TypeDescription = @"Size";

@implementation NSValueTransformer (MotifCGSize)

+ (void)load {
    [self
        mtf_registerValueTransformerWithName:MTFSizeFromNumberTransformerName
        transformedValueObjCType:TransformedValueObjCType
        reverseTransformedValueClass:NSNumber.class
        transformationBlock:^(NSNumber *numberValue, NSError **error) {
            typeof(TransformedValueCType) value = {
                .width = numberValue.floatValue,
                .height = numberValue.floatValue,
            };

            return [NSValue value:&value withObjCType:TransformedValueObjCType];
        }];

    [self
        mtf_registerValueTransformerWithName:MTFSizeFromArrayTransformerName
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
                .width = values[0].floatValue,
                .height = values[1].floatValue,
            };

            return [NSValue value:&value withObjCType:TransformedValueObjCType];
        }];

    [self
        mtf_registerValueTransformerWithName:MTFSizeFromDictionaryTransformerName
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

            NSArray<NSString *> *validKeys = @[ @"width", @"height" ];

            // Ensure that the passed properties have valid keys
            NSMutableSet<NSString *> *invalidKeys = [NSMutableSet setWithArray:values.allKeys];
            [invalidKeys minusSet:[NSSet setWithArray:validKeys]];
            if (invalidKeys.count > 0) {
                return [self
                    mtf_populateTransformationError:error
                    withDescriptionFormat:@"%@ invalid dictionary key(s): %@", TypeDescription, invalidKeys];
            }

            typeof(TransformedValueCType) value = {
                .width = values[validKeys[0]].floatValue,
                .height = values[validKeys[1]].floatValue,
            };

            return [NSValue value:&value withObjCType:TransformedValueObjCType];
        }];
}

@end

NSString * const MTFSizeFromNumberTransformerName = @"MTFSizeFromNumberTransformerName";

NSString * const MTFSizeFromArrayTransformerName = @"MTFSizeFromArrayTransformerName";

NSString * const MTFSizeFromDictionaryTransformerName = @"MTFSizeFromDictionaryTransformerName";
