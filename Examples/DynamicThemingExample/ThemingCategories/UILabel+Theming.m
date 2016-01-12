//
//  UILabel+Theming.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 3/11/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import Motif;

#import "ThemeSymbols.h"

#import "UILabel+Theming.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UILabel (Theming)

+ (void)load {
    [self
        mtf_registerThemeProperties:@[
            TypographyThemeProperties.fontName,
            TypographyThemeProperties.fontSize,
        ]
        requiringValuesOfType:@[
            NSString.class,
            NSNumber.class
        ]
        applierBlock:^(NSDictionary<NSString *, id> *properties, UILabel *label, NSError **error) {
            NSString *name = properties[TypographyThemeProperties.fontName];
            CGFloat size = [properties[TypographyThemeProperties.fontSize] floatValue];
            UIFont *font = [UIFont fontWithName:name size:size];

            if (font != nil) {
                label.font = font;
                return YES;
            }

            return [self
                mtf_populateApplierError:error
                withDescriptionFormat:@"Unable to create font named %@ of size %@", name, @(size)];
        }];
    
    [self
        mtf_registerThemeProperty:ContentThemeProperties.color
        requiringValueOfClass:UIColor.class
        applierBlock:^(UIColor *color, UILabel *label, NSError **error) {
            label.textColor = color;
            return YES;
    }];
}

+ (NSDictionary *)mtf_textAttributesForThemeClass:(MTFThemeClass *)themeClass {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    NSString *name = themeClass.properties[TypographyThemeProperties.fontName];
    CGFloat size = [themeClass.properties[TypographyThemeProperties.fontSize] floatValue];
    
    UIFont *font = [UIFont fontWithName:name size:size];
    if (font != nil) {
        attributes[NSFontAttributeName] = font;
    }
    
    NSString *colorString = themeClass.properties[ContentThemeProperties.color];
    UIColor *color;
    if (colorString != nil) {
        NSValueTransformer *transformer = [NSValueTransformer mtf_valueTransformerForTransformingObject:colorString toClass:UIColor.class];
        color = [transformer transformedValue:colorString];
    }
    if (color != nil) {
        attributes[NSForegroundColorAttributeName] = color;
    }
    
    return [attributes copy];
}

@end

NS_ASSUME_NONNULL_END
