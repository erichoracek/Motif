//
//  NSObject+ThemeClassName.h
//  Motif
//
//  Created by Eric Horacek on 3/25/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ThemeClassName)

/**
 The name of the theme class that was most recently applied to this object.
 */
@property (nonatomic, copy, setter=mtf_setThemeClassName:) NSString *mtf_themeClassName IBInspectable;

@end
