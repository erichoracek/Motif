//
//  View.m
//  ButtonsExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <AUTTheming/AUTTheming.h>
#import "View.h"
#import "ThemeSymbols.h"

@interface View ()

@property (nonatomic) UIButton *saveButton;
@property (nonatomic) UIButton *deleteButton;

@end

@implementation View

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

#pragma mark - View

- (instancetype)initWithTheme:(AUTTheme *)theme
{
    self = [super init];
    if (self) {
        self.aut_theme = theme;
        [self aut_applyThemeClassWithName:ThemeClassNames.Background];
        [self addSubview:self.saveButton];
        [self addSubview:self.deleteButton];
    }
    return self;
}

- (UIButton *)saveButton
{
    if (!_saveButton) {
        self.saveButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button aut_applyThemeClassWithName:ThemeClassNames.PrimaryButton fromTheme:self.aut_theme];
            [button setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
            button;
        });
    }
    return _saveButton;
}

- (UIButton *)deleteButton
{
    if (!_deleteButton) {
        self.deleteButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button aut_applyThemeClassWithName:ThemeClassNames.DestructiveButton fromTheme:self.aut_theme];
            [button setTitle:NSLocalizedString(@"Delete", nil) forState:UIControlStateNormal];
            button;
        });
    }
    return _deleteButton;
}

@end
