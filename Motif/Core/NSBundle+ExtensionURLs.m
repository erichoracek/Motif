//
//  NSBundle+ExtensionURLs.m
//  Motif
//
//  Created by Eric Horacek on 5/31/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "NSBundle+ExtensionURLs.h"

MTF_NS_ASSUME_NONNULL_BEGIN

@implementation NSBundle (ExtensionURLs)

- (mtf_nullable NSArray *)mtf_URLsForResourcesWithExtensions:(NSArray *)extensions subdirectory:(mtf_nullable NSString *)subdirectory {
    NSParameterAssert(extensions != nil);

    NSMutableArray *URLs = [[NSMutableArray alloc] init];

    for (NSString *extension in extensions) {
        NSArray *extensionURLs = [self URLsForResourcesWithExtension:extension subdirectory:subdirectory];

        if (extensionURLs != nil) {
            [URLs addObjectsFromArray:extensionURLs];
        }
    }

    return (URLs.count != 0) ? [URLs copy] : nil;
}

@end

MTF_NS_ASSUME_NONNULL_END
