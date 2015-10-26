//
//  NSBundle+ExtensionURLs.m
//  Motif
//
//  Created by Eric Horacek on 5/31/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "NSBundle+ExtensionURLs.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSBundle (ExtensionURLs)

- (nullable NSArray<NSURL *> *)mtf_URLsForResourcesWithExtensions:(NSArray<NSString *> *)extensions subdirectory:(nullable NSString *)subdirectory {
    NSParameterAssert(extensions != nil);

    NSMutableArray<NSURL *> *URLs = [[NSMutableArray alloc] init];

    for (NSString *extension in extensions) {
        NSArray<NSURL *> *extensionURLs = [self URLsForResourcesWithExtension:extension subdirectory:subdirectory];

        if (extensionURLs != nil) {
            [URLs addObjectsFromArray:extensionURLs];
        }
    }

    return (URLs.count != 0) ? [URLs copy] : nil;
}

@end

NS_ASSUME_NONNULL_END
