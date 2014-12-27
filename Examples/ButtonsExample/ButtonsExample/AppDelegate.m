//
//  AppDelegate.m
//  ButtonsExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <AUTTheming/AUTTheming.h>
#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    AUTTheme *theme = [AUTTheme new];
    
    NSError *error;
    [theme addAttributesFromThemeAtURL:[[NSBundle mainBundle] URLForResource:@"Theme" withExtension:@"json"] error:&error];
    NSAssert(!error, @"Error when adding attributes to theme: %@", error);
    
    ViewController *viewController = [ViewController new];
    viewController.aut_theme = theme;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = viewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
