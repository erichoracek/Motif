//
//  MTFThemeSourceObserver.h
//  Motif
//
//  Created by Eric Horacek on 4/26/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MTFTheme;

/// A block that is invoked when a theme is recreated from its source files
/// when they were updated, and an error if there was one when creating it.
typedef void (^MTFThemeDidUpdate)(MTFTheme *, NSError * null_resettable);

/// Observes the theme files that were used to create an MTFTheme, and creates a
/// new MTFTheme whenever they are edited.
@interface MTFThemeSourceObserver : NSObject

/// Creates a theme source observer that observes the source of the specified
/// theme, invoking the didUpdate block whenever a new theme is reloaded
///
/// @param theme              The theme whose source should be observed.
/// @param sourceDirectoryURL The directory that the theme's source is contained
///                           within.
/// @param didUpdate          A block invoked when the theme is recreated from
///                           its source.
///
/// @return A theme source observer.
- (instancetype)initWithTheme:(MTFTheme *)theme sourceDirectoryURL:(NSURL *)sourceDirectoryURL didUpdate:(MTFThemeDidUpdate)didUpdate NS_DESIGNATED_INITIALIZER;

/// The directory that the observed theme's source is contained within.
@property (nonatomic, readonly) NSURL *sourceDirectoryURL;

/// The latest theme created from the source of the theme that this observer was
/// initialized with.
///
/// Before the `didUpdate` block is invoked, this property is updated to be the
/// latest theme that was created from the source files.
@property (nonatomic, readonly) MTFTheme *updatedTheme;

/// The error, if there was any, when creating the latest `updatedTheme`.
@property (nonatomic, readonly, nullable) NSError *updatedThemeError;

@end

NS_ASSUME_NONNULL_END
