//
//  UINavigationBar+Theming.h
//  DynamicThemesExample
//
//  Created by Eric Horacek on 1/2/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Theming)

- (UIBarStyle)mtf_barStyleForColor:(UIColor *)color;

- (void)mtf_setShadowColor:(UIColor *)color;

@end
