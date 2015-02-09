//
//  AUTTheme+SymbolsGeneration.h
//  AUTThemingSymbolsGenerator
//
//  Created by Eric Horacek on 12/28/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <AUTTheming/AUTTheming.h>

@interface AUTTheme (SymbolsGeneration)

- (void)generateSymbolsFilesInDirectory:(NSURL *)directoryURL indentation:(NSString *)indentation prefix:(NSString *)prefix;

+ (void)generateSymbolsUmbrellaHeaderFromThemes:(NSArray *)themes inDirectory:(NSURL *)directoryURL prefix:(NSString *)prefix;

@property (nonatomic, readonly) NSArray *constantKeys;
@property (nonatomic, readonly) NSArray *classNames;
@property (nonatomic, readonly) NSArray *properties;

@end
