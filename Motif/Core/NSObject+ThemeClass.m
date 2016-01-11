//
//  NSObject+ThemeClass.h.m
//  Motif
//
//  Created by Eric Horacek on 3/25/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import ObjectiveC;

#import "NSObject+ThemeClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface MTFWeakObjectContainer<__covariant ObjectType> : NSObject

@property (nonatomic, readonly, weak) ObjectType object;

- (instancetype) initWithObject:(ObjectType)object;

@end

@implementation MTFWeakObjectContainer

- (instancetype)initWithObject:(id)object {
    NSParameterAssert(object != nil);
    self = [super init];
    _object = object;
    return self;
}

@end

@implementation NSObject (ThemeClassName)

- (nullable MTFThemeClass *)mtf_themeClass {
    MTFWeakObjectContainer<MTFThemeClass *> *container = objc_getAssociatedObject(self, _cmd);
    if (container == nil) return nil;

    return container.object;
}

- (void)mtf_setThemeClass:(nullable MTFThemeClass *)themeClass {
    [self mtf_setThemeClassName:themeClass.name];

    MTFWeakObjectContainer<MTFThemeClass *> *container;

    if (themeClass != nil) {
        container = [[MTFWeakObjectContainer alloc] initWithObject:themeClass];
    }

    objc_setAssociatedObject(
        self,
        @selector(mtf_themeClass),
        container,
        OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

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
