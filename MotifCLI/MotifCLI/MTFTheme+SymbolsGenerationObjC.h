//
//  MTFTheme+SymbolsGenerationObjC.h
//  MotifCLI
//
//  Created by Eric Horacek on 12/28/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

@import Motif;

NS_ASSUME_NONNULL_BEGIN

@interface MTFTheme (SymbolsGenerationOBjc)

- (BOOL)generateObjCSymbolsFilesInDirectory:(NSURL *)directoryURL indentation:(NSString *)indentation prefix:(NSString *)prefix error:(NSError **)error;

+ (BOOL)generateObjCSymbolsUmbrellaHeaderFromThemes:(NSArray *)themes inDirectory:(NSURL *)directoryURL prefix:(NSString *)prefix error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
