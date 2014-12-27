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
#import "AUTThemeSymbols.h"

@implementation UIButton (Theming)

+ (void)load
{
    [self aut_registerThemeProperty:AUTThemeProperties.textColor valueTransformerName:AUTColorFromStringTransformerName applier:^(UIColor *textColor, UIButton *button) {
        [button setTitleColor:textColor forState:UIControlStateNormal];
    }];
    
    [self aut_registerThemeProperty:AUTThemeProperties.contentEdgeInsets valueTransformerName:AUTEdgeInsetsFromStringTransformerName applier:^(NSValue *edgeInsets, UIButton *button) {
        button.contentEdgeInsets = edgeInsets.UIEdgeInsetsValue;
    }];
    
    [self aut_registerThemeProperties:@[
        AUTThemeProperties.fontName,
        AUTThemeProperties.fontSize
    ] valueTransformerNamesOrRequiredClasses:@[
        [NSString class],
        [NSNumber class]
    ] applier:^(NSDictionary *properties, UIButton *button) {
        NSString *name = properties[AUTThemeProperties.fontName];
        CGFloat size = [properties[AUTThemeProperties.fontSize] floatValue];
        button.titleLabel.font = [UIFont fontWithName:name size:size];
    }];
}

@end
