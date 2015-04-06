//
//  MTFThemingSymbolsGenerator.h
//  MTFThemingSymbolsGenerator
//
//  Created by Eric Horacek on 12/28/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTFThemingSymbolsGenerator : NSObject

+ (instancetype)sharedInstance;

@end

int MTFThemingSymbolsGeneratorMain(int argc, const char *argv[]);
