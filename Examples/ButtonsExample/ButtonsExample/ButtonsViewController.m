//
//  ViewController.m
//  ButtonsExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
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
    
    [self.themeApplier applyClassWithName:ThemeClassNames.ContentBackground toObject:self.view];
    [self.themeApplier applyClassWithName:ThemeClassNames.DestructiveButton toObject:self.view.deleteButton];
    [self.themeApplier applyClassWithName:ThemeClassNames.PrimaryButton toObject:self.view.saveButton];
    
    [self.view.deleteButton setTitle:NSLocalizedString(@"Delete", nil) forState:UIControlStateNormal];
    [self.view.saveButton setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - ButtonsViewController

- (instancetype)initWithThemeApplier:(AUTThemeApplier *)applier
{
    self = [super init];
    if (self) {
        _themeApplier = applier;
    }
    return self;
}

@end
