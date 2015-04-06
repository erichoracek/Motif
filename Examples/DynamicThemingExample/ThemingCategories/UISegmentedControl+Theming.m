//
//  UISegmentedControl+Theming.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 4/3/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Motif/Motif.h>
#import "UISegmentedControl+Theming.h"
#import "UILabel+Theming.h"
#import "ThemeSymbols.h"

@implementation UISegmentedControl (Theming)

+ (void)load
{
    [self
        mtf_registerThemeProperty:ControlsThemeProperties.text
        requiringValueOfClass:[MTFThemeClass class]
        applierBlock:^(MTFThemeClass *themeClass, UISegmentedControl *segmentedControl) {
            NSDictionary *textAttributes = [UILabel mtf_textAttributesForThemeClass:themeClass];
            [segmentedControl setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
        }];
}

@end
