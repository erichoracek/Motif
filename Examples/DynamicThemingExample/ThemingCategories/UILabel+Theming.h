//
//  UILabel+Theming.h
//  DynamicThemesExample
//
//  Created by Eric Horacek on 3/11/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTFThemeClass;

@interface UILabel (Theming)

+ (NSDictionary *)mtf_textAttributesForThemeClass:(MTFThemeClass *)themeClass;

@end
