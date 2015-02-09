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
#import "NSURL+LastPathComponentWithoutExtension.h"

// Public
NSString * const AUTThemingErrorDomain = @"com.automatic.AUTTheming";
// Private
NSString * const AUTThemeSuperclassKey = @"_superclass";
NSString * const AUTThemeConstantsKey = @"constants";
NSString * const AUTThemeClassesKey = @"classes";

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

#pragma mark - Public

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

static NSString * const JSONExtension = @"json";

+ (instancetype)themeFromThemesNamed:(NSArray *)themeNames bundle:(NSBundle *)bundle error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(themeNames);
    NSAssert(themeNames.count > 0, @"Must provide at least one theme name");
    
    // Default to main bundle if bundle is nil
    if (!bundle) {
        bundle = [NSBundle mainBundle];
    }
    
    NSMutableArray *fileURLs = [NSMutableArray new];
    for (NSString *themeName in themeNames) {
        NSAssert([themeName isKindOfClass:[NSString class]], @"The provided theme names must be of class NSString. %@ is instead kind of class %@", themeName, [themeName class]);
        NSURL *fileURL = [bundle URLForResource:themeName withExtension:JSONExtension];
        // If a theme with the exact name is not found, try appending 'Theme' to the end of the filename
        if (!fileURL) {
            NSString *themeNameWithThemeAppended = [NSString stringWithFormat:@"%@Theme", themeName];
            fileURL = [bundle URLForResource:themeNameWithThemeAppended withExtension:JSONExtension];
        }
        NSAssert(fileURLs, @"No theme was found for the name: %@ in the bundle: %@. Perhaps you meant one of the following: %@", themeName, bundle, [bundle URLsForResourcesWithExtension:JSONExtension subdirectory:nil]);
        [fileURLs addObject:fileURL];
    }
    return [[AUTTheme alloc] initWithFiles:fileURLs error:error];
}

- (instancetype)initWithFile:(NSURL *)fileURL error:(NSError **)error;
{
    NSParameterAssert(fileURL);
    self = [self initWithFiles:@[fileURL] error:error];
    return self;
}

- (instancetype)initWithFiles:(NSArray *)fileURLs error:(NSError **)error
{
    NSAssert(fileURLs.count > 0, @"Must provide at least one file URL.");
    self = [super init];
    if (self) {
        for (NSURL *fileURL in fileURLs) {
            [self addAttributesFromThemeAtURL:fileURL error:error];
        }
    }
    return self;
}

- (void)addAttributesFromThemeAtURL:(NSURL *)fileURL error:(NSError **)error
{
    // If the file is not a file URL, populate the error object
    if (!fileURL.isFileURL && error) {
        NSString *errorDescription = [NSString stringWithFormat:@"The URL %@ is not a valid file URL.", fileURL];
        *error = [NSError errorWithDomain:AUTThemingErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey : errorDescription}];
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
    
    [self addConstantsAndClassesFromRawAttributesDictionary:JSONDictionary error:error];
}

- (id)constantValueForKey:(NSString *)key
{
    return [self constantForKey:key].mappedValue;
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

- (void)addConstantsAndClassesFromRawAttributesDictionary:(NSDictionary *)dictionary error:(NSError *__autoreleasing *)error;
{
    NSParameterAssert(dictionary);
    
    [self addConstantsFromRawAttributesDictionary:dictionary error:error];
    if (error && *error) {
        return;
    }
    
    [self addClassesFromRawAttributesDictionary:dictionary error:error];
    if (error && *error) {
        return;
    }
}

#pragma mark Validation

- (NSDictionary *)validatedDictionaryValueWithKey:(NSString *)key fromRawDictionary:(NSDictionary *)rawAttributesDictionary error:(NSError *__autoreleasing *)error
{
    NSDictionary *value = rawAttributesDictionary[key];
    // If there is no value for the specified key, is it not an error, just return
    if (!value) {
        return nil;
    }
    // If the value for the specified key is a dictionary but is not a valid type, return with error
    if (![value isKindOfClass:[NSDictionary class]] && error) {
        NSString *errorDescription = [NSString stringWithFormat:@"The value for the '%@' key is not a dictionary.", key];
        *error = [NSError errorWithDomain:AUTThemingErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey : errorDescription}];
        return nil;
    }
    return value;
}

