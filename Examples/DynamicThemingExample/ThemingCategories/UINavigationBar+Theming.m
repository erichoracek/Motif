//
//  UINavigationBar+Theming.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 1/2/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import Motif;

#import "UIColor+LightnessType.h"
#import "UILabel+Theming.h"

#import "ThemeSymbols.h"

#import "UINavigationBar+Theming.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UINavigationBar (Theming)

+ (void)load {
    [self
        mtf_registerThemeProperty:NavigationThemeProperties.backgroundColor
        requiringValueOfClass:UIColor.class
        applierBlock:^(UIColor *color, UINavigationBar *navigationBar) {
            navigationBar.barTintColor = color;
            navigationBar.barStyle = [navigationBar mtf_barStyleForColor:color];
            // Translucency must be set to NO for an opaque background color to
            // appear correctly
            navigationBar.translucent = NO;
        }];
    
    [self
        mtf_registerThemeProperty:NavigationThemeProperties.text
        requiringValueOfClass:MTFThemeClass.class
        applierBlock:^(MTFThemeClass *themeClass, UINavigationBar *navigationBar) {
            navigationBar.titleTextAttributes = [UILabel mtf_textAttributesForThemeClass:themeClass];
        }];
    
    [self
        mtf_registerThemeProperty:NavigationThemeProperties.separatorColor
        requiringValueOfClass:UIColor.class
        applierBlock:^(UIColor *color, UINavigationBar *navigationBar) {
            [navigationBar mtf_setShadowColor:color];
        }];
}

- (UIBarStyle)mtf_barStyleForColor:(UIColor *)color {
    switch (color.mtf_lightnessType) {
    case MTFLightnessTypeDark:
        return UIBarStyleBlack;
    case MTFLightnessTypeLight:
    default:
        return UIBarStyleDefault;
    }
}

- (void)mtf_setShadowColor:(UIColor *)color {
    // Create an image of the specified color and set it as the shadow image
    CGRect shadowImageRect = (CGRect){CGPointZero, {1.0, 0.5}};
    UIGraphicsBeginImageContextWithOptions(shadowImageRect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, shadowImageRect);
    UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
    // Allow image to be resized
    shadowImage = [shadowImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    [self setShadowImage:shadowImage];
    // A 'backgroundImage' is required for the shadow image to work.
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

@end

NS_ASSUME_NONNULL_END
