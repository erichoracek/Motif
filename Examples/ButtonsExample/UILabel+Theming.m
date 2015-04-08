//
//  UILabel+Theming.m
//  ButtonsExample
//
//  Created by Eric Horacek on 4/7/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Motif/Motif.h>
#import "UILabel+Theming.h"
#import "ThemeSymbols.h"

@implementation UILabel (Theming)

+ (void)initialize {
    [self
        mtf_registerThemeProperties:@[
            ThemeProperties.fontName,
            ThemeProperties.fontSize
        ] valueTransformerNamesOrRequiredClasses:@[
            NSString.class,
            NSNumber.class
        ] applierBlock:^(NSDictionary *properties, UILabel *label) {
            NSString *name = properties[ThemeProperties.fontName];
            CGFloat size = [properties[ThemeProperties.fontSize] floatValue];
            label.font = [UIFont fontWithName:name size:size];
        }];
}

@end
