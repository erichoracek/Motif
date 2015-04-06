//
//  NSObject+ThemeClassName.m
//  Motif
//
//  Created by Eric Horacek on 3/25/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+ThemeClassName.h"

@implementation NSObject (ThemeClassName)

- (NSString *)mtf_themeClassName {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)mtf_setThemeClassName:(NSString *)themeClassName {
    objc_setAssociatedObject(
        self,
        @selector(mtf_themeClassName),
        themeClassName,
        OBJC_ASSOCIATION_COPY);
}

@end
