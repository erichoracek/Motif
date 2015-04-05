//
//  UILabel+Theming.h
//  DynamicThemesExample
//
//  Created by Eric Horacek on 3/11/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AUTThemeClass;

@interface UILabel (Theming)

+ (NSDictionary *)aut_textAttributesForThemeClass:(AUTThemeClass *)themeClass;

@end