#pragma mark Constants

- (void)addConstantsFromRawAttributesDictionary:(NSDictionary *)rawAttributesDictionary error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(rawAttributesDictionary);
    NSDictionary *rawConstants = [self validatedDictionaryValueWithKey:AUTThemeConstantsKey fromRawDictionary:rawAttributesDictionary error:error];
    if (!rawConstants) {
        return;
    }
    NSDictionary *constants = [self constantsMappedFromRawConstants:rawConstants];
    [self addMappedConstantsFromDictionary:constants error:error];
}

- (NSDictionary *)constantsMappedFromRawConstants:(NSDictionary *)rawConstants
{
    NSMutableDictionary *constants = [NSMutableDictionary new];
    [rawConstants enumerateKeysAndObjectsUsingBlock:^(NSString *key, id rawValue, BOOL *stop) {
        AUTThemeConstant *constant = [self themeConstantMappedFromRawConstants:rawConstants withRawValue:rawValue forKey:key];
        constants[key] = constant;
    }];
    return [constants copy];
}

- (AUTThemeConstant *)themeConstantMappedFromRawConstants:(NSDictionary *)rawConstants withRawValue:(NSString *)rawValue forKey:(NSString *)key
{
    id mappedValue;
    
    // If the passed rawValue exists as a constants key for this theme, set it as the mapped value
    id mappedRawValue = rawConstants[rawValue];
    if (mappedRawValue) {
        mappedValue = mappedRawValue;
    }
    
    // If the passed constant's value or the mapped value is a reference to an existing constant from a previous theme, set it as the mapped value
    AUTThemeConstant *existingConstant = (self.mappedConstants[rawValue] ?: self.mappedConstants[mappedValue]);
    if (existingConstant) {
        mappedValue = existingConstant.mappedValue;
    }
    
    // If the value is a class
    AUTThemeClass *existingClass = (self.mappedClasses[rawValue] ?: self.mappedClasses[mappedValue]);
    if (existingClass) {
        mappedValue = existingClass;
    }
    
    return [[AUTThemeConstant alloc] initWithKey:key rawValue:rawValue mappedValue:mappedValue];
}

#pragma mark Classes

- (void)addClassesFromRawAttributesDictionary:(NSDictionary *)rawAttributesDictionary error:(NSError **)error
{
    NSParameterAssert(rawAttributesDictionary);
    NSDictionary *rawClasses = [self validatedDictionaryValueWithKey:AUTThemeClassesKey fromRawDictionary:rawAttributesDictionary error:error];
    if (!rawClasses) {
        return;
    }
    NSDictionary *mappedClasses = [self classesMappedFromRawClasses:rawClasses error:error];
    [self addMappedClassesFromDictionary:mappedClasses error:error];
}

- (NSDictionary *)classesMappedFromRawClasses:(NSDictionary *)rawClasses error:(NSError **)error
{
    NSMutableDictionary *mappedClasses = [NSMutableDictionary new];
    
    for (id name in rawClasses) {
        NSDictionary *rawProperties = [self validatedDictionaryValueWithKey:name fromRawDictionary:rawClasses error:error];
        if (!rawProperties) {
            break;
        }
        AUTThemeClass *themeClass = [self themeClassMappedFromRawProperties:rawProperties withName:name error:error];
        if (themeClass) {
            mappedClasses[name] = themeClass;
        }
    }
    
    // If any of the class properties contain references to other classes, map them to class objects
    [mappedClasses enumerateKeysAndObjectsUsingBlock:^(id key, AUTThemeClass *class, BOOL *stop) {
        [class.propertiesConstants enumerateKeysAndObjectsUsingBlock:^(id key, AUTThemeConstant *constant, BOOL *stop) {
            id class = mappedClasses[constant.mappedValue];
            if (class) {
                constant.mappedValue = class;
                return;
            }
            class = self.mappedClasses[constant.mappedValue];
            if (class) {
                constant.mappedValue = class;
                return;
            }
        }];
    }];
    
    // If any of the values for the superclass key do not resolve to class, pass error
    // Error must be defined as __block because an exception is thrown when a pointer is dereferenced within a block enumerator
    __block NSError *__error;
    [mappedClasses enumerateKeysAndObjectsUsingBlock:^(id key, AUTThemeClass *class, BOOL *stop) {
        [class.propertiesConstants enumerateKeysAndObjectsUsingBlock:^(id key, AUTThemeConstant *constant, BOOL *stop) {
            if ([key isEqualToString:AUTThemeSuperclassKey] && ![constant.mappedValue isKindOfClass:[AUTThemeClass class]]) {
                NSString *errorDescription = [NSString stringWithFormat:@"The value for the 'superclass' property in '%@' must reference a valid theme class. It is currently '%@'", class.name, constant.mappedValue];
                __error = [NSError errorWithDomain:AUTThemingErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: errorDescription}];
            }
        }];
    }];
    if (error && __error) {
        *error = __error;
    }
    
    return [mappedClasses copy];
}

