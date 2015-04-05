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
@property (nonatomic) AUTDynamicThemeApplier *themeApplier;

@end

@implementation AppDelegate

#pragma mark - AppDelegate <UIApplicationDelegate>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
#if defined(SCREEN_BRIGHTNESS_THEME_APPLIER)

    self.themeApplier = [[AUTScreenBrightnessThemeApplier alloc]
        initWithScreen:[UIScreen mainScreen]
        lightTheme:self.lightTheme
        darkTheme:self.darkTheme];
    
    ButtonsViewController *viewController = [[ButtonsViewController alloc]
        initWithThemeApplier:self.themeApplier];
    
    viewController.navigationItem.title = @"Screen Brightness Theming";
    viewController.navigationItem.prompt = @"Adjust the brightness to toggle "
        "the theme.";
    
#else
    
    self.themeApplier = [[AUTDynamicThemeApplier alloc]
        initWithTheme:self.lightTheme];
    
    ButtonsViewController *viewController = [[ButtonsViewController alloc]
        initWithThemeApplier:self.themeApplier];
    
    viewController.navigationItem.title = @"Dynamic Theming";
    viewController.navigationItem.prompt = @"Tap the refresh button to toggle "
        "the theme.";
    
    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
        target:self
        action:@selector(toggleTheme)];
    
#endif
    
    UINavigationController *navigationController = [[UINavigationController alloc]
        initWithRootViewController:viewController];
    
    [self.themeApplier
        applyClassWithName:NavigationThemeClassNames.NavigationBar
        toObject:navigationController.navigationBar];
    
    self.window.rootViewController = navigationController;
    self.window.backgroundColor = UIColor.whiteColor;
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - AppDelegate

- (AUTTheme *)lightTheme {
    if (!_lightTheme) {
        NSError *error;
        AUTTheme *theme = [AUTTheme
            themeFromJSONThemesNamed:@[
                ColorsThemeName,
                LightMappingsThemeName,
                TypographyThemeName,
                ControlsThemeName,
                NavigationThemeName,
                ContentThemeName,
                SpecThemeName
            ] error:&error];
        NSAssert(!error, @"Error loading theme: %@", error);
        self.lightTheme = theme;
    }
    return _lightTheme;
}

- (AUTTheme *)darkTheme {
    if (!_darkTheme) {
        NSError *error;
        AUTTheme *theme = [AUTTheme
            themeFromJSONThemesNamed:@[
                ColorsThemeName,
                DarkMappingsThemeName,
                TypographyThemeName,
                ControlsThemeName,
                NavigationThemeName,
                ContentThemeName,
                SpecThemeName
            ] error:&error];
        NSAssert(!error, @"Error loading theme: %@", error);
        self.darkTheme = theme;
    }
    return _darkTheme;
}

#if !defined(SCREEN_BRIGHTNESS_THEME_APPLIER)

- (void)toggleTheme {
    BOOL onLightTheme = (self.themeApplier.theme == self.lightTheme);
    // Changing an AUTDynamicThemeApplier's theme property reapplies it to all
    // previously applied themes
    self.themeApplier.theme = (onLightTheme ? self.darkTheme : self.lightTheme);
}

#endif

@end
