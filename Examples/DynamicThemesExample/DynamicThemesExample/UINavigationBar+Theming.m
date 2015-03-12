//
//  UINavigationBar+Theming.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 1/2/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import <AUTTheming/AUTTheming.h>
#import <AUTTheming/AUTValueTransformers.h>
#import "ThemeSymbols.h"
#import "UINavigationBar+Theming.h"
#import "UIColor+LightnessType.h"
#import "UILabel+Theming.h"

@implementation UINavigationBar (Theming)

+ (void)load
{
    [self aut_registerThemeProperty:NavigationThemeProperties.backgroundColor valueTransformerName:AUTColorFromStringTransformerName applierBlock:^(UIColor *color, UINavigationBar *navigationBar) {
        navigationBar.barTintColor = color;
        navigationBar.translucent = NO;
        navigationBar.barStyle = [navigationBar aut_barStyleForColor:color];
    }];
        
    [self aut_registerThemeProperty:NavigationThemeProperties.text requiringValueOfClass:[AUTThemeClass class] applierBlock:^(AUTThemeClass *themeClass, UINavigationBar *navigationBar) {
        NSMutableDictionary *titleTextAttributes = (navigationBar.titleTextAttributes ? [navigationBar.titleTextAttributes mutableCopy] : [NSMutableDictionary new]);
        NSDictionary *themeClassTextAttributes = [UILabel aut_textAttributesForThemeClass:themeClass];
        [titleTextAttributes addEntriesFromDictionary:themeClassTextAttributes];
        navigationBar.titleTextAttributes = [titleTextAttributes copy];
    }];
    
    [self aut_registerThemeProperty:NavigationThemeProperties.separatorColor valueTransformerName:AUTColorFromStringTransformerName applierBlock:^(UIColor *color, UINavigationBar *navigationBar) {
        // Create an image of the specified color and set it as the shadow image
        CGRect shadowImageRect = (CGRect){CGPointZero, {1.0, 0.5}};
        UIGraphicsBeginImageContextWithOptions(shadowImageRect.size, NO, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, shadowImageRect);
        UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
        // Allow image to be resized
        shadowImage = [shadowImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
        [navigationBar setShadowImage:shadowImage];
        // A 'backgroundImage' is required for the shadow image to work.
        [navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }];
}

- (UIBarStyle)aut_barStyleForColor:(UIColor *)color
{
    switch (color.lightnessType) {
    case LightnessTypeDark:
        return UIBarStyleBlack;
    case LightnessTypeLight:
    default:
        return UIBarStyleDefault;
    }
}

@end
