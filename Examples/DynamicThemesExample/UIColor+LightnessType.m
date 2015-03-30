//
//  UIColor+LightnessType.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 1/2/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import "UIColor+LightnessType.h"

@implementation UIColor (LightnessType)

- (AUTLightnessType)aut_lightnessType {
    // Color lightness (luma) formula from http://robots.thoughtbot.com/closer-look-color-lightness
    CGFloat red, blue, green;
    [self getRed:&red green:&green blue:&blue alpha:NULL];
    CGFloat luma = ((0.2126 * red) + (0.7152 * green) + (0.0722 * blue));
    return ((luma > 0.6) ? AUTLightnessTypeLight : AUTLightnessTypeDark);
}

@end
