//
//  NSURL+ThemeFiles.m
//  Motif
//
//  Created by Eric Horacek on 3/6/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "NSURL+ThemeFiles.h"
#import "NSURL+LastPathComponentWithoutExtension.h"
#import "NSBundle+ExtensionURLs.h"
#import "MTFYAMLSerialization.h"
#import "MTFTheme.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MTFThemeFileType) {
    MTFThemeFileTypeInvalid,
    MTFThemeFileTypeJSON,
    MTFThemeFileTypeYAML
};

static NSString * const ThemeNameOptionalSuffix = @"Theme";
static NSString * const JSONExtension = @"json";
static NSString * const YAMLExtension = @"yaml";
static NSString * const YAMLExtensionShort = @"yml";

NSString * const MTFThemeFileNotFoundException = @"MTFThemeFileNotFoundException";

@implementation NSURL (ThemeFiles)

#pragma mark - Public

- (nullable NSString *)mtf_themeName {
    NSString *filenameWithoutExtension = self.mtf_lastPathComponentWithoutExtension;
    NSString *name = filenameWithoutExtension;
    // If the theme name ends with "Theme", then trim it out of the name
    NSRange themeRange = [filenameWithoutExtension rangeOfString:ThemeNameOptionalSuffix];

    if (themeRange.location != NSNotFound) {
        NSUInteger endLocation = (name.length - themeRange.length);
        BOOL isThemeAtEndOfThemeName = (themeRange.location == endLocation);
        BOOL isThemeSubstring = (themeRange.location != 0);

        if (isThemeAtEndOfThemeName && isThemeSubstring) {
            name = [name stringByReplacingCharactersInRange:themeRange withString:@""];
        }
    }
    return name;
}

+ (NSArray<NSURL *> *)mtf_fileURLsFromThemeNames:(NSArray<NSString *> *)themeNames inBundle:(nullable NSBundle *)bundle {
    NSParameterAssert(themeNames);
    
    // Default to main bundle if bundle is nil
    if (bundle == nil) bundle = NSBundle.mainBundle;
    
    // Build an array of fileURLs from the passed themeNames
    NSMutableArray<NSURL *> *fileURLs = [NSMutableArray new];

    for (NSString *themeName in themeNames) {
        // Ensure the theme names are strings
        NSAssert(
            [themeName isKindOfClass:NSString.class],
            @"The provided theme names must be of class NSString. %@ is "
                "instead kind of class %@",
            themeName,
            themeName.class);

        NSURL *fileURL = [self
            mtf_firstFileURLFromThemeName:themeName
            inBundle:bundle
            withExtensions:self.class.mtf_themeFileExtensions];

        // If no file is found, throw an exception
        if (fileURL == nil) {
            NSArray<NSURL *> *suggestedURLs = [bundle
                mtf_URLsForResourcesWithExtensions:self.class.mtf_themeFileExtensions
                subdirectory:nil];

            NSString *reason = [NSString stringWithFormat:
                @"No theme was found with the name '%@' in the bundle %@. Perhaps "
                    "you meant one of the following: %@",
                themeName,
                bundle,
                suggestedURLs];

            @throw [[NSException alloc] initWithName:MTFThemeFileNotFoundException reason:reason userInfo:nil];
        } else {
            [fileURLs addObject:fileURL];
        }
    }

    return [fileURLs copy];
}

- (nullable NSDictionary *)mtf_themeDictionaryWithError:(NSError * __autoreleasing *)error {
    // If the file is not a file URL, populate the error object
    if (!self.isFileURL) {
        if (error == nil) return nil;

        NSString *localizedDescription = [NSString stringWithFormat:
            @"The specified file URL is invalid %@",
            self];

        *error = [NSError
            errorWithDomain:MTFThemingErrorDomain
            code:1
            userInfo:@{
                NSLocalizedDescriptionKey : localizedDescription
            }];

        return nil;
    }
    
    NSData *data = [NSData dataWithContentsOfURL:self options:0 error:error];
    
    if (data == nil) {
        if (error == nil) return nil;

        NSString *localizedDescription = [NSString stringWithFormat:
            @"Unable to load contents of file at URL %@",
            self];

        *error = [NSError
            errorWithDomain:MTFThemingErrorDomain
            code:1
            userInfo:@{
                NSLocalizedDescriptionKey : localizedDescription
            }];

        return nil;
    }

    id object;
    switch (self.mtf_themeFileType) {
    case MTFThemeFileTypeJSON:
        object = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];

    break;
    case MTFThemeFileTypeYAML:
        object = [MTFYAMLSerialization YAMLObjectWithData:data error:error];

    break;
    default: {
        if (error == nil) return nil;

        NSString *localizedDescription = [NSString stringWithFormat:
            @"Invalid extension '%@' for theme file named '%@', expected one "
                "of: %@.",
            self.pathExtension,
            self.mtf_themeName,
            self.class.mtf_themeFileExtensions];

        *error = [NSError
            errorWithDomain:MTFThemingErrorDomain
            code:1
            userInfo:@{
                NSLocalizedDescriptionKey : localizedDescription
            }];

        return nil;
    }
    break;
    }
    
    if (![object isKindOfClass:NSDictionary.class]) {
        if (error == nil) return nil;

        NSString *localizedDescription = [NSString stringWithFormat:
            @"The theme file named '%@' does not have a dictionary as the "
                "root object. It is instead '%@'.",
            self.mtf_themeName,
            [object class] ?: @"empty"];

        *error = [NSError
            errorWithDomain:MTFThemingErrorDomain
            code:1
            userInfo:@{
                NSLocalizedDescriptionKey : localizedDescription
            }];

        return nil;
    }

    return object;
}

#pragma mark - Private

+ (nullable NSURL *)mtf_fileURLFromThemeName:(NSString *)themeName inBundle:(NSBundle *)bundle withExtension:(NSString *)extension {
    NSParameterAssert(themeName != nil);
    NSParameterAssert(bundle != nil);
    NSParameterAssert(extension != nil);

    NSURL *fileURL = [bundle URLForResource:themeName withExtension:extension];
    
    // If a theme with the exact name is not found, try appending 'Theme' to the
    // end of the filename
    if (fileURL == nil) {
        NSString *themeNameWithThemeAppended = [themeName stringByAppendingString:ThemeNameOptionalSuffix];
        
        fileURL = [bundle URLForResource:themeNameWithThemeAppended withExtension:extension];
    }

    return fileURL;
}

+ (nullable NSURL *)mtf_firstFileURLFromThemeName:(NSString *)themeName inBundle:(NSBundle *)bundle withExtensions:(NSArray<NSString *> *)extensions {
    NSParameterAssert(themeName != nil);
    NSParameterAssert(bundle != nil);
    NSParameterAssert(extensions != nil);

    for (NSString *extension in extensions) {
        NSURL *fileURL = [self
            mtf_fileURLFromThemeName:themeName
            inBundle:bundle
            withExtension:extension];

        if (fileURL != nil) return fileURL;
    }

    return nil;
}

+ (NSArray<NSString *> *)mtf_themeFileExtensions {
    return @[YAMLExtension, YAMLExtensionShort, JSONExtension];
}

- (MTFThemeFileType)mtf_themeFileType {
    NSString *extension = self.pathExtension;

    if ([extension isEqual:JSONExtension]) return MTFThemeFileTypeJSON;
    if ([extension isEqual:YAMLExtension]) return MTFThemeFileTypeYAML;
    if ([extension isEqual:YAMLExtensionShort]) return MTFThemeFileTypeYAML;

    return MTFThemeFileTypeInvalid;
}

@end

NS_ASSUME_NONNULL_END
