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

@interface ButtonsViewController ()

@property (nonatomic) AUTThemeApplier *themeApplier;
@property (nonatomic) AUTTheme *lightTheme;
@property (nonatomic) AUTTheme *darkTheme;

@end

@implementation ButtonsViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(toggleTheme)];
    self.navigationItem.title = @"Dynamic Theming";
}

- (void)loadView
{
    self.view = [[ButtonsView alloc] initWithThemeApplier:self.themeApplier];
}

#pragma mark - ButtonsViewController

- (instancetype)initWithThemeApplier:(AUTThemeApplier *)applier lightTheme:(AUTTheme *)lightTheme darkTheme:(AUTTheme *)darkTheme
{
    self = [super init];
    if (self) {
        self.themeApplier = applier;
        self.lightTheme = lightTheme;
        self.darkTheme = darkTheme;
    }
    return self;
}

- (void)toggleTheme
{
    BOOL lightTheme = (self.themeApplier.theme == self.lightTheme);
    self.themeApplier.theme = (lightTheme ? self.darkTheme : self.lightTheme);
}

@end