- (AUTThemeClass *)themeClassMappedFromRawProperties:(NSDictionary *)rawProperties withName:(NSString *)name error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(name);
    NSParameterAssert(rawProperties);
    
    NSDictionary *mappedProperties = [self constantsMappedFromRawConstants:rawProperties];
    AUTThemeClass *themeClass = [[AUTThemeClass alloc] initWithName:name propertiesConstants:mappedProperties];
    themeClass.name = name;
    
    return themeClass;
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

- (NSString *)nameFromFileURL:(NSURL *)fileURL
{
    NSString *filenameWithoutExtension = fileURL.aut_lastPathComponentWithoutExtension;
    NSString *name = filenameWithoutExtension;
    // If the theme name ends with "Theme", then trim it out of the name
    NSRange themeRange = [filenameWithoutExtension rangeOfString:@"Theme"];
    if (themeRange.location != NSNotFound) {
        BOOL isThemeAtEndOfThemeName = (themeRange.location == (name.length - themeRange.length));
        BOOL isThemeSubstring = (themeRange.location != 0);
        if (isThemeAtEndOfThemeName && isThemeSubstring) {
            name = [name stringByReplacingCharactersInRange:themeRange withString:@""];
        }
    }
    return name;
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
    NSSet *intersectingKeys = [self entriesFromDictionary:dictionary willIntersectKeysWhenAddedToDictionary:self.mappedConstants];
    if (intersectingKeys.count && error) {
        NSString *errorDescription = [NSString stringWithFormat:@"Registering new constants with identical names to previously-defined constants will overwrite existing constants with the following names: %@", intersectingKeys];
        *error = [NSError errorWithDomain:AUTThemingErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey : errorDescription}];
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
    NSSet *intersectingKeys = [self entriesFromDictionary:dictionary willIntersectKeysWhenAddedToDictionary:self.mappedClasses];
    if (intersectingKeys.count && error) {
        NSString *errorDescription = [NSString stringWithFormat:@"Registering new classes with identical names to previously-defined classes will overwrite existing classes with the following names: %@", intersectingKeys];
        *error = [NSError errorWithDomain:AUTThemingErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey : errorDescription}];
    }
    
    NSMutableDictionary *classes = [self.mappedClasses mutableCopy];
    [classes addEntriesFromDictionary:dictionary];
    self.mappedClasses = [classes copy];
}

#pragma mark Overlapping Dictionary Keys

- (NSSet *)entriesFromDictionary:(NSDictionary *)fromDictionary willIntersectKeysWhenAddedToDictionary:(NSDictionary *)toDictionary
{
    NSSet *existingKeys = [NSSet setWithArray:toDictionary.allKeys];
    NSSet *newKeys = [NSSet setWithArray:fromDictionary.allKeys];
    if ([existingKeys intersectsSet:newKeys]) {
        NSMutableSet *intersectingKeys = [existingKeys mutableCopy];
        [intersectingKeys intersectSet:newKeys];
        return intersectingKeys;
    }
    return nil;
}

@end

@implementation AUTTheme (Testing)

- (instancetype)initWithRawAttributesDictionary:(NSDictionary *)dictionary error:(NSError *__autoreleasing *)error
{
    self = [self initWithRawAttributesDictionaries:@[dictionary] error:error];
    return self;
}

- (instancetype)initWithRawAttributesDictionaries:(NSArray *)dictionaries error:(NSError *__autoreleasing *)error
{
    self = [super init];
    if (self) {
        for (NSDictionary *dictionary in dictionaries) {
            [self addConstantsAndClassesFromRawAttributesDictionary:dictionary error:error];
        }
    }
    return self;
}

@end
