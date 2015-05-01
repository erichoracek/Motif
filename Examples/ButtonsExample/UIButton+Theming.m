//
//  UIButton+Theming.m
//  ButtonsExample
//
//  Created by Eric Horacek on 4/7/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Motif/Motif.h>
#import "UIButton+Theming.h"
#import "ThemeSymbols.h"

@implementation UIButton (Theming)

+ (void)load {
    [self
        mtf_registerThemeProperty:ThemeProperties.titleText
        requiringValueOfClass:MTFThemeClass.class
        applierBlock:^(MTFThemeClass *themeClass, UIButton *button) {
            [themeClass applyToObject:button.titleLabel];
        }];
}

@end
