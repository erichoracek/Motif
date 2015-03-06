//
//  AUTTheme.m
//  AUTTheming
//
//  Created by Eric Horacek on 12/22/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import "AUTTheme.h"
#import "AUTTheme+Private.h"
#import "AUTThemeClass+Private.h"
#import "AUTThemeClass.h"
#import "AUTThemeConstant.h"
#import "AUTThemeConstant+Private.h"
#import "AUTThemeParser.h"
#import "NSURL+LastPathComponentWithoutExtension.h"

NSString * const AUTThemingErrorDomain = @"com.automatic.AUTTheming";

@implementation AUTTheme

#pragma mark - NSObject

- (instancetype)init
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    // Ensure that exception is thrown when just `init` is called.
    self = [self initWithFile:nil error:NULL];
#pragma clang diagnostic pop
    return self;
}

#pragma mark - AUTTheme

#pragma mark Public

+ (instancetype)themeFromThemeNamed:(NSString *)themeName error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(themeName);
    
    return [self themeFromThemesNamed:@[themeName] error:error];
}

+ (instancetype)themeFromThemesNamed:(NSArray *)themeNames error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(themeNames);
    NSAssert(themeNames.count > 0, @"Must provide at least one theme name");
    
    return [self themeFromThemesNamed:themeNames bundle:nil error:error];
}

+ (instancetype)themeFromThemesNamed:(NSArray *)themeNames bundle:(NSBundle *)bundle error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(themeNames);
    NSAssert(themeNames.count > 0, @"Must provide at least one theme name");
    
    // Default to main bundle if bundle is nil
    if (!bundle) {
        bundle = [NSBundle mainBundle];
    }
    
    // Build an array of URLs from the specified theme names
    NSArray *fileURLs = [self fileURLsFromThemeNames:themeNames inBundle:bundle];
    
    return [[AUTTheme alloc] initWithFiles:fileURLs error:error];
}

- (instancetype)initWithFile:(NSURL *)fileURL error:(NSError **)error;
{
    NSParameterAssert(fileURL);
    self = [self initWithFiles:@[fileURL] error:error];
    return self;
}

- (instancetype)initWithFiles:(NSArray *)fileURLs error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(fileURLs);
    NSAssert(fileURLs.count > 0, @"Must provide at least one file URL");
    self = [super init];
    if (self) {
        for (NSURL *fileURL in fileURLs) {
            [self addAttributesFromThemeAtURL:fileURL error:error];
        }
    }
    return self;
}

- (void)addAttributesFromThemeAtURL:(NSURL *)fileURL error:(NSError *__autoreleasing *)error
{
    // If the file is not a file URL, populate the error object
    if (!fileURL.isFileURL) {
        if (error) {
            *error = [NSError errorWithDomain:AUTThemingErrorDomain code:1 userInfo:@{
                NSLocalizedDescriptionKey : [NSString stringWithFormat:@"The specified file URL is invalid %@.", fileURL]
            }];
        }
        return;
    }
    
    NSDictionary *JSONDictionary = [self dictionaryFromJSONFileAtURL:fileURL error:error];
    // If the file is invalid JSON, return before registering it
    if (!JSONDictionary) {
        return;
    }
    
    [self addFileURLsObject:fileURL];
    
    NSString *filename = fileURL.lastPathComponent;
    [self addFilenamesObject:filename];
    
    NSString *name = [self nameFromFileURL:fileURL];
    [self addNamesObject:name];
    
    [self addConstantsAndClassesFromRawTheme:JSONDictionary error:error];
}

- (id)constantValueForKey:(NSString *)key
{
    return [self constantForKey:key].value;
}

- (AUTThemeClass *)themeClassForName:(NSString *)name
{
    return self.mappedClasses[name];
}

#pragma mark Theme Names

- (NSArray *)names
{
    if (!_names) {
        self.names = [NSArray new];
    }
    return _names;
}

#pragma mark - Private

- (void)addConstantsAndClassesFromRawTheme:(NSDictionary *)rawTheme error:(NSError *__autoreleasing *)error;
{
    NSParameterAssert(rawTheme);
    
    AUTThemeParser *parser = [[AUTThemeParser alloc] initWithRawTheme:rawTheme inheritingFromTheme:self error:error];
    
    [self addMappedConstantsFromDictionary:parser.parsedConstants error:error];
    [self addMappedClassesFromDictionary:parser.parsedClasses error:error];
}

#pragma mark JSON

- (NSDictionary *)dictionaryFromJSONFileAtURL:(NSURL *)URL error:(NSError **)error
{
    NSData *JSONData = [NSData dataWithContentsOfURL:URL options:0 error:error];
    if (!JSONData) {
        return nil;
    }
    NSDictionary *JSONDictionary = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:error];
    return JSONDictionary;
}

#pragma mark Names

static NSString * const ThemeNameOptionalSuffix = @"Theme";

