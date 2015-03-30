//
//  NSURL+CLIHelpers.m
//  AUTThemingSymbolsGenerator
//
//  Created by Eric Horacek on 12/29/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import "NSURL+CLIHelpers.h"

@implementation NSURL (CLIHelpers)

+ (NSURL *)aut_fileURLFromPathParameter:(NSString *)path {
    NSURL *resolvedURL = [self URLResolvedFromPathParameter:path];
    if (!resolvedURL) {
        return nil;
    }
    // Ensure the URL isn't a directory and exists
    BOOL isDirectory = NO;
    BOOL exists = [NSFileManager.defaultManager
        fileExistsAtPath:resolvedURL.path
        isDirectory:&isDirectory];
    if (exists && !isDirectory) {
        return resolvedURL;
    }
    return nil;
}

+ (NSURL *)aut_directoryURLFromPathParameter:(NSString *)path {
    NSURL *resolvedURL = [self URLResolvedFromPathParameter:path];
    if (!resolvedURL) {
        return nil;
    }
    // Ensure the URL isn't a directory and exists
    BOOL isDirectory = NO;
    BOOL exists = [NSFileManager.defaultManager
        fileExistsAtPath:resolvedURL.path
        isDirectory:&isDirectory];
    if (exists && isDirectory) {
        return resolvedURL;
    }
    return nil;
}

+ (NSURL *)URLResolvedFromPathParameter:(NSString *)path {
    if (!path) {
        return nil;
    }
    // If the path begins with a tilde, expand it
    if ([path rangeOfString:@"~"].location == 0) {
        path = path.stringByExpandingTildeInPath;
    }
    // Resolve the URL using NSURL's built-in method
    NSURL *fileURL =  [NSURL fileURLWithPath:path];
    return fileURL;
}

@end
