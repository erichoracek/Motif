//
//  ButtonsViewController.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 1/1/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Motif/Motif.h>
#import "ButtonsViewController.h"
#import "ButtonsView.h"
#import "ThemeSymbols.h"

@implementation ButtonsViewController

#pragma mark - UIViewController

@dynamic view;

- (void)loadView {
    self.view = [ButtonsView new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.themeApplier
        applyClassWithName:SpecThemeClassNames.Spec
        toObject:self.view];
}

#pragma mark - ButtonsViewController

- (instancetype)initWithThemeApplier:(MTFDynamicThemeApplier *)themeApplier {
    NSParameterAssert(themeApplier);
    
    self = [super init];
    if (self) {
        _themeApplier = themeApplier;
    }
    return self;
}

@end
