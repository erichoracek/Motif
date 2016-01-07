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

@interface StyleGuideViewController ()

@property (readonly, nonatomic) id<MTFThemeApplier> themeApplier;

@end

@implementation StyleGuideViewController

#pragma mark - Lifecycle

- (instancetype)initWithThemeApplier:(id<MTFThemeApplier>)themeApplier {
    NSParameterAssert(themeApplier != nil);
    
    self = [super init];

    _themeApplier = themeApplier;

    return self;
}

#pragma mark - UIViewController

- (void)loadView {
    self.view = [[StyleGuideView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];

   NSError *error;
    if (![self.themeApplier applyClassWithName:StyleGuideThemeClassNames.StyleGuide to:self.view error:&error]) {
        NSLog(@"%@", error);
    }
}

@end

NS_ASSUME_NONNULL_END
