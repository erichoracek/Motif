//
//  UIButton+Theming.m
//  ButtonsExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <AUTTheming/AUTTheming.h>
#import <AUTTheming/AUTValueTransformers.h>
#import "UIButton+Theming.h"
#import "ThemeSymbols.h"

@implementation UIButton (Theming)

+ (void)load
{
    [self aut_registerThemeProperties:@[
        ThemeProperties.fontName,
        ThemeProperties.fontSize
    ] valueTransformerNamesOrRequiredClasses:@[
        [NSString class],
        [NSNumber class]
    ] applierBlock:^(NSDictionary *properties, UIButton *button) {
        NSString *name = properties[ThemeProperties.fontName];
        CGFloat size = [properties[ThemeProperties.fontSize] floatValue];
        button.titleLabel.font = [UIFont fontWithName:name size:size];
    }];
}

@end
