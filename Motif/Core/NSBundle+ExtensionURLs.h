//
//  NSBundle+ExtensionURLs.h
//  Motif
//
//  Created by Eric Horacek on 5/31/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import Foundation;
#import <Motif/MTFBackwardsCompatableNullability.h>

MTF_NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (ExtensionURLs)

/// Returns an array of file URLs for all resources identified by the specified
/// file extensions and located in the specified bundle subdirectory.
///
/// @see URLsForResourcesWithExtension:subdirectory:
- (mtf_nullable NSArray *)mtf_URLsForResourcesWithExtensions:(NSArray *)extensions subdirectory:(mtf_nullable NSString *)subdirectory;

@end

MTF_NS_ASSUME_NONNULL_END
