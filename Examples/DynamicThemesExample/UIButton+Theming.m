//
//  UIButton+Theming.m
//  ButtonsExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <AUTTheming/AUTTheming.h>
#import "UIButton+Theming.h"
#import "ThemeSymbols.h"

@implementation UIButton (Theming)

+ (void)load {
    [self
        aut_registerThemeProperty:ButtonsThemeProperties.text
        requiringValueOfClass:AUTThemeClass.class
        applierBlock:^(AUTThemeClass *themeClass, UIButton *button) {
            [themeClass applyToObject:button.titleLabel];
    }];
}

@end
