//
//  UIButton+Theming.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

@import Motif;

#import "ThemeSymbols.h"

#import "UIButton+Theming.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UIButton (Theming)

+ (void)load {
    [self
        mtf_registerThemeProperty:ControlsThemeProperties.text
        requiringValueOfClass:MTFThemeClass.class
        applierBlock:^(MTFThemeClass *themeClass, UIButton *button) {
            [themeClass applyToObject:button.titleLabel];
        }];
}

@end

NS_ASSUME_NONNULL_END
