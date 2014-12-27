//
//  NSURL+LastPathComponentWithoutExtension.m
//  AUTTheming
//
//  Created by Eric Horacek on 12/23/14.
//
//

#import "NSURL+LastPathComponentWithoutExtension.h"

@implementation NSURL (LastPathComponentWithoutExtension)

- (NSString *)aut_lastPathComponentWithoutExtension
{
    NSString *lastPathComponent = self.lastPathComponent;
    // Trim path extension if there is one
    if (lastPathComponent.pathExtension) {
        NSString *extensionIncludingDot = [@"." stringByAppendingString:lastPathComponent.pathExtension];
        lastPathComponent = [lastPathComponent stringByReplacingOccurrencesOfString:extensionIncludingDot withString:@""];
    }
    return lastPathComponent;
}

+ (NSSet *)keyPathsForValuesAffectingAut_lastPathComponentWithoutExtension
{
    return [NSSet setWithObject:NSStringFromSelector(@selector(lastPathComponent))];
}

@end
