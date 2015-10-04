//
//  MTFTheme+WarningComment.h
//  MotifCLI
//
//  Created by Eric Horacek on 8/17/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Motif/Motif.h>

@interface MTFTheme (WarningComment)

/// A warning comment suitable for a generated file from a theme file..
@property (readonly, nonatomic, copy) NSString *warningComment;

/// A warning comment suitable for a generated file that is not specific to a
/// single theme.
+ (NSString *)warningComment;

@end
