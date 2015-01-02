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
#import "ButtonsSymbols.h"

@implementation UIButton (Theming)

+ (void)load
{    
    [self aut_registerThemeProperty:ButtonsProperties.contentEdgeInsets valueTransformerName:AUTEdgeInsetsFromStringTransformerName applierBlock:^(NSValue *edgeInsets, UIButton *button) {
        button.contentEdgeInsets = edgeInsets.UIEdgeInsetsValue;
    }];
    
    [self aut_registerThemeProperties:@[
        ButtonsProperties.fontName,
        ButtonsProperties.fontSize
    ] valueTransformerNamesOrRequiredClasses:@[
        [NSString class],
        [NSNumber class]
    ] applierBlock:^(NSDictionary *properties, UIButton *button) {
        NSString *name = properties[ButtonsProperties.fontName];
        CGFloat size = [properties[ButtonsProperties.fontSize] floatValue];
        button.titleLabel.font = [UIFont fontWithName:name size:size];
    }];
}

@end
