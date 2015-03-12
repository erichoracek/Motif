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

@dynamic view;

- (void)loadView
{
    self.view = [ButtonsView new];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(toggleTheme)];
    self.navigationItem.title = NSLocalizedString(@"Dynamic Theming", nil);
    
    [self.themeApplier applyClassWithName:ContentThemeClassNames.ContentBackground toObject:self.view];
    
    [self.themeApplier applyClassWithName:ButtonsThemeClassNames.DestructiveButton toObject:self.view.deleteButton];
    [self.themeApplier applyClassWithName:ButtonsThemeClassNames.CreativeButton toObject:self.view.saveButton];
    [self.themeApplier applyClassWithName:ButtonsThemeClassNames.DestructiveSecondaryButton toObject:self.view.secondaryDeleteButton];
    [self.themeApplier applyClassWithName:ButtonsThemeClassNames.CreativeSecondaryButton toObject:self.view.secondarySaveButton];
    
    [self.view.deleteButton setTitle:NSLocalizedString(@"Delete Button", nil) forState:UIControlStateNormal];
    [self.view.saveButton setTitle:NSLocalizedString(@"Save Button", nil) forState:UIControlStateNormal];
    [self.view.secondaryDeleteButton setTitle:NSLocalizedString(@"Delete Button", nil) forState:UIControlStateNormal];
    [self.view.secondarySaveButton setTitle:NSLocalizedString(@"Save Button", nil) forState:UIControlStateNormal];
    
    [self.themeApplier applyClassWithName:TypographyThemeClassNames.DisplayText toObject:self.view.displayTextLabel];
    [self.themeApplier applyClassWithName:TypographyThemeClassNames.HeadlineText toObject:self.view.headlineTextLabel];
    [self.themeApplier applyClassWithName:TypographyThemeClassNames.TitleText toObject:self.view.titleTextLabel];
    [self.themeApplier applyClassWithName:TypographyThemeClassNames.SubheadText toObject:self.view.subheadTextLabel];
    [self.themeApplier applyClassWithName:TypographyThemeClassNames.BodyText toObject:self.view.bodyTextLabel];
    [self.themeApplier applyClassWithName:TypographyThemeClassNames.CaptionText toObject:self.view.captionTextLabel];
    
    self.view.displayTextLabel.text = @"Display";
    self.view.headlineTextLabel.text = @"Headline";
    self.view.titleTextLabel.text = @"Title";
    self.view.subheadTextLabel.text = @"Subhead";
    self.view.bodyTextLabel.text = @"Body Donec ullamcorper nulla non metus auctor fringilla. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.";
    self.view.captionTextLabel.text = @"Caption";
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
