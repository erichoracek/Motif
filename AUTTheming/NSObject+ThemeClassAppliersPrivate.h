//
//  NSObject+ThemingPrivate.h
//  Pods
//
//  Created by Eric Horacek on 12/25/14.
//
//

#import <Foundation/Foundation.h>
#import "NSObject+ThemeClassAppliers.h"

AUT_NS_ASSUME_NONNULL_BEGIN

@protocol AUTThemeClassApplicable;

@interface NSObject (ThemingPrivate)

+ (void)aut_deregisterThemeClassApplier:(id <AUTThemeClassApplicable>)applier;

/**
 The theme class appliers registered for this class resolved across the entire
 class hierarchy.
 */
+ (NSArray *)aut_themeClassAppliers;

/**
 The theme appliers registerd for just this class, not including superclasses.
 */
+ (NSMutableArray *)aut_classThemeClassAppliers;

@end

AUT_NS_ASSUME_NONNULL_END
