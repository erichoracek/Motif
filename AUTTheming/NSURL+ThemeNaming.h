//
//  NSURL+ThemeNaming.h
//  Pods
//
//  Created by Eric Horacek on 3/6/15.
//
//

#import <Foundation/Foundation.h>

@interface NSURL (ThemeNaming)

@property (nonatomic, readonly) NSString *aut_themeName;

+ (NSArray *)aut_fileURLsFromThemeNames:(NSArray *)themeNames inBundle:(NSBundle *)bundle;

@end
