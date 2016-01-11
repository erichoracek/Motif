//
//  NSURL+CLIHelpers.h
//  MotifCLI
//
//  Created by Eric Horacek on 12/29/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (CLIHelpers)

+ (nullable NSURL *)mtf_fileURLFromPathParameter:(nullable NSString *)path;
+ (nullable NSURL *)mtf_directoryURLFromPathParameter:(nullable NSString *)path;

@end

NS_ASSUME_NONNULL_END
