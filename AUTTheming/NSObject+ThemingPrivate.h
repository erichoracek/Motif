//
//  NSObject+ThemingPrivate.h
//  Pods
//
//  Created by Eric Horacek on 12/25/14.
//
//

#import <Foundation/Foundation.h>
#import "NSObject+ThemeAppliers.h"

@protocol AUTThemeClassApplicable;

@interface NSObject (ThemingPrivate)

+ (void)aut_deregisterThemeApplier:(id <AUTThemeClassApplicable>)applier;

/**
 The theme appliers registered for this class resolved across the entire class hierarchy.
 */
+ (NSArray *)aut_themeAppliers;

/**
 The theme appliers registerd for just this class, not including superclasses.
 */
+ (NSMutableArray *)aut_classThemeAppliers;

@end
