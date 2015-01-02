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

@interface ButtonsViewController ()

@property (nonatomic) AUTThemeApplier *themeApplier;

@end

@implementation ButtonsViewController

#pragma mark - UIViewController

- (void)loadView
{
    self.view = [[ButtonsView alloc] initWithThemeApplier:self.themeApplier];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - ViewController

- (instancetype)initWithThemeApplier:(AUTThemeApplier *)applier
{
    self = [super init];
    if (self) {
        self.themeApplier = applier;
    }
    return self;
}

@end
