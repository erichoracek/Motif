//
//  UILabel+Theming.m
//  ButtonsExample
//
//  Created by Eric Horacek on 1/1/16.
//  Copyright © 2016 Eric Horacek. All rights reserved.
//

@import Motif;

#import "ThemeSymbols.h"

#import "UILabel+Theming.h"

@implementation UILabel (Theming)

+ (void)load {
    [self
        mtf_registerThemeProperties:@[
            ThemeProperties.fontName,
            ThemeProperties.fontSize
        ]
        requiringValuesOfType:@[
            NSString.class,
            NSNumber.class
        ]
        applierBlock:^(NSDictionary<NSString *, id> *properties, UILabel *label, NSError **error) {
            NSString *name = properties[ThemeProperties.fontName];
            CGFloat size = [properties[ThemeProperties.fontSize] floatValue];
            UIFont *font = [UIFont fontWithName:name size:size];

            if (font != nil) {
                label.font = font;
                return YES;
            }

            return [self
                mtf_populateApplierError:error
                withDescriptionFormat:@"Unable to create a font named %@ of size %@", name, @(size)];
        }];
}

@end
