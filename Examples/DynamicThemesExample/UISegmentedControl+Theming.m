//
//  UISegmentedControl+Theming.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 4/3/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import <AUTTheming/AUTTheming.h>
#import "UISegmentedControl+Theming.h"
#import "UILabel+Theming.h"
#import "ThemeSymbols.h"

@implementation UISegmentedControl (Theming)

+ (void)load
{
    [self
        aut_registerThemeProperty:ControlsThemeProperties.text
        requiringValueOfClass:[AUTThemeClass class]
        applierBlock:^(AUTThemeClass *themeClass, UISegmentedControl *segmentedControl) {
            NSDictionary *textAttributes = [UILabel aut_textAttributesForThemeClass:themeClass];
            [segmentedControl setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
        }];
}

@end
