//
//  UILabel+Theming.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 3/11/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import <AUTTheming/AUTTheming.h>
#import "ThemeSymbols.h"
#import "UILabel+Theming.h"

@implementation UILabel (Theming)

+ (void)load {
    [self
        aut_registerThemeProperties:@[
            TypographyThemeProperties.fontSize,
            TypographyThemeProperties.fontName,
        ] valueTransformerNamesOrRequiredClasses:@[
            NSNumber.class,
            NSString.class,
        ] applierBlock:^(NSDictionary *valuesForProperties, UILabel *label) {
            NSString *name = valuesForProperties[TypographyThemeProperties.fontName];
            CGFloat size = [valuesForProperties[TypographyThemeProperties.fontSize] floatValue];
            label.font = [UIFont fontWithName:name size:size];
        }];
    
    [self
        aut_registerThemeProperty:TypographyThemeProperties.color
        valueTransformerName:AUTColorFromStringTransformerName
        applierBlock:^(UIColor *color, UILabel *label) {
            label.textColor = color;
    }];
}

+ (NSDictionary *)aut_textAttributesForThemeClass:(AUTThemeClass *)themeClass {
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    NSString *name = themeClass.properties[TypographyThemeProperties.fontName];
    CGFloat size = [themeClass.properties[TypographyThemeProperties.fontSize] floatValue];
    UIFont *font = [UIFont fontWithName:name size:size];
    attributes[NSFontAttributeName] = font;
    
    NSString *colorString = themeClass.properties[TypographyThemeProperties.color];
    UIColor *color = [[NSValueTransformer valueTransformerForName:AUTColorFromStringTransformerName] transformedValue:colorString];
    attributes[NSForegroundColorAttributeName] = color;
    
    return [attributes copy];
}

@end
