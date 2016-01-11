//
//  MTFTheme.m
//  Motif
//
//  Created by Eric Horacek on 12/22/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import "MTFTheme.h"
#import "MTFTheme_Private.h"
#import "MTFThemeClass_Private.h"
#import "MTFThemeClass.h"
#import "MTFThemeConstant.h"
#import "MTFThemeConstant_Private.h"
#import "MTFThemeParser.h"
#import "NSURL+ThemeFiles.h"
#import "MTFYAMLSerialization.h"
#import "MTFErrors.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MTFTheme

#pragma mark - NSObject

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Use the designated initializer instead" userInfo:nil];
}

#pragma mark - MTFTheme

#pragma mark Public

+ (nullable instancetype)themeFromFileNamed:(NSString *)themeName error:(NSError **)error {
    NSParameterAssert(themeName);
    
    return [self themeFromFilesNamed:@[ themeName ] error:error];
}

+ (nullable instancetype)themeFromFilesNamed:(NSArray<NSString *> *)themeNames error:(NSError **)error {
    NSParameterAssert(themeNames);
    NSAssert(themeNames.count > 0, @"Must provide at least one theme name");
    
    return [self themeFromFilesNamed:themeNames bundle:nil error:error];
}

+ (nullable instancetype)themeFromFilesNamed:(NSArray<NSString *> *)themeNames bundle:(nullable NSBundle *)bundle error:(NSError **)error {
    NSParameterAssert(themeNames);
    NSAssert(themeNames.count > 0, @"Must provide at least one theme name");
    
    // Build an array of URLs from the specified theme names
    NSArray<NSURL *> *fileURLs = [NSURL
        mtf_fileURLsFromThemeNames:themeNames
        inBundle:bundle
        error:error];

    if (fileURLs == nil) return nil;
    
    return [[MTFTheme alloc] initWithFiles:fileURLs error:error];
}

- (nullable instancetype)initWithFile:(NSURL *)fileURL error:(NSError **)error; {
    NSParameterAssert(fileURL);
    
    return [self initWithFiles:@[ fileURL ] error:error];
}

- (nullable instancetype)initWithFiles:(NSArray<NSURL *> *)fileURLs error:(NSError **)error {
    NSParameterAssert(fileURLs);
    NSAssert(fileURLs.count > 0, @"Must provide at least one file URL");
    
    NSMutableArray<NSDictionary *> *themeDictionaries = [NSMutableArray new];
    NSMutableArray<NSURL *> *validFileURLs = [NSMutableArray new];
    
    for (NSURL *fileURL in fileURLs) {
        NSDictionary *themeDictionary = [fileURL mtf_themeDictionaryWithError:error];
        if (themeDictionary == nil) return nil;

        [themeDictionaries addObject:themeDictionary];
        [validFileURLs addObject:fileURL];
    }

    self = [self initWithThemeDictionaries:themeDictionaries error:error];

    for (NSURL *fileURL in validFileURLs) {
        [self addFileURLsObject:fileURL];
    }

    return self;
}

- (nullable instancetype)initWithThemeDictionary:(NSDictionary<NSString *, id> *)dictionary error:(NSError **)error {
    NSParameterAssert(dictionary != nil);
    
    return [self initWithThemeDictionaries:@[ dictionary ] error:error];
}

- (nullable instancetype)initWithThemeDictionaries:(NSArray<NSDictionary<NSString *, id> *> *)dictionaries error:(NSError **)error {
    NSParameterAssert(dictionaries != nil);
    NSAssert(dictionaries.count > 0, @"Must provide at least one theme dictionary");
    
    self = [super init];

    for (NSDictionary *dictionary in dictionaries) {
        NSError *parseError;
        MTFThemeParser *parser = [[MTFThemeParser alloc]
            initWithRawTheme:dictionary
            inheritingFromTheme:self
            error:&parseError];

        if (parseError != nil) {
            if (error != NULL) {
                *error = parseError;
            }
            return nil;
        }

        [self addConstantsFromDictionary:parser.parsedConstants];
        [self addClassesFromDictionary:parser.parsedClasses];
    }

    return self;
}

- (nullable id)constantValueForName:(NSString *)name {
    NSParameterAssert(name);
    
    return self.constants[name].value;
}

- (nullable MTFThemeClass *)classForName:(NSString *)name {
    NSParameterAssert(name);
    
    return self.classes[name];
}

- (BOOL)applyClassWithName:(NSString *)name to:(id)applicant error:(NSError **)error {
    NSParameterAssert(name);
    NSParameterAssert(applicant);
    
    MTFThemeClass *class = [self classForName:name];

    if (class == nil) {
        if (error != NULL) {
            NSString *desciption = [NSString stringWithFormat:
                @"Unable to locate theme class named '%@' to apply to %@ from "\
                    "%@",
                name,
                applicant,
                self];

            *error = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToApplyTheme userInfo:@{
                NSLocalizedDescriptionKey: desciption,
            }];
        }

        return NO;
    }

    return [class applyTo:applicant error:error];
}

#pragma mark Private

#pragma mark Names

- (NSArray<NSString *> *)names {
    NSMutableArray<NSString *> *names = [NSMutableArray new];
    for (NSURL *fileURL in self.fileURLs) {
        [names addObject:fileURL.mtf_themeName];
    }
    return [names copy];
}

#pragma mark Filenames

- (NSArray<NSString *> *)filenames {
    NSMutableArray<NSString *> *filenames = [NSMutableArray new];
    for (NSURL *fileURL in self.fileURLs) {
        [filenames addObject:fileURL.lastPathComponent];
    }
    return [filenames copy];
}

#pragma mark FileURLs

- (NSArray<NSURL *> *)fileURLs {
    if (!_fileURLs) {
        self.fileURLs = [NSMutableArray new];
    }
    return _fileURLs;
}

- (void)addFileURLsObject:(NSURL *)fileURL {
    NSMutableSet<NSURL *> *fileURLs = [self.fileURLs mutableCopy];
    [fileURLs addObject:fileURL];
    self.fileURLs = [fileURLs copy];
}

#pragma mark Constants

- (NSDictionary<NSString *, MTFThemeConstant *> *)constants {
    if (!_constants) {
        _constants = [NSDictionary new];
    }
    return _constants;
}

- (void)addConstantsFromDictionary:(NSDictionary<NSString *, MTFThemeConstant *> *)dictionary {
    if (!dictionary.count) {
        return;
    }
    NSMutableDictionary<NSString *, MTFThemeConstant *> *constants = [self.constants mutableCopy];
    [constants addEntriesFromDictionary:dictionary];
    self.constants = [constants copy];
}

#pragma mark Classes

- (NSDictionary<NSString *, MTFThemeClass *> *)classes {
    if (!_classes) {
        _classes = [NSDictionary new];
    }
    return _classes;
}

- (void)addClassesFromDictionary:(NSDictionary<NSString *, MTFThemeClass *> *)dictionary {
    if (!dictionary.count) {
        return;
    }
    NSMutableDictionary<NSString *, MTFThemeClass *> *classes = [self.classes mutableCopy];
    [classes addEntriesFromDictionary:dictionary];
    self.classes = [classes copy];
}

@end

NS_ASSUME_NONNULL_END
