//
//  MTFLiveReloadThemeApplier.h
//  Motif
//
//  Created by Eric Horacek on 4/25/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Motif/MTFDynamicThemeApplier.h>

NS_ASSUME_NONNULL_BEGIN

/// A theme applier that "live reloads" its theme at runtime whenever any of
/// the source theme files are changed. By using this theme applier, you can
/// reduce the amount of time spent building and running when creating an
/// interface.
///
/// This theme applier will only work on the iPhone simulator, where it has
/// access to the theme's source files within the same directory structure.
@interface MTFLiveReloadThemeApplier : MTFDynamicThemeApplier

/// Initializes a live reload theme applier using the __FILE__ directive.
///
/// The file that this method is invoked from should not be at a higer directory
/// level than your theme files, or this theme applier will be unable to locate
/// them. If that is the case, use initWithTheme:sourceDirectoryPath: instead.
///
/// @param theme The theme that the dynamic theme applier instance should be
///              responsible for applying. Must not be nil.
///
/// @param sourceFile The source file that the sourceDirectoryPath should be
///                   derived from. You should pass __FILE__ for this parameter.
///
/// @return An initialized theme applier.
- (instancetype)initWithTheme:(MTFTheme *)theme sourceFile:(char *)sourceFile;

/// Initializes a live reload theme applier using a source directory path.
///
/// @param theme The theme that the dynamic theme applier instance should be
///              responsible for applying. Must not be nil.
///
/// @param sourceDirectoryURL The source directory that should be searched for
///                           identically-named files to those that were used to
///                           create the theme.
///
/// @return An initialized theme applier.
- (instancetype)initWithTheme:(MTFTheme *)theme sourceDirectoryURL:(NSURL *)sourceDirectoryURL NS_DESIGNATED_INITIALIZER;

/// The directory path that is recursively searched within to the locate the
/// source files for the theme.
@property (nonatomic, copy, readonly) NSURL *sourceDirectoryURL;

@end

NS_ASSUME_NONNULL_END
