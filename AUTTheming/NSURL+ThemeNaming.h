//
//  NSURL+ThemeNaming.h
//  Pods
//
//  Created by Eric Horacek on 3/6/15.
//
//

#import <Foundation/Foundation.h>
#import "AUTBackwardsCompatableNullability.h"

AUT_NS_ASSUME_NONNULL_BEGIN

@interface NSURL (ThemeNaming)

/**
 The theme name derived from this NSURL, if there is one.
 */
@property (nonatomic, readonly, aut_nullable) NSString *aut_themeName;

/**
 Returns an array of NSURLs matching the theme names passed in to the method.
 
 If a theme name is not found for one of the specified names, an execption thrown.
 
 @param themeNames The theme names that corresponding NSURLs should be located 
                   for.
 @param bundle     The bundle that should be searched. Defaults to the main
                   bundle if no bundle is passed.
 
 @return An array of NSURLs.
 */
+ (NSArray *)aut_fileURLsFromThemeNames:(NSArray *)themeNames inBundle:(aut_nullable NSBundle *)bundle;

@end

AUT_NS_ASSUME_NONNULL_END
