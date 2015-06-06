//
//  NSValueTransformer+MTFiOSValueTransformers.m
//  Motif
//
//  Created by Eric Horacek on 5/15/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIColor+HTMLColors.h"
#import "NSValueTransformer+ValueTransformerRegistration.h"

#import "NSValueTransformer+MTFiOSValueTransformers.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSValueTransformer (MTFiOSValueTransformers)

+ (void)load {
    [self
        mtf_registerValueTransformerWithName:MTFColorFromStringTransformerName
        transformedValueClass:UIColor.class
        reverseTransformedValueClass:NSString.class
        returningTransformedValueWithBlock:^UIColor *(NSString *value) {
            return [UIColor mtf_colorWithCSS:value];
        }];

    [self
        mtf_registerValueTransformerWithName:MTFRectFromStringTransformerName
        transformedValueObjCType:@encode(CGRect)
        reverseTransformedValueClass:NSString.class
        returningTransformedValueWithBlock:^NSValue *(NSString *value) {
            return [NSValue valueWithCGRect:CGRectFromString(value)];
        }];

    [self
        mtf_registerValueTransformerWithName:MTFAffineTranformFromStringTransformerName
        transformedValueObjCType:@encode(CGAffineTransform)
        reverseTransformedValueClass:NSString.class
        returningTransformedValueWithBlock:^NSValue *(NSString *value) {
            return [NSValue valueWithCGAffineTransform:CGAffineTransformFromString(value)];
        }];

    [self
        mtf_registerValueTransformerWithName:MTFVectorFromStringTransformerName
        transformedValueObjCType:@encode(CGVector)
        reverseTransformedValueClass:NSString.class
        returningTransformedValueWithBlock:^NSValue *(NSString *value) {
            return [NSValue valueWithCGVector:CGVectorFromString(value)];
        }];
}

@end

NSString * const MTFColorFromStringTransformerName = @"MTFColorFromStringTransformer";

NSString * const MTFEdgeInsetsFromStringTransformerName = @"MTFEdgeInsetsFromStringTransformer";

NSString * const MTFPointFromStringTransformerName = @"MTFPointFromStringTransformer";

NSString * const MTFRectFromStringTransformerName = @"MTFRectFromStringTransformer";

NSString * const MTFSizeFromStringTransformerName = @"MTFSizeFromStringTransformer";

NSString * const MTFAffineTranformFromStringTransformerName = @"MTFAffineTranformFromStringTransformerName";

NSString * const MTFVectorFromStringTransformerName = @"MTFVectorFromStringTransformerName";

NSString * const MTFOffsetFromStringTransformerName = @"MTFOffsetFromStringTransformerName";

NS_ASSUME_NONNULL_END
