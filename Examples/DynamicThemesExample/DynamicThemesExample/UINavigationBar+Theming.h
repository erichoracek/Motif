//
//  UINavigationBar+Theming.h
//  DynamicThemesExample
//
//  Created by Eric Horacek on 1/2/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Theming)

- (UIBarStyle)aut_barStyleForColor:(UIColor *)color;

- (void)aut_setShadowColor:(UIColor *)color;

@end
