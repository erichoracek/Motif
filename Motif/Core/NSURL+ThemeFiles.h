//
//  NSURL+ThemeFiles.h
//  Motif
//
//  Created by Eric Horacek on 3/6/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (ThemeFiles)

/**
 The theme name derived from this URL, if there is one.
 */
@property (nonatomic, readonly, nullable) NSString *mtf_themeName;

/**
 Returns an array of NSURLs matching the theme names passed into the method.
 
 If a theme name is not found for one of the specified names, the 
 MTFThemeFileNotFoundException exception is thrown.
 
 @param themeNames The theme names that corresponding NSURLs should be located 
                   for.
 @param bundle     The bundle that should be searched. Defaults to the main
                   bundle if no bundle is specified.
                   
 @param error If an error occurs, upon return contains an NSError object that
              describes the problem.
 
 @return An array of NSURLs matching the theme names passed into the method, or
         nil if any of the names were invalid.
 */
+ (nullable NSArray<NSURL *> *)mtf_fileURLsFromThemeNames:(NSArray<NSString *> *)themeNames inBundle:(nullable NSBundle *)bundle error:(NSError **)error;

/**
 The dictionary representation of the theme file contents at this URL, if there
 are any.
 
 If this URL does not represent a valid theme file, this method will populate
 the error paramter and return nil.
 
 @param error If an error occurs, upon return contains an NSError object that
              describes the problem.
              
 @return The dictionary representation of the theme file contents at this URL.
 */
- (nullable NSDictionary *)mtf_themeDictionaryWithError:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
