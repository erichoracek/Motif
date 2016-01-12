//
//  NSURL+LastPathComponentWithoutExtension.m
//  Motif
//
//  Created by Eric Horacek on 12/23/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "NSURL+LastPathComponentWithoutExtension.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSURL (LastPathComponentWithoutExtension)

- (nullable NSString *)mtf_lastPathComponentWithoutExtension {
    NSString *lastPathComponent = self.lastPathComponent;

    // Trim path extension if there is one
    if (lastPathComponent.pathExtension) {
        NSString *extensionIncludingDot = [@"."
            stringByAppendingString:lastPathComponent.pathExtension];

        lastPathComponent = [lastPathComponent
            stringByReplacingOccurrencesOfString:extensionIncludingDot
            withString:@""];
    }

    return lastPathComponent;
}

@end

NS_ASSUME_NONNULL_END
