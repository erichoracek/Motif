//
//  NSURL+CLIHelpers.h
//  MTFThemingSymbolsGenerator
//
//  Created by Eric Horacek on 12/29/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (CLIHelpers)

+ (NSURL *)mtf_fileURLFromPathParameter:(NSString *)path;
+ (NSURL *)mtf_directoryURLFromPathParameter:(NSString *)path;

@end
