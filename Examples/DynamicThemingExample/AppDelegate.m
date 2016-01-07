//
//  AppDelegate.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 1/1/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import Motif;

#import "StyleGuideViewController.h"
#import "AppDelegate.h"
#import "ThemeSymbols.h"

@interface AppDelegate ()

@property (nonatomic) MTFTheme *lightTheme;
@property (nonatomic) MTFTheme *darkTheme;
@property (nonatomic) MTFDynamicThemeApplier *themeApplier;
@property (nonatomic) BOOL isDisplayingDarkTheme;

@end

@implementation AppDelegate

#pragma mark - AppDelegate <UIApplicationDelegate>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];

    self.lightTheme = [self createLightTheme];
    self.darkTheme = [self createDarkTheme];

#if defined(SCREEN_BRIGHTNESS_THEME_APPLIER)
    
    self.themeApplier = [[MTFScreenBrightnessThemeApplier alloc]
        initWithScreen:UIScreen.mainScreen
        lightTheme:self.lightTheme
        darkTheme:self.darkTheme];
    
    StyleGuideViewController *viewController = [[StyleGuideViewController alloc]
        initWithThemeApplier:self.themeApplier];
    
    viewController.navigationItem.title = @"Screen Brightness Theming";
    
#if TARGET_IPHONE_SIMULATOR
    viewController.navigationItem.prompt = @"The theme will only change on-device.";
#else
    viewController.navigationItem.prompt = @"Adjust the brightness to toggle the theme.";
#endif
    
#else

#if TARGET_IPHONE_SIMULATOR && defined(DEBUG)
    self.themeApplier = [[MTFLiveReloadThemeApplier alloc]
        initWithTheme:self.lightTheme
        sourceFile:__FILE__];
#else
    self.themeApplier = [[MTFDynamicThemeApplier alloc]
        initWithTheme:self.lightTheme];
#endif
    
    StyleGuideViewController *viewController = [[StyleGuideViewController alloc]
        initWithThemeApplier:self.themeApplier];
    
    viewController.navigationItem.title = @"Dynamic Theming";
    viewController.navigationItem.prompt = @"Tap the refresh button to toggle the theme.";
    
    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
        target:self
        action:@selector(toggleTheme)];
    
#endif
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];

    NSError *error;
    if (![self.themeApplier applyClassWithName:NavigationThemeClassNames.NavigationBar to:navigationController.navigationBar error:&error]) {
        NSLog(@"%@", error);
    }
    
    self.window.rootViewController = navigationController;
    self.window.backgroundColor = UIColor.whiteColor;
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - AppDelegate

- (MTFTheme *)createLightTheme {
    NSError *error;
    MTFTheme *theme = [MTFTheme
        themeFromFilesNamed:@[
            ColorsThemeName,
            LightMappingsThemeName,
            TypographyThemeName,
            ControlsThemeName,
            NavigationThemeName,
            ContentThemeName,
            StyleGuideThemeName,
        ]
        error:&error];

    NSAssert(theme != nil, @"Error loading light theme: %@", error);

    return theme;
}

- (MTFTheme *)createDarkTheme {
    NSError *error;
    MTFTheme *theme = [MTFTheme
        themeFromFilesNamed:@[
            ColorsThemeName,
            DarkMappingsThemeName,
            TypographyThemeName,
            ControlsThemeName,
            NavigationThemeName,
            ContentThemeName,
            StyleGuideThemeName,
        ]
        error:&error];

    NSAssert(theme != nil, @"Error loading dark theme: %@", error);

    return theme;
}

#if !defined(SCREEN_BRIGHTNESS_THEME_APPLIER)

- (void)toggleTheme {
    // Changing an MTFDynamicThemeApplier's theme property reapplies it to all
    // objects that had a theme class previously applied with it
    self.themeApplier.theme = (self.isDisplayingDarkTheme ? self.lightTheme : self.darkTheme);
    
    self.isDisplayingDarkTheme = !self.isDisplayingDarkTheme;
}

#endif

@end
