//
//  MTFTheme+SymbolsGenerationSwift.h
//  MotifCLI
//
//  Created by Eric Horacek on 8/17/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import Motif;

NS_ASSUME_NONNULL_BEGIN

@interface MTFTheme (SymbolsGenerationSwift)

- (void)generateSwiftSymbolsFileInDirectory:(NSURL *)directoryURL indentation:(NSString *)indentation;

@end

NS_ASSUME_NONNULL_END
