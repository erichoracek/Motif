//
//  GBSettings+ThemingSymbolsGenerator.h
//  AUTThemingSymbolsGenerator
//
//  Created by Eric Horacek on 12/28/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <GBCli/GBCli.h>

extern NSString * const AUTSettingsOptionThemes;
extern NSString * const AUTSettingsOptionPrefix;
extern NSString * const AUTSettingsOptionOutput;
extern NSString * const AUTSettingsOptionTabs;
extern NSString * const AUTSettingsOptionIndentationCount;
extern NSString * const AUTSettingsOptionHelp;
extern NSString * const AUTSettingsOptionVerbose;

@interface GBSettings (ThemingSymbolsGenerator)

+ (instancetype)aut_settingsWithName:(NSString *)name parent:(GBSettings *)parent;

- (void)aut_applyDefaults;

@property (nonatomic, setter=aut_setThemes:) NSArray *aut_themes;

@property (nonatomic, setter=aut_setPrefix:) NSString *aut_prefix;

@property (nonatomic, setter=aut_setOutput:) NSString *aut_output;

@property (nonatomic, setter=aut_setShouldIndentUsingTabs:) BOOL aut_shouldIndentUsingTabs;

@property (nonatomic, setter=aut_setIndentationCount:) NSInteger aut_indentationCount;

@property (nonatomic, setter=aut_setHelp:) BOOL aut_help;

@property (nonatomic, setter=aut_setVerbose:) BOOL aut_verbose;

#pragma mark - Derived Properties

- (NSString *)aut_indentation;

@end
