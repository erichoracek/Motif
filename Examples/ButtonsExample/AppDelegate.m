//
//  AppDelegate.m
//  ButtonsExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

@import Motif;

#import "ButtonsViewController.h"
#import "ThemeSymbols.h"

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions {
    NSError *error;
    MTFTheme *theme = [MTFTheme themeFromFileNamed:ThemeName error:&error];
    NSAssert(theme != nil, @"Error loading theme: %@", error);
    
    ButtonsViewController *viewController = [[ButtonsViewController alloc] initWithThemeApplier:theme];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end

NS_ASSUME_NONNULL_END
