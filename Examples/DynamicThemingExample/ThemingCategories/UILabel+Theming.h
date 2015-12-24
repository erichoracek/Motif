//
//  UILabel+Theming.h
//  DynamicThemesExample
//
//  Created by Eric Horacek on 3/11/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@class MTFThemeClass;

@interface UILabel (Theming)

+ (NSDictionary *)mtf_textAttributesForThemeClass:(MTFThemeClass *)themeClass;

@end

NS_ASSUME_NONNULL_END
