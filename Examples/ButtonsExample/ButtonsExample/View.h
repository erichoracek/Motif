//
//  View.h
//  ButtonsExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface View : UIView

- (instancetype)initWithTheme:(AUTTheme *)theme;

@property (nonatomic, readonly) UIButton *saveButton;
@property (nonatomic, readonly) UIButton *deleteButton;

@end
