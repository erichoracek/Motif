//
//  NSObject+ThemeClassName.h
//  Pods
//
//  Created by Eric Horacek on 3/25/15.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (ThemeClassName)

/**
 The name of the theme class that was most recently applied to this object.
 */
@property (nonatomic, copy, setter=aut_setThemeClassName:) NSString *aut_themeClassName IBInspectable;

@end
