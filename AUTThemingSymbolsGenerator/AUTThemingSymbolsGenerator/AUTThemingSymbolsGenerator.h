//
//  AUTThemingSymbolsGenerator.h
//  AUTThemingSymbolsGenerator
//
//  Created by Eric Horacek on 12/28/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AUTThemingSymbolsGenerator : NSObject

+ (instancetype)sharedInstance;

@end

int AUTThemingSymbolsGeneratorMain(int argc, const char *argv[]);
