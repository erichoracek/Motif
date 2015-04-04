//
//  AUTScreenBrightnessThemeApplier.m
//  AUTTheming
//
//  Created by Eric Horacek on 4/4/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import "AUTScreenBrightnessThemeApplier.h"

@implementation AUTScreenBrightnessThemeApplier

#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - AUTDynamicThemeApplier

- (instancetype)initWithTheme:(AUTTheme *)theme {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    // Ensure that exception is thrown when just `initWithTheme` is called.
    return [self initWithScreen:nil lightTheme:nil darkTheme:nil];
#pragma clang diagnostic pop
    
}

- (void)setTheme:(AUTTheme *)theme {
    NSAssert(
        NO,
        @"You should not change the theme on a screen brightness theme applier"
            "manually.");
}

#pragma mark - AUTScreenBrightnessThemeApplier

static CGFloat const DefaultBrightnessThreshold = 0.5;

- (instancetype)initWithLightTheme:(AUTTheme *)lightTheme darkTheme:(AUTTheme *)darkTheme {
    return [self initWithScreen:[UIScreen mainScreen] lightTheme:lightTheme darkTheme:darkTheme];
}

- (instancetype)initWithScreen:(UIScreen *)screen lightTheme:(AUTTheme *)lightTheme darkTheme:(AUTTheme *)darkTheme {
    NSParameterAssert(screen);
    NSParameterAssert(lightTheme);
    NSParameterAssert(darkTheme);
    
    AUTTheme *theme = [self
        themeForScreen:screen
        withBrightnessThreshold:DefaultBrightnessThreshold
        lightTheme:lightTheme
        darkTheme:darkTheme];
    
    self = [super initWithTheme:theme];
    if (self) {
        _screen = screen;
        _lightTheme = lightTheme;
        _darkTheme = darkTheme;
        _brightnessThreshold = DefaultBrightnessThreshold;
        
        [[NSNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(screenBrightnessDidChange:)
            name:UIScreenBrightnessDidChangeNotification
            object:_screen];
    }
    return self;
}

- (AUTTheme *)themeForScreen:(UIScreen *)screen withBrightnessThreshold:(CGFloat)brightnessThreshold lightTheme:(AUTTheme *)lightTheme darkTheme:(AUTTheme *)darkTheme {
    NSParameterAssert(screen);
    NSParameterAssert(lightTheme);
    NSParameterAssert(darkTheme);
    
    if (screen.brightness > brightnessThreshold) {
        return lightTheme;
    } else {
        return darkTheme;
    }
}

- (void)setBrightnessThreshold:(CGFloat)brightnessThreshold {
    _brightnessThreshold = brightnessThreshold;
    [self updateThemeIfNecessary];
}

- (void)updateThemeIfNecessary {
    AUTTheme *theme = [self
        themeForScreen:self.screen
        withBrightnessThreshold:self.brightnessThreshold
        lightTheme:self.lightTheme
        darkTheme:self.darkTheme];
    
    if (super.theme == theme) {
        return;
    }
    
    super.theme = theme;
}

- (void)screenBrightnessDidChange:(NSNotification *)notification {
    [self updateThemeIfNecessary];
}

@end
