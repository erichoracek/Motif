//
//  StyleGuideViewController.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 1/1/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Motif/Motif.h>
#import "StyleGuideViewController.h"
#import "StyleGuideView.h"
#import "ThemeSymbols.h"

@implementation StyleGuideViewController

#pragma mark - UIViewController

@dynamic view;

- (void)loadView {
    self.view = [StyleGuideView new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.themeApplier
        applyClassWithName:StyleGuideThemeClassNames.StyleGuide
        toObject:self.view];
}

#pragma mark - StyleGuideViewController

- (instancetype)initWithThemeApplier:(MTFDynamicThemeApplier *)themeApplier {
    NSParameterAssert(themeApplier);
    
    self = [super init];
    if (self) {
        _themeApplier = themeApplier;
    }
    return self;
}

@end
