//
//  AppDelegate.m
//  ButtonsExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

@import Motif;

#import "AppDelegate.h"
#import "ButtonsViewController.h"
#import "ThemeSymbols.h"

NS_ASSUME_NONNULL_BEGIN

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions {
    NSError *error;
    MTFTheme *theme = [MTFTheme themeFromFileNamed:ThemeName error:&error];
    NSAssert(error == nil, @"Error loading theme: %@", error);
    
    ButtonsViewController *viewController = [[ButtonsViewController alloc] initWithTheme:theme];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end

NS_ASSUME_NONNULL_END
