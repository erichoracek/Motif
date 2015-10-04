//
//  MTFTheme+SymbolsGenerationObjC.h
//  MTFThemingSymbolsGenerator
//
//  Created by Eric Horacek on 12/28/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

@import Motif;

NS_ASSUME_NONNULL_BEGIN

@interface MTFTheme (SymbolsGenerationOBjc)

- (void)generateObjCSymbolsFilesInDirectory:(NSURL *)directoryURL indentation:(NSString *)indentation prefix:(NSString *)prefix;

+ (void)generateObjCSymbolsUmbrellaHeaderFromThemes:(NSArray *)themes inDirectory:(NSURL *)directoryURL prefix:(NSString *)prefix;

@end

NS_ASSUME_NONNULL_END
