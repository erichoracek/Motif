//
//  MTFThemeApplicable.h
//  Motif
//
//  Created by Eric Horacek on 12/26/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Motif/NSObject+ThemeClassAppliers.h>

NS_ASSUME_NONNULL_BEGIN

@class MTFThemeClass;
@class MTFTheme;

/**
 MTFThemeClassApplicable is an abstract protocol that defines the methods and
 properties required to apply an MTFThemeClass from an MTFTheme to an object.
 
 You likely won't ever have to use an object that conforms to
 MTFThemeClassApplicable directly. The easiest way to register an applier is by
 using the `+[NSObject mtf_registerTheme...applierBlock:]` methods, which is a
 convenience method for creating and registering an applier that conforms to
 this protocol.
 */
@protocol MTFThemeClassApplicable <NSObject>

/**
 The properties that the theme applier is responsible for applying to the target
 object.
 */
@property (nonatomic, copy, readonly) NSArray<NSString *> *properties;

/**
 Attempts to appliy an MTFThemeClass from an MTFTheme to an object.
 
 @param class  The class that should have its properties applied

 @param theme  The theme that should be applied to the specified class.

 @param object The object that should have the class applied to it.
 
 @return Whether the theme class was applied to the object.
 */
- (BOOL)applyClass:(MTFThemeClass *)themeClass toObject:(id)object;

@end

NS_ASSUME_NONNULL_END
