//
//  MTFTheme+WarningComment.m
//  MotifCLI
//
//  Created by Eric Horacek on 8/17/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Motif/MTFTheme_Private.h>

#import "MTFTheme+WarningComment.h"

static NSString * const WarningComment = @"\
// WARNING: Do not modify. This file is machine-generated\
";

static NSString * const MotifAttribution = @"by Motif.\n";

@implementation MTFTheme (WarningComment)

- (NSString *)warningComment {
    return [WarningComment stringByAppendingFormat:@" from '%@' %@", self.filenames.firstObject, MotifAttribution];
}

+ (NSString *)warningComment {
    return [WarningComment stringByAppendingFormat:@" %@", MotifAttribution];
}

@end
