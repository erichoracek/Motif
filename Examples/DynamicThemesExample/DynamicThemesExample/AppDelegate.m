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
#import "ThemeSymbols.h"

@interface AppDelegate ()

@property (nonatomic) AUTTheme *lightTheme;
@property (nonatomic) AUTTheme *darkTheme;

@end

@implementation AppDelegate

#pragma mark - AppDelegate <UIApplicationDelegate>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Default to light theme
    AUTThemeApplier *themeApplier = [[AUTThemeApplier alloc] initWithTheme:self.lightTheme];
    
    ButtonsViewController *viewController = [[ButtonsViewController alloc] initWithThemeApplier:themeApplier lightTheme:self.lightTheme darkTheme:self.darkTheme];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [themeApplier applyClassWithName:NavigationThemeClassNames.NavigationBar toObject:navigationController.navigationBar];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - AppDelegate

- (AUTTheme *)lightTheme
{
    if (!_lightTheme) {
        NSError *error;
        AUTTheme *theme = [AUTTheme themeFromThemesNamed:@[
            ColorsThemeName,
            TypographyThemeName,
            LightMappingsThemeName,
            ButtonsThemeName,
            NavigationThemeName,
            ContentThemeName
        ] error:&error];
        NSAssert(!error, @"Error loading theme: %@", error);
        self.lightTheme = theme;
    }
    return _lightTheme;
}

- (AUTTheme *)darkTheme
{
    if (!_darkTheme) {
        NSError *error;
        AUTTheme *theme = [AUTTheme themeFromThemesNamed:@[
            ColorsThemeName,
            TypographyThemeName,
            DarkMappingsThemeName,
            ButtonsThemeName,
            NavigationThemeName,
            ContentThemeName
        ] error:&error];
        NSAssert(!error, @"Error loading theme: %@", error);
        self.darkTheme = theme;
    }
    return _darkTheme;
}

@end
