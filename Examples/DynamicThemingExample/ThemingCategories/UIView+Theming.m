//
//  UIView+Theming.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <Motif/Motif.h>
#import "UIView+Theming.h"
#import "ThemeSymbols.h"

@implementation UIView (Theming)

+ (void)load {
    [self
        mtf_registerThemeProperty:ControlsThemeProperties.borderWidth
        requiringValueOfClass:NSNumber.class
        applierBlock:^(NSNumber *width, UIView *view) {
            view.layer.borderWidth = width.floatValue;
    }];

    [self
        mtf_registerThemeProperty:ControlsThemeProperties.borderColor
        requiringValueOfClass:UIColor.class
        applierBlock:^(UIColor *color, UIView *view) {
            view.layer.borderColor = color.CGColor;
    }];
    
    [self
        mtf_registerThemeProperty:ControlsThemeProperties.cornerRadius
        requiringValueOfClass:NSNumber.class
        applierBlock:^(NSNumber *cornerRadius, UIView *view) {
            view.layer.cornerRadius = cornerRadius.floatValue;
    }];
    
    [self
        mtf_registerThemeProperty:ContentThemeProperties.backgroundColor
        requiringValueOfClass:UIColor.class
        applierBlock:^(UIColor *color, UIView *view) {
            view.backgroundColor = color;
    }];
}

@end
