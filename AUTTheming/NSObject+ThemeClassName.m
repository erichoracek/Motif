//
//  NSObject+ThemeClassName.m
//  Pods
//
//  Created by Eric Horacek on 3/25/15.
//
//

#import <objc/runtime.h>
#import "NSObject+ThemeClassName.h"

@implementation NSObject (ThemeClassName)

- (NSString *)aut_themeClassName {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)aut_setThemeClassName:(NSString *)themeClassName {
    objc_setAssociatedObject(
        self,
        @selector(aut_themeClassName),
        themeClassName,
        OBJC_ASSOCIATION_COPY);
}

@end
