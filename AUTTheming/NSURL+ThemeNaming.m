//
//  NSURL+ThemeNaming.m
//  Pods
//
//  Created by Eric Horacek on 3/6/15.
//
//

#import "NSURL+ThemeNaming.h"
#import "NSURL+LastPathComponentWithoutExtension.h"

static NSString * const ThemeNameOptionalSuffix = @"Theme";

@implementation NSURL (ThemeNaming)

- (NSString *)aut_themeName
{
    NSString *filenameWithoutExtension = self.aut_lastPathComponentWithoutExtension;
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

+ (NSArray *)aut_fileURLsFromThemeNames:(NSArray *)themeNames inBundle:(NSBundle *)bundle
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

@end
