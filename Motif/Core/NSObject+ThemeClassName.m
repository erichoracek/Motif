//
//  NSObject+ThemeClassName.m
//  Motif
//
//  Created by Eric Horacek on 3/25/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import ObjectiveC;

#import "NSObject+ThemeClassName.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSObject (ThemeClassName)

- (nullable NSString *)mtf_themeClassName {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)mtf_setThemeClassName:(nullable NSString *)themeClassName {
    objc_setAssociatedObject(
        self,
        @selector(mtf_themeClassName),
        themeClassName,
        OBJC_ASSOCIATION_COPY);
}

@end

NS_ASSUME_NONNULL_END
