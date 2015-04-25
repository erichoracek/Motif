//
//  AppDelegate.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 1/1/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Motif/Motif.h>
#import "StyleGuideViewController.h"
#import "AppDelegate.h"
#import "ThemeSymbols.h"

@interface AppDelegate ()

@property (nonatomic) MTFTheme *lightTheme;
@property (nonatomic) MTFTheme *darkTheme;
@property (nonatomic) MTFDynamicThemeApplier *themeApplier;

@end

@implementation AppDelegate

#pragma mark - AppDelegate <UIApplicationDelegate>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
#if defined(SCREEN_BRIGHTNESS_THEME_APPLIER)

    self.themeApplier = [[MTFScreenBrightnessThemeApplier alloc]
        initWithScreen:[UIScreen mainScreen]
        lightTheme:self.lightTheme
        darkTheme:self.darkTheme];
    
    StyleGuideViewController *viewController = [[StyleGuideViewController alloc]
        initWithThemeApplier:self.themeApplier];
    
    viewController.navigationItem.title = @"Screen Brightness Theming";
    
#if TARGET_IPHONE_SIMULATOR
    viewController.navigationItem.prompt = @"The theme will only change on-"
        "device.";
#else
    viewController.navigationItem.prompt = @"Adjust the brightness to toggle "
    "the theme.";
#endif
    
#else
    
    self.themeApplier = [[MTFDynamicThemeApplier alloc]
        initWithTheme:self.lightTheme];
    
    StyleGuideViewController *viewController = [[StyleGuideViewController alloc]
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

- (MTFTheme *)lightTheme {
    if (!_lightTheme) {
        NSError *error;
        MTFTheme *theme = [MTFTheme
            themeFromJSONThemesNamed:@[
                ColorsThemeName,
                LightMappingsThemeName,
                TypographyThemeName,
                ControlsThemeName,
                NavigationThemeName,
                ContentThemeName,
                StyleGuideThemeName
            ] error:&error];
        NSAssert(!error, @"Error loading theme: %@", error);
        self.lightTheme = theme;
    }
    return _lightTheme;
}

- (MTFTheme *)darkTheme {
    if (!_darkTheme) {
        NSError *error;
        MTFTheme *theme = [MTFTheme
            themeFromJSONThemesNamed:@[
                ColorsThemeName,
                DarkMappingsThemeName,
                TypographyThemeName,
                ControlsThemeName,
                NavigationThemeName,
                ContentThemeName,
                StyleGuideThemeName
            ] error:&error];
        NSAssert(!error, @"Error loading theme: %@", error);
        self.darkTheme = theme;
    }
    return _darkTheme;
}

#if !defined(SCREEN_BRIGHTNESS_THEME_APPLIER)

- (void)toggleTheme {
    BOOL onLightTheme = (self.themeApplier.theme == self.lightTheme);
    // Changing an MTFDynamicThemeApplier's theme property reapplies it to all
    // previously applied themes
    self.themeApplier.theme = (onLightTheme ? self.darkTheme : self.lightTheme);
}

#endif

@end
