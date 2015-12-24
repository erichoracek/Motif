//
//  ButtonsView.m
//  ButtonsExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import "ButtonsView.h"

NS_ASSUME_NONNULL_BEGIN

@implementation ButtonsView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    _saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];

    [self.deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];

    NSArray<UIView *> *subviews = @[ self.saveButton, self.deleteButton ];
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:subviews];
    stackView.layoutMargins = (UIEdgeInsets){ .left = 10, .right = 10 };
    stackView.layoutMarginsRelativeArrangement = YES;
    stackView.spacing = 10;
    stackView.distribution = UIStackViewDistributionFillEqually;
    [self addSubview:stackView];

    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [stackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [stackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [stackView.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;

    return self;
}

#pragma mark - UIView

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

@end

NS_ASSUME_NONNULL_END
