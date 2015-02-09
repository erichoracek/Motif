//
//  ButtonsViewController.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 1/1/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import <AUTTheming/AUTTheming.h>
#import "ButtonsViewController.h"
#import "ButtonsView.h"
#import "ThemeSymbols.h"

@interface ButtonsViewController ()

@property (nonatomic) ButtonsView *view;

@end

@implementation ButtonsViewController

#pragma mark - UIViewController

- (void)loadView
{
    self.view = [ButtonsView new];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(toggleTheme)];
    self.navigationItem.title = @"Dynamic Theming";
    
    [self.themeApplier applyClassWithName:ContentThemeClassNames.ContentBackground toObject:self.view];
    
    [self.themeApplier applyClassWithName:ButtonsThemeClassNames.DestructiveButton toObject:self.view.deleteButton];
    [self.view.deleteButton setTitle:NSLocalizedString(@"Delete", nil) forState:UIControlStateNormal];
    
    [self.themeApplier applyClassWithName:ButtonsThemeClassNames.PrimaryButton toObject:self.view.saveButton];
    [self.view.saveButton setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
}

#pragma mark - ButtonsViewController

- (instancetype)initWithThemeApplier:(AUTThemeApplier *)applier lightTheme:(AUTTheme *)lightTheme darkTheme:(AUTTheme *)darkTheme
{
    self = [super init];
    if (self) {
        _themeApplier = applier;
        _lightTheme = lightTheme;
        _darkTheme = darkTheme;
    }
    return self;
}

- (void)toggleTheme
{
    BOOL isCurrentlyDisplayingLightTheme = (self.themeApplier.theme == self.lightTheme);
    // Changing an AUTThemeApplier's theme property reapplies it to all previously applied themes
    self.themeApplier.theme = (isCurrentlyDisplayingLightTheme ? self.darkTheme : self.lightTheme);
}

@end
