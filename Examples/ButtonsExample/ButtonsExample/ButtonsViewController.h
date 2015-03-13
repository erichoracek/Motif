//
//  ViewController.h
//  ButtonsExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AUTTheming/AUTTheme.h>

@interface ButtonsViewController : UIViewController

- (instancetype)initWithTheme:(AUTTheme *)theme;

@property (nonatomic, readonly) AUTTheme *theme;

@end
