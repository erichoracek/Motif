//
//  GBSettings+ThemingSymbolsGenerator.m
//  AUTThemingSymbolsGenerator
//
//  Created by Eric Horacek on 12/28/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import "GBSettings+ThemingSymbolsGenerator.h"

NSString * const AUTSettingsOptionThemes = @"theme";
NSString * const AUTSettingsOptionPrefix = @"prefix";
NSString * const AUTSettingsOptionOutput = @"output";
NSString * const AUTSettingsOptionTabs = @"tabs";
NSString * const AUTSettingsOptionIndentationCount = @"indentation-count";
NSString * const AUTSettingsOptionHelp = @"help";
NSString * const AUTSettingsOptionVerbose = @"verbose";

@implementation GBSettings (AUTThemingSymbolsGenerator)

+ (instancetype)aut_settingsWithName:(NSString *)name parent:(GBSettings *)parent
{
    id result = [self settingsWithName:name parent:parent];
    if (result) {
        [result registerArrayForKey:AUTSettingsOptionThemes];
    }
    return result;
}

- (void)aut_applyDefaults
{
    self.aut_output = @"./";
    self.aut_prefix = @"AUT";
    self.aut_shouldIndentUsingTabs = NO;
    self.aut_indentationCount = 4;
}

GB_SYNTHESIZE_OBJECT(NSArray *, aut_themes, aut_setThemes, AUTSettingsOptionThemes)
GB_SYNTHESIZE_OBJECT(NSString *, aut_prefix, aut_setPrefix, AUTSettingsOptionPrefix)
GB_SYNTHESIZE_OBJECT(NSString *, aut_output, aut_setOutput, AUTSettingsOptionOutput)
GB_SYNTHESIZE_BOOL(aut_shouldIndentUsingTabs, aut_setShouldIndentUsingTabs, AUTSettingsOptionTabs)
GB_SYNTHESIZE_INT(aut_indentationCount, aut_setIndentationCount, AUTSettingsOptionIndentationCount)
GB_SYNTHESIZE_BOOL(aut_help, aut_setHelp, AUTSettingsOptionHelp)
GB_SYNTHESIZE_BOOL(aut_verbose, aut_setVerbose, AUTSettingsOptionVerbose)

#pragma mark - Derived Properties

- (NSString *)aut_indentationCharacter
{
    return (self.aut_shouldIndentUsingTabs ? @"\t" : @" ");
}

- (NSString *)aut_indentation
{
    NSMutableString *indentationString = [NSMutableString new];
    for (NSInteger characterIndex = 0; characterIndex < self.aut_indentationCount; characterIndex++) {
        [indentationString appendString:self.aut_indentationCharacter];
    }
    return [indentationString copy];
}

@end
