//
//  UINavigationBar+Theming.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 1/2/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import <AUTTheming/AUTTheming.h>
#import "ThemeSymbols.h"
#import "UINavigationBar+Theming.h"
#import "UIColor+LightnessType.h"
#import "UILabel+Theming.h"

@implementation UINavigationBar (Theming)

+ (void)load {
    [self
        aut_registerThemeProperty:NavigationThemeProperties.backgroundColor
        valueTransformerName:AUTColorFromStringTransformerName
        applierBlock:^(UIColor *color, UINavigationBar *navigationBar) {
            navigationBar.barTintColor = color;
            navigationBar.barStyle = [navigationBar aut_barStyleForColor:color];
            // Translucency must be set to NO for an opaque background color to appear correctly
            navigationBar.translucent = NO;
    }];
    
    [self
        aut_registerThemeProperty:NavigationThemeProperties.text
        requiringValueOfClass:AUTThemeClass.class
        applierBlock:^(AUTThemeClass *themeClass, UINavigationBar *navigationBar) {
            navigationBar.titleTextAttributes = [UILabel aut_textAttributesForThemeClass:themeClass];
    }];
    
    [self
        aut_registerThemeProperty:NavigationThemeProperties.separatorColor
        valueTransformerName:AUTColorFromStringTransformerName
        applierBlock:^(UIColor *color, UINavigationBar *navigationBar) {
            [navigationBar aut_setShadowColor:color];
    }];
}

- (UIBarStyle)aut_barStyleForColor:(UIColor *)color {
    switch (color.aut_lightnessType) {
    case AUTLightnessTypeDark:
        return UIBarStyleBlack;
    case AUTLightnessTypeLight:
    default:
        return UIBarStyleDefault;
    }
}

- (void)aut_setShadowColor:(UIColor *)color {
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
