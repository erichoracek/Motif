//
//  ButtonsViewController.m
//  ButtonsExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

@import Motif;

#import "ButtonsView.h"
#import "ThemeSymbols.h"

#import "ButtonsViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ButtonsViewController ()

@property (nonatomic) ButtonsView *view;

@end

@implementation ButtonsViewController

#pragma mark - Lifecycle

- (instancetype)initWithTheme:(MTFTheme *)theme {
    NSParameterAssert(theme != nil);
    
    self = [super init];

    _theme = theme;

    return self;
}

#pragma mark - UIViewController

@dynamic view;

- (void)loadView {
    self.view = [[ButtonsView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.theme applyClassWithName:ThemeClassNames.ButtonsView toObject:self.view];
}

@end

NS_ASSUME_NONNULL_END
