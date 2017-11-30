//
//  MTFCLI.m
//  MotifCLI
//
//  Created by Eric Horacek on 12/28/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <Motif/Motif.h>
#import <Motif/MTFThemeParser.h>
#import "GBCli.h"
#import "MTFCLI.h"
#import "GBSettings+ThemingSymbolsGenerator.h"
#import "GBOptionsHelper+ThemingSymbolsGenerator.h"
#import "MTFTheme+SymbolsGenerationObjC.h"
#import "MTFTheme+SymbolsGenerationSwift.h"
#import "NSURL+CLIHelpers.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MTFCLI

- (int)runWithSettings:(GBSettings *)settings {
    // Do not resolve references when parsing themes
    [MTFThemeParser setShouldResolveReferences:NO];
    
    // Build an array of `MTFThemes` from the passed `theme` path params
    NSMutableArray *themes = [NSMutableArray array];
    for (NSString *themePath in settings.mtf_themes) {
        NSURL *themeURL = [NSURL mtf_fileURLFromPathParameter:themePath];
        if (themeURL == nil) {
            gbfprintln(stderr, @"[!] Error: '%@' is an invalid file path. Please supply another.", themePath);
            return 1;
        }

        NSError *error;
        MTFTheme *theme = [[MTFTheme alloc] initWithFile:themeURL error:&error];
        if (theme == nil) {
            gbfprintln(stderr, @"[!] Error: Unable to parse theme at URL '%@': %@", themeURL, error);
            return 1;
        }

        [themes addObject:theme];
    }
    
    // Ensure the output param is a valid path
    NSString *outputPath = settings.mtf_output;
    NSURL *outputDirectoryURL = [NSURL
        mtf_directoryURLFromPathParameter:outputPath];
    
    if (!outputDirectoryURL) {
        gbfprintln(stderr, @"[!] Error: '%@' is an invalid directory path. Please supply another.", outputPath);
        return 1;
    }

    NSError *error;
    BOOL success = [self generateSymbolsForThemes:themes inDirectory:outputDirectoryURL withSettings:settings error:&error];
    if (!success) {
        gbfprintln(stderr, @"[!] Error: unable to generate theme files: %@.", error);
        return 1;
    }

    return 0;
}

- (BOOL)generateSymbolsForThemes:(NSArray *)themes inDirectory:(NSURL *)directory withSettings:(GBSettings *)settings error:(NSError **)error {
    NSParameterAssert(themes != nil);
    NSParameterAssert(directory != nil);
    NSParameterAssert(settings != nil);

    switch (settings.mtf_symbolLanguage) {
    case MTFSymbolLaunguageObjC:
        for (MTFTheme *theme in themes) {
            BOOL success = [theme
                generateObjCSymbolsFilesInDirectory:directory
                indentation:settings.mtf_indentation
                prefix:settings.mtf_prefix
                error:error];

            if (!success) return NO;
        }
        
        // If there is more than one theme, generate an umbrella header to
        // enable consumers to import all symbols files at once
        if (themes.count > 1) {
            BOOL success = [MTFTheme
                generateObjCSymbolsUmbrellaHeaderFromThemes:themes
                inDirectory:directory
                prefix:settings.mtf_prefix
                error:error];

            if (!success) return NO;
        }

        break;

    case MTFSymbolLaunguageSwift:
        for (MTFTheme *theme in themes) {
            BOOL success = [theme
                generateSwiftSymbolsFileInDirectory:directory
                indentation:settings.mtf_indentation
                error:error];

            if (!success) return NO;
        }

        break;
    }

    return YES;
}

@end

int MTFCLIMain(int argc, const char *argv[]) {
    int result = 0;

    @autoreleasepool {
        GBSettings *defaultSettings = [GBSettings mtf_settingsWithName:@"defaults" parent:nil];
        GBSettings *settings = [GBSettings mtf_settingsWithName:@"arguments" parent:defaultSettings];
        
        [defaultSettings mtf_applyDefaults];
        
        GBOptionsHelper *options = [[GBOptionsHelper alloc] init];
        [options mtf_registerOptions];
        
        GBCommandLineParser *parser = [[GBCommandLineParser alloc] init];
        [parser registerSettings:settings];
        [parser registerOptions:options];
        [parser parseOptionsWithArguments:(char **)argv count:argc];
        
        // If there are either no args supplied or the help arg is supplied,
        // display help and exit
        if (argc == 1 || settings.mtf_help) {
            [options printHelp];
            return 0;
        }
        
        result = [[[MTFCLI alloc] init] runWithSettings:settings];
    }

    return result;
}

NS_ASSUME_NONNULL_END
