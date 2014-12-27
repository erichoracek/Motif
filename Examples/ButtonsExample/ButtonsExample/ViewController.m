//
//  ViewController.m
//  ButtonsExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <AUTTheming/AUTTheming.h>
#import "ViewController.h"
#import "View.h"

@implementation ViewController

- (void)loadView
{
    self.view = [[View alloc] initWithTheme:self.aut_theme];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
