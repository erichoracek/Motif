//
//  UILabel+Theming.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 3/11/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Motif/Motif.h>
#import "ThemeSymbols.h"
#import "UILabel+Theming.h"

@implementation UILabel (Theming)

+ (void)load {
    [self
        mtf_registerThemeProperties:@[
            TypographyThemeProperties.fontSize,
            TypographyThemeProperties.fontName,
        ] requiringValuesOfClassOrObjCType:@[
            NSNumber.class,
            NSString.class,
        ] applierBlock:^(NSDictionary *valuesForProperties, UILabel *label) {
            NSString *name = valuesForProperties[TypographyThemeProperties.fontName];
            CGFloat size = [valuesForProperties[TypographyThemeProperties.fontSize] floatValue];
            label.font = [UIFont fontWithName:name size:size];
        }];
    
    [self
        mtf_registerThemeProperty:ContentThemeProperties.color
        requiringValueOfClass:UIColor.class
        applierBlock:^(UIColor *color, UILabel *label) {
            label.textColor = color;
    }];
}

+ (NSDictionary *)mtf_textAttributesForThemeClass:(MTFThemeClass *)themeClass {
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    NSString *name = themeClass.properties[TypographyThemeProperties.fontName];
    CGFloat size = [themeClass.properties[TypographyThemeProperties.fontSize] floatValue];
    
    UIFont *font = [UIFont fontWithName:name size:size];
    if (font != nil) {
        attributes[NSFontAttributeName] = font;
    }
    
    NSString *colorString = themeClass.properties[ContentThemeProperties.color];
    UIColor *color;
    if (colorString != nil) {
        color = [[NSValueTransformer valueTransformerForName:MTFColorFromStringTransformerName] transformedValue:colorString];
    }
    if (color != nil) {
        attributes[NSForegroundColorAttributeName] = color;
    }
    
    return [attributes copy];
}

@end
