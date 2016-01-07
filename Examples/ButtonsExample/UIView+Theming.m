//
//  UIView+Theming.m
//  ButtonsExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

@import Motif;

#import "ThemeSymbols.h"

#import "UIView+Theming.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UIView (Theming)

+ (void)load {
    [self
        mtf_registerThemeProperty:ThemeProperties.borderWidth
        requiringValueOfClass:NSNumber.class
        applierBlock:^(NSNumber *width, UIView *view, NSError **error) {
            view.layer.borderWidth = width.floatValue;
            return YES;
        }];

    [self
        mtf_registerThemeProperty:ThemeProperties.borderColor
        requiringValueOfClass:UIColor.class
        applierBlock:^(UIColor *color, UIView *view, NSError **error) {
            view.layer.borderColor = color.CGColor;
            return YES;
        }];
    
    [self
        mtf_registerThemeProperty:ThemeProperties.cornerRadius
        requiringValueOfClass:NSNumber.class
        applierBlock:^(NSNumber *cornerRadius, UIView *view, NSError **error) {
            view.layer.cornerRadius = cornerRadius.floatValue;
            return YES;
        }];
    
    [self
        mtf_registerThemeProperty:ThemeProperties.backgroundColor
        requiringValueOfClass:UIColor.class
        applierBlock:^(UIColor *color, UIView *view, NSError **error) {
            view.backgroundColor = color;
            return YES;
        }];
}

@end

NS_ASSUME_NONNULL_END
