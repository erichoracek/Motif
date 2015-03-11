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

@implementation UINavigationBar (Theming)

+ (void)load
{
    [self aut_registerThemeProperty:NavigationThemeProperties.backgroundColor valueTransformerName:AUTColorFromStringTransformerName applierBlock:^(UIColor *color, UINavigationBar *navigationBar) {
        navigationBar.barTintColor = color;
        navigationBar.translucent = NO;
        navigationBar.barStyle = ((color.lightnessType == LightnessTypeLight) ? UIBarStyleDefault : UIBarStyleBlack);
    }];
        
    [self aut_registerThemeProperties:@[
        NavigationThemeProperties.fontName,
        NavigationThemeProperties.fontSize
    ] valueTransformerNamesOrRequiredClasses:@[
        [NSString class],
        [NSNumber class]
    ] applierBlock:^(NSDictionary *valuesForProperties, UINavigationBar *navigationBar) {
        NSMutableDictionary *attributes = (navigationBar.titleTextAttributes ? [navigationBar.titleTextAttributes mutableCopy] : [NSMutableDictionary new]);
        NSString *name = valuesForProperties[NavigationThemeProperties.fontName];
        CGFloat size = [valuesForProperties[NavigationThemeProperties.fontSize] floatValue];
        UIFont *font = [UIFont fontWithName:name size:size];
        attributes[NSFontAttributeName] = font;
        navigationBar.titleTextAttributes = attributes;
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
    
    [self aut_registerThemeProperty:NavigationThemeProperties.textColor valueTransformerName:AUTColorFromStringTransformerName applierBlock:^(UIColor *color, UINavigationBar *navigationBar) {
        NSMutableDictionary *attributes = (navigationBar.titleTextAttributes ? [navigationBar.titleTextAttributes mutableCopy] : [NSMutableDictionary new]);
        attributes[NSForegroundColorAttributeName] = color;
        navigationBar.titleTextAttributes = attributes;
    }];
}

@end
