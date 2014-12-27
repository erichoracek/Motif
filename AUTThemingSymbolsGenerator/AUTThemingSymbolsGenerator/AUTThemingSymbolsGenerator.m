//
//  AUTThemingSymbolsGenerator.m
//  AUTThemingSymbolsGenerator
//
//  Created by Eric Horacek on 12/28/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <GBCli/GBCli.h>
#import <AUTTheming/AUTTheming.h>
#import "AUTThemingSymbolsGenerator.h"
#import "GBSettings+ThemingSymbolsGenerator.h"
#import "GBOptionsHelper+ThemingSymbolsGenerator.h"
#import "AUTTheme+SymbolsGeneration.h"
#import "NSURL+CLIHelpers.h"

@implementation AUTThemingSymbolsGenerator

+ (instancetype)sharedInstance
{
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

- (int)runWithSettings:(GBSettings *)settings;
{
    // Build an array of `AUTThemes` from the passed `theme` path params
    NSMutableArray *themes = [NSMutableArray new];
    for (NSString *themePath in settings.aut_themes) {
        NSURL *themeURL = [NSURL fileURLFromPathParameter:themePath];
        if (!themeURL) {
            gbfprintln(stderr, @"[!] Error: '%@' is an invalid file path. Please supply another.", themePath);
            return 1;
        }
        AUTTheme *theme = [AUTTheme new];
        NSError *error;
        [theme addAttributesFromThemeAtURL:themeURL error:&error];
        if (error) {
            gbfprintln(stderr, @"[!] Error: Unable to parse theme at URL '%@': %@", themeURL, error);
            return 1;
        }
        [themes addObject:theme];
    }
    
    // Ensure the output param is a valid path
    NSString *outputPath = settings.aut_output;
    NSURL *outputDirectoryURL = [NSURL directoryURLFromPathParameter:outputPath];
    if (!outputDirectoryURL) {
        gbfprintln(stderr, @"[!] Error: '%@' is an invalid directory path. Please supply another.", outputPath);
        return 1;
    }
    
    for (AUTTheme *theme in themes) {
        [theme generateSymbolsFilesInDirectory:outputDirectoryURL indentation:settings.aut_indentation prefix:settings.aut_prefix];
    }
    
    return 0;
}

@end

int AUTThemingSymbolsGeneratorMain(int argc, const char *argv[])
{
    int result = 0;
    @autoreleasepool {
        
        GBSettings *defaultSettings = [GBSettings aut_settingsWithName:@"defaults" parent:nil];
        GBSettings *settings = [GBSettings aut_settingsWithName:@"arguments" parent:defaultSettings];
        [defaultSettings aut_applyDefaults];
        
        GBOptionsHelper *options = [GBOptionsHelper new];
        [options aut_registerOptions];
        
        GBCommandLineParser *parser = [GBCommandLineParser new];
        [parser registerSettings:settings];
        [parser registerOptions:options];
        [parser parseOptionsWithArguments:(char **)argv count:argc];
        
        // If there are either no args supplied or the help arg is supplied, display help and exit
        if (argc == 1 || settings.aut_help) {
            [options printHelp];
            return 0;
        }
        
        result = [[AUTThemingSymbolsGenerator sharedInstance] runWithSettings:settings];
    }
    return result;
}
