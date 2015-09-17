//
//  MTFTheme.h
//  Motif
//
//  Created by Eric Horacek on 12/22/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MTFThemeClass;

/**
 A collection of classes and constants used to style interface objects.
 
 Themes are immutable. If you want to change the theme that is applied to an
 object at runtime, use an MTFDynamicThemeApplier or any of its subclasses.
 
 Themes can be created from JSON or YAML theme files, which have the following
 syntax to denote classes and constants:
 
 Classes: Denoted by a leading period (e.g. .Button) and encoded as a nested 
 dictionary/map, a class is a collection of named properties corresponding to
 values that together define the style of an element in your interface. Class
 property values can be any Foundation type, or alternatively references to
 other classes or constants.
 
 Constants: Denoted by a leading dollar sign (e.g. $RedColor) and encoded as 
 a key-value pair, a constant is a named reference to a value. Constant values 
 can be any Foundation types, or alternatively a reference to a class or
 constant.
 */
@interface MTFTheme : NSObject

- (instancetype)init NS_UNAVAILABLE;

/**
 Creates a theme object from a theme file with the specified name.
 
 @param themeName The name of the theme file. If the theme file ends with
                  "Theme", then you may alternatively specify only the prefix
                  before "Theme" as the theme name. Required.
 @param error     If an error occurs, upon return contains an NSError object
                  that describes the problem.
 
 @return A theme object.
 */
+ (instancetype)themeFromFileNamed:(NSString *)themeName error:(NSError **)error;

/**
 Creates a theme object from a set of one or mores theme files with the
 specified names.
 
 @param themeNames Names of the theme files as NSStrings. If the theme file ends
                   with "Theme", then you may alternatively specify only the
                   prefix before "Theme" as the theme name. Required.
 @param error      If an error occurs, upon return contains an NSError object
                   that describes the problem.
 
 @return A theme object.
 */
+ (instancetype)themeFromFilesNamed:(NSArray *)themeNames error:(NSError **)error;

/**
 Creates a theme object from a set of one or mores theme files with the
 specified names.
 
 @param themeNames The names of the theme file. If the theme file ends with
                   "Theme", then you may alternatively specify only the prefix
                   before "Theme" as the theme name. Required.
 @param bundle     The bundle that the themes should be loaded from. Optional.
 @param error      If an error occurs, upon return contains an NSError object
                   that describes the problem.
 
 @return A theme object.
 */
+ (instancetype)themeFromFilesNamed:(NSArray *)themeNames bundle:(nullable NSBundle *)bundle error:(NSError **)error;

/**
 Initializes a theme from a theme file.
 
 @param fileURL The NSURL reference to the theme file that the theme object
                should be created from. Required.
 @param error   If an error occurs, upon return contains an NSError object that
                describes the problem.
 
 @return A theme object.
 */
- (instancetype)initWithFile:(NSURL *)fileURL error:(NSError **)error;

/**
 Initializes a theme from a theme file.
 
 @param files An array of NSURL reference to the theme file that the theme
              object should be created from. Required.
 @param error If an error occurs, upon return contains an NSError object that
              describes the problem.
 
 @return A theme object.
 */
- (instancetype)initWithFiles:(NSArray *)fileURLs error:(NSError **)error;

/**
 Initializes a theme from a theme dictionary.
 
 @param dictionary The dictionary to initialze the theme from. Should follow the
                   syntax of the theme files. Required.
 @param error      If an error occurs, upon return contains an NSError object
                   that describes the problem.
 
 @return A theme object.
 */
- (instancetype)initWithThemeDictionary:(NSDictionary *)dictionary error:(NSError **)error;

/**
 Initializes a theme from an array of theme dictionaries.
 
 @param dictionaries The dictionaries to initialze the theme from. Should mirror
                     the syntax of the theme files. Required.
 @param error        If an error occurs, upon return contains an NSError object
                     that describes the problem.
 
 @return A theme object.
 */
- (instancetype)initWithThemeDictionaries:(NSArray *)dictionaries error:(NSError **)error;

/**
 The constant value from the theme collection for the specified key.
 
 @param name The name of the desired constant.
 
 @return The constant value for the specified name, or if there is none, `nil`.
 */
- (nullable id)constantValueForName:(NSString *)name;

/**
 The class object for the specified class name.
 
 @param name The name of the desired class.
 
 @return The class for the specified name, or if there is none, `nil`.
 */
- (nullable MTFThemeClass *)classForName:(NSString *)name;

/**
 Applies a theme class with the specified name to an object.
 
 @param name   If name is nil or does not map to an existing class on theme,
               this method has no effect.
 @param object If the object is nil or has no registered class appliers, this
               method has no effect.
 
 @return Whether the class was applied to the object.
 */
- (BOOL)applyClassWithName:(NSString *)name toObject:(id)object;

@end

/**
 The domain for theme parsing errors.
 */
extern NSString * const MTFThemingErrorDomain;

NS_ASSUME_NONNULL_END
