//
//  ViewController.h
//  ButtonsExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTFTheme;

@interface ButtonsViewController : UIViewController

- (instancetype)initWithTheme:(MTFTheme *)theme;

@property (nonatomic, readonly) MTFTheme *theme;

@end
