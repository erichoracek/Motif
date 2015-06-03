//
//  MTFTheme+SymbolsGeneration.h
//  MTFThemingSymbolsGenerator
//
//  Created by Eric Horacek on 12/28/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <Motif/Motif.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTFTheme (SymbolsGeneration)

- (void)generateSymbolsFilesInDirectory:(NSURL *)directoryURL indentation:(NSString *)indentation prefix:(NSString *)prefix;

+ (void)generateSymbolsUmbrellaHeaderFromThemes:(NSArray *)themes inDirectory:(NSURL *)directoryURL prefix:(NSString *)prefix;

@property (nonatomic, readonly) NSArray *constantNames;
@property (nonatomic, readonly) NSArray *classNames;
@property (nonatomic, readonly) NSArray *properties;

@end

NS_ASSUME_NONNULL_END
