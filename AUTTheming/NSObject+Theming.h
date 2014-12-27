//
//  NSObject+Theming.h
//  Pods
//
//  Created by Eric Horacek on 12/25/14.
//
//

#import <Foundation/Foundation.h>

@class AUTTheme;

@interface NSObject (Theming)

@property (nonatomic, copy, setter=aut_setThemeClassName:) NSString *aut_themeClassName;

@property (nonatomic, setter=aut_setTheme:) AUTTheme *aut_theme;

- (void)aut_applyTheme;

- (void)aut_applyTheme:(AUTTheme *)theme;

- (void)aut_applyThemeClassWithName:(NSString *)class;

- (void)aut_applyThemeClassWithName:(NSString *)class fromTheme:(AUTTheme *)theme;

@end
