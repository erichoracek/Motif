//
//  NSValueTransformer+MotifUIEdgeInsets.m
//  Motif
//
//  Created by Eric Horacek on 6/2/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "NSValueTransformer+Registration.h"

#import "NSValueTransformer+MotifUIEdgeInsets.h"

typedef UIEdgeInsets TransformedValueCType;
static const char * const TransformedValueObjCType = @encode(TransformedValueCType);
static NSString * const TypeDescription = @"Edge insets";

@implementation NSValueTransformer (MotifUIEdgeInsets)

+ (void)load {
    [self
        mtf_registerValueTransformerWithName:MTFEdgeInsetsFromNumberTransformerName
        transformedValueObjCType:TransformedValueObjCType
        reverseTransformedValueClass:NSNumber.class
        transformationBlock:^(NSNumber *numberValue, NSError **error) {
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
        transformationBlock:^ NSValue * (NSArray<NSNumber *> *values, NSError **error) {
            if (values.count > 4) {
                return [self
                    mtf_populateTransformationError:error
                    withDescriptionFormat:@"%@ array must have at most four elements", TypeDescription];
            }

            if (values.count < 2) {
                return [self
                    mtf_populateTransformationError:error
                    withDescriptionFormat:@"%@ array must have more than one element", TypeDescription];
            }

            for (id value in values) {
                if (![value isKindOfClass:NSNumber.class]) {
                    return [self
                        mtf_populateTransformationError:error
                        withDescriptionFormat:@"%@ array elements must be kind of class NSNumber", TypeDescription];
                }
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
        transformationBlock:^ NSValue * (NSDictionary<NSString *, NSNumber *> *values, NSError **error) {
            for (id value in [values objectEnumerator]) {
                if (![value isKindOfClass:NSNumber.class]) {
                    return [self
                        mtf_populateTransformationError:error
                        withDescriptionFormat:@"%@ dictionary values must be kind of class NSNumber", TypeDescription];
                }
            }

            NSArray<NSString *> *validKeys = @[ @"top", @"right", @"bottom", @"left" ];

            // Ensure that the passed properties have valid keys
            NSMutableSet<NSString *> *invalidKeys = [NSMutableSet setWithArray:values.allKeys];
            [invalidKeys minusSet:[NSSet setWithArray:validKeys]];
            if (invalidKeys.count > 0) {
                return [self
                    mtf_populateTransformationError:error
                    withDescriptionFormat:@"%@ invalid dictionary key(s): %@", TypeDescription, invalidKeys];
            }

            typeof(TransformedValueCType) value = {
                .top = values[validKeys[0]].floatValue,
                .right = values[validKeys[1]].floatValue,
                .bottom = values[validKeys[2]].floatValue,
                .left = values[validKeys[3]].floatValue,
            };

            return [NSValue value:&value withObjCType:TransformedValueObjCType];
        }];
}

@end

NSString * const MTFEdgeInsetsFromNumberTransformerName = @"MTFEdgeInsetsFromNumberTransformerName";

NSString * const MTFEdgeInsetsFromArrayTransformerName = @"MTFEdgeInsetsFromArrayTransformerName";

NSString * const MTFEdgeInsetsFromDictionaryTransformerName = @"MTFEdgeInsetsFromDictionaryTransformerName";
