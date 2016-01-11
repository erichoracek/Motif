//
//  NSObject+ThemingPrivate.h
//  Motif
//
//  Created by Eric Horacek on 12/25/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import Foundation;

#import <Motif/NSObject+ThemeClassAppliers.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MTFThemeClassApplicable;

@interface NSObject (ThemingPrivate)

/// Deregisters the provided theme class applier from the global list of theme
/// appliers.
///
/// Must be invoked from the main thread.
///
/// @param applier The applier that should be deregistered.
+ (void)mtf_deregisterThemeClassApplier:(id<MTFThemeClassApplicable>)applier;

/// The theme class appliers registered for this class resolved across the
/// entire class hierarchy.
+ (NSArray<id<MTFThemeClassApplicable>> *)mtf_themeClassAppliers;

/// The theme appliers registered for just this class, not including
/// superclasses.
+ (NSMutableArray<id<MTFThemeClassApplicable>> *)mtf_classThemeClassAppliers;

@end

NS_ASSUME_NONNULL_END
