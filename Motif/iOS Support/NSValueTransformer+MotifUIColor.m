//
//  NSValueTransformer+MotifUIColor.m
//  Motif
//
//  Created by Eric Horacek on 6/7/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "UIColor+HTMLColors.h"
#import "NSValueTransformer+ValueTransformerRegistration.h"

#import "NSValueTransformer+MotifUIColor.h"

@implementation NSValueTransformer (MotifUIColor)

+ (void)load {
    [self
        mtf_registerValueTransformerWithName:MTFColorFromStringTransformerName
        transformedValueClass:UIColor.class
        reverseTransformedValueClass:NSString.class
        returningTransformedValueWithBlock:^UIColor *(NSString *value) {
            return [UIColor mtf_colorWithCSS:value];
        }];
}

NSString * const MTFColorFromStringTransformerName = @"MTFColorFromStringTransformerName";

@end
