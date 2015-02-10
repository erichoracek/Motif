//
//  AUTTheme.h
//  AUTTheming
//
//  Created by Eric Horacek on 12/22/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AUTThemeClass;

/**
 
 */
@interface AUTTheme : NSObject

/**
 Creates a theme object from a theme file with the specified name.
 
 @param themeName The name of the theme file. If the theme file ends with "Theme", then you may alternatively specify only the prefix before "Theme" as the theme name. Required.
 @param error     If an error occurs, upon return contains an NSError object that describes the problem.
 
 @return A theme object.
 */
+ (instancetype)themeFromThemeNamed:(NSString *)themeName error:(NSError **)error __attribute__ ((nonnull (1)));

/**
 Creates a theme object from a set of one or mores theme files with the specified names.
 
 @param themeNames Names of the theme files as NSStrings. If the theme file ends with "Theme", then you may alternatively specify only the prefix before "Theme" as the theme name. Required.
 @param error      If an error occurs, upon return contains an NSError object that describes the problem.
 
 @return A theme object.
 */
+ (instancetype)themeFromThemesNamed:(NSArray *)themeNames error:(NSError **)error __attribute__ ((nonnull (1)));

/**
 Creates a theme object from a set of one or mores theme files with the specified names.
 
 @param themeNames The names of the theme file. If the theme file ends with "Theme", then you may alternatively specify only the prefix before "Theme" as the theme name. Required.
 @param bundle     The bundle that the themes should be loaded from. Optional.
 @param error      If an error occurs, upon return contains an NSError object that describes the problem.
 
 @return A theme object.
 */
+ (instancetype)themeFromThemesNamed:(NSArray *)themeNames bundle:(NSBundle *)bundle error:(NSError **)error __attribute__ ((nonnull (1)));

/**
 Initializes a theme from a theme file.
 
 @param fileURL The NSURL reference to the theme file that the theme object should be created from. Required.
 @param error   If an error occurs, upon return contains an NSError object that describes the problem.
 
 @return A theme object.
 */
- (instancetype)initWithFile:(NSURL *)fileURL error:(NSError **)error __attribute__ ((nonnull (1)));

/**
 Initializes a theme from a theme file.
 
 @param files   An array of NSURL reference to the theme file that the theme object should be created from. Required.
 @param error   If an error occurs, upon return contains an NSError object that describes the problem.
 
 @return A theme object.
 */
- (instancetype)initWithFiles:(NSArray *)fileURLs error:(NSError **)error NS_DESIGNATED_INITIALIZER __attribute__ ((nonnull (1)));

/**
 The names of the themes that have been registered with this theme, in the order that they were added.
 
 Does not include the extension of the theme name. If the file name is "Filename.json", the name for will be "Filename". If the name is "ColorsTheme.json", the name will be "Colors".
 */
@property (nonatomic, readonly) NSArray *names;

/**
 The constant value from the theme collection for the specified key.
 
 @param key The key for the desired constant.
 
 @return The constant value for the specified key, or if there is none, `nil`.
 */
- (id)constantValueForKey:(NSString *)key;

/**
 The class object for the specified class name.
 
 @param name The name of the desired class.
 
 @return The class for the specified name, or if there is none, `nil`.
 */
- (AUTThemeClass *)themeClassForName:(NSString *)name;

@end

/**
 The domain for theme parsing errors.
 */
extern NSString * const AUTThemingErrorDomain;
