//
//  UIView+Theming.m
//  ButtonsExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <AUTTheming/AUTTheming.h>
#import <AUTTheming/AUTValueTransformers.h>
#import "UIView+Theming.h"
#import "ThemeSymbols.h"

@implementation UIView (Theming)

+ (void)load {
    [self
        aut_registerThemeProperty:ThemeProperties.borderWidth
        requiringValueOfClass:NSNumber.class
        applierBlock:^(NSNumber *width, UIView *view) {
            view.layer.borderWidth = width.floatValue;
    }];

    [self
        aut_registerThemeProperty:ThemeProperties.borderColor
        valueTransformerName:AUTColorFromStringTransformerName
        applierBlock:^(UIColor *color, UIView *view) {
            view.layer.borderColor = color.CGColor;
    }];
    
    [self
        aut_registerThemeProperty:ThemeProperties.cornerRadius
        requiringValueOfClass:NSNumber.class
        applierBlock:^(NSNumber *cornerRadius, UIView *view) {
            view.layer.cornerRadius = cornerRadius.floatValue;
    }];
    
    [self
        aut_registerThemeProperty:ThemeProperties.backgroundColor
        valueTransformerName:AUTColorFromStringTransformerName
        applierBlock:^(UIColor *color, UIView *view) {
            view.backgroundColor = color;
    }];
}

@end
