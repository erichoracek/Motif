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
 The filenames of the themes that have been registered with this theme collection, in the order that they were added.
 
 Does not include the extension of the theme name. If the file name is "filename.json", the name for will be "filename".
 */
@property (nonatomic, readonly) NSArray *names;

/**
 If the JSON at the specified URL does not exist or is unable to be parsed, an error is returned in the pass-by-reference error parameter.
 */
- (void)addAttributesFromThemeAtURL:(NSURL *)URL error:(NSError **)error;

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
