//
//  NSURL+ThemeFiles.h
//  Motif
//
//  Created by Eric Horacek on 3/6/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Motif/MTFBackwardsCompatableNullability.h>

MTF_NS_ASSUME_NONNULL_BEGIN

@interface NSURL (ThemeFiles)

/**
 The theme name derived from this URL, if there is one.
 */
@property (nonatomic, readonly, mtf_nullable) NSString *mtf_themeName;

/**
 Returns an array of NSURLs matching the theme names passed into the method.
 
 If a theme name is not found for one of the specified names, the 
 MTFThemeFileNotFoundException exception is thrown.
 
 @param themeNames The theme names that corresponding NSURLs should be located 
                   for.
 @param bundle     The bundle that should be searched. Defaults to the main
                   bundle if no bundle is specified.
 
 @return An array of NSURLs matching the theme names passed into the method.
 */
+ (NSArray *)mtf_fileURLsFromThemeNames:(NSArray *)themeNames inBundle:(mtf_nullable NSBundle *)bundle;

/**
 The dictionary representation of the theme file contents at this URL, if there
 are any.
 
 If this URL does not represent a valid theme file, this method will populate
 the error paramter and return nil.
 
 @param error If an error occurs, upon return contains an NSError object that
              describes the problem.
              
 @return The dictionary representation of the theme file contents at this URL.
 */
- (mtf_nullable NSDictionary *)mtf_themeDictionaryWithError:(NSError **)error;

@end

/**
 The execption that is thrown when a theme is queried for that does not exist.
 
 Thrown when invoking `mtf_fileURLsFromThemeNames:inBundle:`.
 */
extern NSString * const MTFThemeFileNotFoundException;

MTF_NS_ASSUME_NONNULL_END
