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

@property (readonly, nonatomic) id<MTFThemeApplier> themeApplier;

@end

@implementation ButtonsViewController

#pragma mark - Lifecycle

- (instancetype)initWithThemeApplier:(id<MTFThemeApplier>)themeApplier {
    NSParameterAssert(themeApplier != nil);
    
    self = [super init];

    _themeApplier = themeApplier;

    return self;
}

#pragma mark - UIViewController

- (void)loadView {
    self.view = [[ButtonsView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSError *error;
    if (![self.themeApplier applyClassWithName:ThemeClassNames.ButtonsView to:self.view error:&error]) {
        NSLog(@"%@", error);
    }
}

@end

NS_ASSUME_NONNULL_END
