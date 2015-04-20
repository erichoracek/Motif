//
//  UIColor+LightnessType.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 1/2/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "UIColor+LightnessType.h"

@implementation UIColor (LightnessType)

- (MTFLightnessType)mtf_lightnessType {
    // Color lightness (luma) formula from
    // http://robots.thoughtbot.com/closer-look-color-lightness
    CGFloat red, blue, green;
    [self getRed:&red green:&green blue:&blue alpha:NULL];
    CGFloat luma = ((0.2126f * red) + (0.7152f * green) + (0.0722f * blue));
    return ((luma > 0.6f) ? MTFLightnessTypeLight : MTFLightnessTypeDark);
}

@end
