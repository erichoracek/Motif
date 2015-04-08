//
//  UIButton+Theming.m
//  ButtonsExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <Motif/Motif.h>
#import "UIButton+Theming.h"
#import "ThemeSymbols.h"

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
