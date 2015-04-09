//
//  ButtonsViewController.m
//  ButtonsExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <Motif/Motif.h>
#import "ButtonsViewController.h"
#import "ButtonsView.h"
#import "ThemeSymbols.h"

@interface ButtonsViewController ()

@property (nonatomic) ButtonsView *view;

@end

@implementation ButtonsViewController

#pragma mark - UIViewController

@dynamic view;

- (void)loadView {
    self.view = [ButtonsView new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.theme
        applyClassWithName:ThemeClassNames.ButtonsView
        toObject:self.view];
}

#pragma mark - ButtonsViewController

- (instancetype)initWithTheme:(MTFTheme *)theme {
    NSParameterAssert(theme);
    
    self = [super init];
    if (self) {
        _theme = theme;
    }
    return self;
}

@end
