//
//  ViewController.h
//  ButtonsExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AUTThemeApplier;

@interface ButtonsViewController : UIViewController

- (instancetype)initWithThemeApplier:(AUTThemeApplier *)applier;

@property (nonatomic, readonly) AUTThemeApplier *themeApplier;

@end
