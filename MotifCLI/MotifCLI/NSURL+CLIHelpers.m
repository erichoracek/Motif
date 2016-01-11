//
//  NSURL+CLIHelpers.m
//  MotifCLI
//
//  Created by Eric Horacek on 12/29/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import "NSURL+CLIHelpers.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSURL (CLIHelpers)

+ (nullable NSURL *)mtf_fileURLFromPathParameter:(nullable NSString *)path {
    NSURL *resolvedURL = [self mtf_URLResolvedFromPathParameter:path];

    if (resolvedURL == nil) return nil;

    // Ensure the URL isn't a directory and exists
    BOOL isDirectory = NO;
    BOOL exists = [NSFileManager.defaultManager
        fileExistsAtPath:resolvedURL.path
        isDirectory:&isDirectory];

    if (!exists || isDirectory) return nil;

    return resolvedURL;
}

+ (nullable NSURL *)mtf_directoryURLFromPathParameter:(nullable NSString *)path {
    NSURL *resolvedURL = [self mtf_URLResolvedFromPathParameter:path];

    if (resolvedURL == nil) return nil;

    // Ensure the URL isn't a directory and exists
    BOOL isDirectory = NO;
    BOOL exists = [NSFileManager.defaultManager
        fileExistsAtPath:resolvedURL.path
        isDirectory:&isDirectory];

    if (!exists || !isDirectory) return nil;

    return resolvedURL;
}

+ (nullable NSURL *)mtf_URLResolvedFromPathParameter:(nullable NSString *)path {
    if (path == nil) return nil;

    // If the path begins with a tilde, expand it
    if ([path rangeOfString:@"~"].location == 0) {
        path = path.stringByExpandingTildeInPath;
    }

    // Resolve the URL using NSURL's built-in method
    NSURL *fileURL = [NSURL fileURLWithPath:path];

    return fileURL;
}

@end

NS_ASSUME_NONNULL_END
