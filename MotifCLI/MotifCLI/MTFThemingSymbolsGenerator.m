//
//  MTFThemingSymbolsGenerator.m
//  MTFThemingSymbolsGenerator
//
//  Created by Eric Horacek on 12/28/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <GBCli/GBCli.h>
#import <Motif/Motif.h>
#import <Motif/MTFThemeParser.h>
#import "MTFThemingSymbolsGenerator.h"
#import "GBSettings+ThemingSymbolsGenerator.h"
#import "GBOptionsHelper+ThemingSymbolsGenerator.h"
#import "MTFTheme+SymbolsGenerationObjC.h"
#import "MTFTheme+SymbolsGenerationSwift.h"
#import "NSURL+CLIHelpers.h"

@implementation MTFThemingSymbolsGenerator

+ (instancetype)sharedInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

- (int)runWithSettings:(GBSettings *)settings {
    // Do not resolve references when parsing themes
    [MTFThemeParser setShouldResolveReferences:NO];
    
    // Build an array of `MTFThemes` from the passed `theme` path params
    NSMutableArray *themes = [NSMutableArray new];
    for (NSString *themePath in settings.mtf_themes) {
        NSURL *themeURL = [NSURL mtf_fileURLFromPathParameter:themePath];
        if (!themeURL) {
            gbfprintln(stderr, @"[!] Error: '%@' is an invalid file path. Please supply another.", themePath);
            return 1;
        }
        NSError *error;
        MTFTheme *theme = [[MTFTheme alloc]
            initWithFile:themeURL
            error:&error];
        if (error) {
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

    [self generateSymbolsForThemes:themes inDirectory:outputDirectoryURL withSettings:settings];

    return 0;
}

- (void)generateSymbolsForThemes:(NSArray *)themes inDirectory:(NSURL *)directory withSettings:(GBSettings *)settings {
    switch (settings.mtf_symbolLanguage) {
    case MTFSymbolLaunguageObjC:
        for (MTFTheme *theme in themes) {
            [theme
                generateObjCSymbolsFilesInDirectory:directory
                indentation:settings.mtf_indentation
                prefix:settings.mtf_prefix];
        }
        
        // If there is more than one theme, generate an umbrella header to
        // enable consumers to import all symbols files at once
        if (themes.count > 1) {
            [MTFTheme
                generateObjCSymbolsUmbrellaHeaderFromThemes:themes
                inDirectory:directory
                prefix:settings.mtf_prefix];
        }

        break;

    case MTFSymbolLaunguageSwift:
        for (MTFTheme *theme in themes) {
            [theme generateSwiftSymbolsFileInDirectory:directory indentation:settings.mtf_indentation];
        }

        break;
    }
}

@end

int MTFThemingSymbolsGeneratorMain(int argc, const char *argv[]) {
    int result = 0;

    @autoreleasepool {
        GBSettings *defaultSettings = [GBSettings mtf_settingsWithName:@"defaults" parent:nil];
        GBSettings *settings = [GBSettings mtf_settingsWithName:@"arguments" parent:defaultSettings];
        
        [defaultSettings mtf_applyDefaults];
        
        GBOptionsHelper *options = [GBOptionsHelper new];
        [options mtf_registerOptions];
        
        GBCommandLineParser *parser = [GBCommandLineParser new];
        [parser registerSettings:settings];
        [parser registerOptions:options];
        [parser parseOptionsWithArguments:(char **)argv count:argc];
        
        // If there are either no args supplied or the help arg is supplied,
        // display help and exit
        if (argc == 1 || settings.mtf_help) {
            [options printHelp];
            return 0;
        }
        
        result = [MTFThemingSymbolsGenerator.sharedInstance runWithSettings:settings];
    }

    return result;
}
