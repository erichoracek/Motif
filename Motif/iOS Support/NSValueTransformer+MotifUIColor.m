//
//  NSValueTransformer+MotifUIColor.m
//  Motif
//
//  Created by Eric Horacek on 6/7/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "UIColor+HTMLColors.h"
#import "NSValueTransformer+Registration.h"

#import "NSValueTransformer+MotifUIColor.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSValueTransformer (MotifUIColor)

+ (void)load {
    [self
        mtf_registerValueTransformerWithName:MTFColorFromStringTransformerName
        transformedValueClass:UIColor.class
        reverseTransformedValueClass:NSString.class
        transformationBlock:^ UIColor * (NSString *value, NSError **error) {
            UIColor *color = [UIColor mtf_colorWithCSS:value];

            if (color != nil) return color;

            return [self
                mtf_populateTransformationError:error
                withDescriptionFormat:@"Unable to parse color from string '%@'", value];
        }];
}

NSString * const MTFColorFromStringTransformerName = @"MTFColorFromStringTransformerName";

@end

NS_ASSUME_NONNULL_END