- (NSString *)nameFromFileURL:(NSURL *)fileURL
{
    NSString *filenameWithoutExtension = fileURL.aut_lastPathComponentWithoutExtension;
    NSString *name = filenameWithoutExtension;
    // If the theme name ends with "Theme", then trim it out of the name
    NSRange themeRange = [filenameWithoutExtension rangeOfString:ThemeNameOptionalSuffix];
    if (themeRange.location != NSNotFound) {
        BOOL isThemeAtEndOfThemeName = (themeRange.location == (name.length - themeRange.length));
        BOOL isThemeSubstring = (themeRange.location != 0);
        if (isThemeAtEndOfThemeName && isThemeSubstring) {
            name = [name stringByReplacingCharactersInRange:themeRange withString:@""];
        }
    }
    return name;
}

static NSString * const JSONExtension = @"json";

+ (NSArray *)fileURLsFromThemeNames:(NSArray *)themeNames inBundle:(NSBundle *)bundle
{
    // Build an array of fileURLs from the passed themeNames
    NSMutableArray *fileURLs = [NSMutableArray new];
    for (NSString *themeName in themeNames) {
        
        // Ensure the theme names are strings
        NSAssert([themeName isKindOfClass:[NSString class]], @"The provided theme names must be of class NSString. %@ is instead kind of class %@", themeName, [themeName class]);
        
        NSURL *fileURL = [bundle URLForResource:themeName withExtension:JSONExtension];
        
        // If a theme with the exact name is not found, try appending 'Theme' to the end of the filename
        if (!fileURL) {
            NSString *themeNameWithThemeAppended = [themeName stringByAppendingString:ThemeNameOptionalSuffix];
            fileURL = [bundle URLForResource:themeNameWithThemeAppended withExtension:JSONExtension];
        }
        
        // If no file is found, throw an exception
        NSAssert(fileURLs, @"No theme was found with the name '%@' in the bundle %@. Perhaps you meant one of the following: %@", themeName, bundle, [bundle URLsForResourcesWithExtension:JSONExtension subdirectory:nil]);
        [fileURLs addObject:fileURL];
    }
    return [fileURLs copy];
}

- (void)addNamesObject:(NSString *)object
{
    NSMutableArray *names = [self.names mutableCopy];
    [names addObject:object];
    self.names = [names copy];
}

#pragma mark Filenames

- (NSArray *)filenames
{
    if (!_filenames) {
        self.filenames = [NSMutableArray new];
    }
    return _filenames;
}

- (void)addFilenamesObject:(NSString *)filename
{
    NSMutableSet *filenames = [self.filenames mutableCopy];
    [filenames addObject:filename];
    self.filenames = [filenames copy];
}

#pragma mark FileURLs

- (NSArray *)fileURLs
{
    if (!_fileURLs) {
        self.fileURLs = [NSMutableArray new];
    }
    return _fileURLs;
}

- (void)addFileURLsObject:(NSURL *)fileURL
{
    NSMutableSet *fileURLs = [self.fileURLs mutableCopy];
    [fileURLs addObject:fileURL];
    self.fileURLs = [fileURLs copy];
}

#pragma mark Constants

- (AUTThemeConstant *)constantForKey:(NSString *)key
{
    return self.mappedConstants[key];
}

- (NSDictionary *)mappedConstants
{
    if (!_mappedConstants) {
        _mappedConstants = [NSDictionary new];
    }
    return _mappedConstants;
}

- (void)addMappedConstantsFromDictionary:(NSDictionary *)dictionary error:(NSError *__autoreleasing *)error
{
    if (!dictionary.count) {
        return;
    }
    NSMutableDictionary *constants = [self.mappedConstants mutableCopy];
    [constants addEntriesFromDictionary:dictionary];
    self.mappedConstants = [constants copy];
}

#pragma mark Classes

- (NSDictionary *)mappedClasses
{
    if (!_mappedClasses) {
        _mappedClasses = [NSDictionary new];
    }
    return _mappedClasses;
}

- (void)addMappedClassesFromDictionary:(NSDictionary *)dictionary error:(NSError *__autoreleasing *)error
{
    if (!dictionary.count) {
        return;
    }
    NSMutableDictionary *classes = [self.mappedClasses mutableCopy];
    [classes addEntriesFromDictionary:dictionary];
    self.mappedClasses = [classes copy];
}

@end

@implementation AUTTheme (Testing)

- (instancetype)initWithRawTheme:(NSDictionary *)rawTheme error:(NSError *__autoreleasing *)error
{
    self = [self initWithRawThemes:@[rawTheme] error:error];
    return self;
}

- (instancetype)initWithRawThemes:(NSArray *)rawThemes error:(NSError *__autoreleasing *)error
{
    self = [super init];
    if (self) {
        for (NSDictionary *rawTheme in rawThemes) {
            [self addConstantsAndClassesFromRawTheme:rawTheme error:error];
        }
    }
    return self;
}

@end
