//
//  View.m
//  ButtonsExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "ButtonsView.h"

@interface ButtonsView ()

@property (nonatomic) UIButton *saveButton;
@property (nonatomic) UIButton *deleteButton;

@end

@implementation ButtonsView

#pragma mark - UIView

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

static const CGFloat ButtonWidth = 145.0;
static const CGFloat ButtonPadding = 10.0;

- (void)updateConstraints
{
    [super updateConstraints];
        
    [self.saveButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_centerX).offset(-(ButtonPadding / 2.0));
        make.width.equalTo(@(ButtonWidth));
    }];
    
    [self.deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).offset((ButtonPadding / 2.0));
        make.centerY.equalTo(self.saveButton);
        make.width.equalTo(@(ButtonWidth));
    }];
}

#pragma mark - ButtonsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.saveButton];
        [self addSubview:self.deleteButton];
    }
    return self;
}

- (UIButton *)saveButton
{
    if (!_saveButton) {
        self.saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    }
    return _saveButton;
}

- (UIButton *)deleteButton
{
    if (!_deleteButton) {
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    }
    return _deleteButton;
}

@end
