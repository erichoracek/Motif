//
//  MTFThemeSourceObserver.h
//  Motif
//
//  Created by Eric Horacek on 4/26/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTFBackwardsCompatableNullability.h"

MTF_NS_ASSUME_NONNULL_BEGIN

@class MTFTheme;

typedef void (^MTFThemeDidUpdate)(MTFTheme *, NSError * mtf_null_resettable);

@interface MTFThemeSourceObserver : NSObject

- (instancetype)initWithTheme:(MTFTheme *)theme sourceDirectoryPath:(NSString *)sourceDirectoryPath didUpdate:(MTFThemeDidUpdate)didUpdate NS_DESIGNATED_INITIALIZER;

@property (nonatomic, copy, readonly) NSString *sourceDirectoryPath;

/// The latest version from source of the theme that this observer was
/// initialized with.
///
/// Before the `didUpdate` block is invoked, this property is updated to be the
/// latest theme that was created from the source files.
@property (nonatomic, readonly) MTFTheme *updatedTheme;

/// The error, if there was any, when creating the latest `updatedTheme`.
@property (nonatomic, readonly, mtf_nullable) NSError *updatedThemeError;

@end

MTF_NS_ASSUME_NONNULL_END
