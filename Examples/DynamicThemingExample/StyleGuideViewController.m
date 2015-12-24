//
//  StyleGuideViewController.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 1/1/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Motif/Motif.h>

#import "StyleGuideView.h"
#import "ThemeSymbols.h"

#import "StyleGuideViewController.h"

NS_ASSUME_NONNULL_BEGIN

@implementation StyleGuideViewController

#pragma mark - Lifecycle

- (instancetype)initWithThemeApplier:(MTFDynamicThemeApplier *)themeApplier {
    NSParameterAssert(themeApplier);
    
    self = [super init];

    _themeApplier = themeApplier;

    return self;
}

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

@end

NS_ASSUME_NONNULL_END
