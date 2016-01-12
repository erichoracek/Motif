//
//  NSURL+ThemeFiles.m
//  Motif
//
//  Created by Eric Horacek on 3/6/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "NSURL+LastPathComponentWithoutExtension.h"
#import "NSBundle+ExtensionURLs.h"

#import "MTFYAMLSerialization.h"
#import "MTFErrors.h"

#import "NSURL+ThemeFiles.h"

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

+ (nullable NSArray<NSURL *> *)mtf_fileURLsFromThemeNames:(NSArray<NSString *> *)themeNames inBundle:(nullable NSBundle *)bundle error:(NSError **)error {
    NSParameterAssert(themeNames != nil);
    
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
            if (error != NULL) {
                NSArray<NSURL *> *suggestedURLs = [bundle
                    mtf_URLsForResourcesWithExtensions:self.class.mtf_themeFileExtensions
                    subdirectory:nil];

                NSString *description = [NSString stringWithFormat:
                    @"No theme was found with the name '%@' in the bundle %@. "\
                        "Perhaps you meant one of the following: %@",
                    themeName,
                    bundle,
                    suggestedURLs];

                *error = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToParseTheme userInfo:@{
                    NSInternalInconsistencyException: description,
                }];
            }

            return nil;
        }
        
        [fileURLs addObject:fileURL];
    }

    return [fileURLs copy];
}

- (nullable NSDictionary *)mtf_themeDictionaryWithError:(NSError * *)error {
    // If the file is not a file URL, populate the error object
    if (!self.isFileURL) {
        if (error == nil) return nil;

        NSString *localizedDescription = [NSString stringWithFormat:
            @"The specified file URL is invalid %@",
            self];

        *error = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToParseTheme userInfo:@{
            NSLocalizedDescriptionKey : localizedDescription
        }];

        return nil;
    }

    NSError *dataError;
    NSData *data = [NSData dataWithContentsOfURL:self options:0 error:&dataError];
    
    if (data == nil) {
        if (error == NULL) return nil;

        NSString *description = [NSString stringWithFormat:
            @"Unable to load contents of file at URL %@",
            self];

        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:@{
            NSLocalizedDescriptionKey : description,
        }];

        userInfo[NSUnderlyingErrorKey] = dataError;

        *error = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToParseTheme userInfo:userInfo];

        return nil;
    }

    id object;
    NSError *parseError;
    switch (self.mtf_themeFileType) {
    case MTFThemeFileTypeJSON:
        object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];

    break;
    case MTFThemeFileTypeYAML:
        object = [MTFYAMLSerialization YAMLObjectWithData:data error:&parseError];

    break;
    default: {
        if (error == NULL) return nil;

        NSString *localizedDescription = [NSString stringWithFormat:
            @"Invalid extension '%@' for theme file named '%@', expected one "
                "of: %@.",
            self.pathExtension,
            self.mtf_themeName,
            self.class.mtf_themeFileExtensions];

        *error = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToParseTheme userInfo:@{
            NSLocalizedDescriptionKey : localizedDescription
        }];

        return nil;
    }
    break;
    }

    if (object == nil) {
        if (error == nil) return nil;

        NSString *description = [NSString stringWithFormat:
            @"Unable to parse theme file named '%@'",
            self.mtf_themeName];

        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:@{
            NSLocalizedDescriptionKey : description,
        }];

        userInfo[NSUnderlyingErrorKey] = parseError;

        *error = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToParseTheme userInfo:userInfo];

        return nil;
    }
    
    if (![object isKindOfClass:NSDictionary.class]) {
        if (error == nil) return nil;

        NSString *localizedDescription = [NSString stringWithFormat:
            @"The theme file named '%@' does not have a dictionary as the "
                "root object. It is instead %@.",
            self.mtf_themeName,
            [object class]];

        *error = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToParseTheme userInfo:@{
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
