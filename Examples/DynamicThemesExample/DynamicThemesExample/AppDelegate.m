//
//  AppDelegate.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 1/1/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import <AUTTheming/AUTTheming.h>
#import "ButtonsViewController.h"
#import "AppDelegate.h"
#import "NavigationSymbols.h"

@interface AppDelegate ()

@property (nonatomic) AUTTheme *lightTheme;
@property (nonatomic) AUTTheme *darkTheme;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    AUTThemeApplier *themeApplier = [[AUTThemeApplier alloc] initWithTheme:self.lightTheme];
    ButtonsViewController *viewController = [[ButtonsViewController alloc] initWithThemeApplier:themeApplier lightTheme:self.lightTheme darkTheme:self.darkTheme];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [themeApplier applyClassWithName:NavigationClassNames.NavigationBar toObject:navigationController.navigationBar];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (AUTTheme *)lightTheme
{
    if (!_lightTheme) {
        self.lightTheme = ({
            AUTTheme *theme = [AUTTheme new];
            NSError *error;
            [theme addAttributesFromThemeAtURL:[[NSBundle mainBundle] URLForResource:@"Colors" withExtension:@"json"] error:&error];
            NSAssert(!error, @"Error when adding attributes to theme: %@", error);
            [theme addAttributesFromThemeAtURL:[[NSBundle mainBundle] URLForResource:@"Typography" withExtension:@"json"] error:&error];
            NSAssert(!error, @"Error when adding attributes to theme: %@", error);
            [theme addAttributesFromThemeAtURL:[[NSBundle mainBundle] URLForResource:@"LightMappings" withExtension:@"json"] error:&error];
            NSAssert(!error, @"Error when adding attributes to theme: %@", error);
            [theme addAttributesFromThemeAtURL:[[NSBundle mainBundle] URLForResource:@"Buttons" withExtension:@"json"] error:&error];
            NSAssert(!error, @"Error when adding attributes to theme: %@", error);
            [theme addAttributesFromThemeAtURL:[[NSBundle mainBundle] URLForResource:@"Navigation" withExtension:@"json"] error:&error];
            NSAssert(!error, @"Error when adding attributes to theme: %@", error);
            theme;
        });
    }
    return _lightTheme;
}

- (AUTTheme *)darkTheme
{
    if (!_darkTheme) {
        self.darkTheme = ({
            AUTTheme *theme = [AUTTheme new];
            NSError *error;
            [theme addAttributesFromThemeAtURL:[[NSBundle mainBundle] URLForResource:@"Colors" withExtension:@"json"] error:&error];
            NSAssert(!error, @"Error when adding attributes to theme: %@", error);
            [theme addAttributesFromThemeAtURL:[[NSBundle mainBundle] URLForResource:@"Typography" withExtension:@"json"] error:&error];
            NSAssert(!error, @"Error when adding attributes to theme: %@", error);
            [theme addAttributesFromThemeAtURL:[[NSBundle mainBundle] URLForResource:@"DarkMappings" withExtension:@"json"] error:&error];
            NSAssert(!error, @"Error when adding attributes to theme: %@", error);
            [theme addAttributesFromThemeAtURL:[[NSBundle mainBundle] URLForResource:@"Buttons" withExtension:@"json"] error:&error];
            NSAssert(!error, @"Error when adding attributes to theme: %@", error);
            [theme addAttributesFromThemeAtURL:[[NSBundle mainBundle] URLForResource:@"Navigation" withExtension:@"json"] error:&error];
            NSAssert(!error, @"Error when adding attributes to theme: %@", error);
            theme;
        });
    }
    return _darkTheme;
}

@end
