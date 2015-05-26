//
//  NSURL+ThemeNaming.m
//  Motif
//
//  Created by Eric Horacek on 3/6/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "NSURL+ThemeNaming.h"
#import "NSURL+LastPathComponentWithoutExtension.h"
#import "MTFYAMLSerialization.h"
#import "MTFTheme.h"

MTF_NS_ASSUME_NONNULL_BEGIN

static NSString * const ThemeNameOptionalSuffix = @"Theme";
static NSString * const JSONExtension = @"json";
static NSString * const YAMLExtension = @"yaml";

NSString * const MTFThemeFileNotFoundException = @"MTFThemeFileNotFoundException";

@implementation NSURL (ThemeNaming)

- (mtf_nullable NSString *)mtf_themeName {
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

+ (NSArray *)mtf_fileURLsFromThemeNames:(NSArray *)themeNames inBundle:(mtf_nullable NSBundle *)bundle {
    NSParameterAssert(themeNames);
    
    // Default to main bundle if bundle is nil
    if (!bundle) {
        bundle = NSBundle.mainBundle;
    }
    
    // Build an array of fileURLs from the passed themeNames
    NSMutableArray *fileURLs = [NSMutableArray new];

    for (NSString *themeName in themeNames) {
        // Ensure the theme names are strings
        NSAssert(
            [themeName isKindOfClass:NSString.class],
            @"The provided theme names must be of class NSString. %@ is "
                "instead kind of class %@",
            themeName,
            themeName.class);

        NSURL *JSONFileURL = [self mtf_fileURLFromThemeName:themeName inBundle:bundle withExtension:JSONExtension];
        NSURL *YAMLFileURL = [self mtf_fileURLFromThemeName:themeName inBundle:bundle withExtension:YAMLExtension];

        // If no file is found, throw an exception
        if (JSONFileURL != nil && YAMLFileURL != nil) {
            NSArray *JSONSuggestedURLs = [bundle URLsForResourcesWithExtension:JSONExtension subdirectory:nil];
            NSArray *YAMLSuggestedURLs = [bundle URLsForResourcesWithExtension:YAMLExtension subdirectory:nil];
            NSArray *combinedSuggestedURLs = [JSONSuggestedURLs arrayByAddingObjectsFromArray:YAMLSuggestedURLs];

            NSString *reason = [NSString stringWithFormat:
                @"No theme was found with the name '%@' in the bundle %@. Perhaps "
                    "you meant one of the following: %@",
                themeName,
                bundle,
                combinedSuggestedURLs];

            @throw [[NSException alloc] initWithName:MTFThemeFileNotFoundException reason:reason userInfo:nil];
        } else if (JSONFileURL != nil) {
            [fileURLs addObject:JSONFileURL];
        } else if (YAMLFileURL != nil) {
            [fileURLs addObject:YAMLFileURL];
        }
    }
    return [fileURLs copy];
}

+ (NSURL *)mtf_fileURLFromThemeName:(NSString *)themeName inBundle:(NSBundle *)bundle withExtension:(NSString *)extension {
    NSURL *fileURL = [bundle URLForResource:themeName withExtension:extension];
    
    // If a theme with the exact name is not found, try appending 'Theme' to the
    // end of the filename
    if (!fileURL) {
        NSString *themeNameWithThemeAppended = [themeName stringByAppendingString:ThemeNameOptionalSuffix];
        
        fileURL = [bundle URLForResource:themeNameWithThemeAppended withExtension:extension];
    }

    return fileURL;
}

- (mtf_nullable NSDictionary *)mtf_themeDictionaryWithError:(NSError * __autoreleasing *)error {
    // If the file is not a file URL, populate the error object
    if (!self.isFileURL) {
        if (error) {
            NSString *localizedDescription = [NSString stringWithFormat:
                @"The specified file URL is invalid %@",
                self];

            *error = [NSError
                errorWithDomain:MTFThemingErrorDomain
                code:1
                userInfo:@{
                    NSLocalizedDescriptionKey : localizedDescription
                }];
        }
        return nil;
    }
    
    NSData *data = [NSData dataWithContentsOfURL:self options:0 error:error];
    
    if (!data) {
        if (error) {
            NSString *localizedDescription = [NSString stringWithFormat:
                @"Unable to load contents of file at URL %@",
                self];

            *error = [NSError
                errorWithDomain:MTFThemingErrorDomain
                code:1
                userInfo:@{
                    NSLocalizedDescriptionKey : localizedDescription
                }];
        }
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
    default:
        return nil;
    }
    
    if (![object isKindOfClass:NSDictionary.class]) {
        if (error && !*error) {
            NSString *localizedDescription = [NSString stringWithFormat:
                @"The theme file named '%@' does not have a dictionary as the "
                    "root object. It is instead an '%@'.",
                self.mtf_themeName,
                [object class]];

            *error = [NSError
                errorWithDomain:MTFThemingErrorDomain
                code:1
                userInfo:@{
                    NSLocalizedDescriptionKey : localizedDescription
                }];
        }
        return nil;
    }

    return object;
}

- (MTFThemeFileType)mtf_themeFileType {
    NSString *extension = self.pathExtension;

    if ([extension isEqual:JSONExtension]) return MTFThemeFileTypeJSON;
    if ([extension isEqual:YAMLExtension]) return MTFThemeFileTypeYAML;
    return MTFThemeFileTypeInvalid;
}

@end

MTF_NS_ASSUME_NONNULL_END
