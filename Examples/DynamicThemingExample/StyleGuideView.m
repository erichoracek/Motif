//
//  StyleGuideView.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import "StyleGuideView.h"

NS_ASSUME_NONNULL_BEGIN

@implementation StyleGuideView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    self.alwaysBounceVertical = YES;
    
    _button = [UIButton buttonWithType:UIButtonTypeSystem];;
    _warningButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _secondaryButton = [UIButton buttonWithType:UIButtonTypeSystem];;
    _warningSecondaryButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    _displayTextLabel = [UILabel new];
    _headlineTextLabel = [UILabel new];
    _titleTextLabel = [UILabel new];
    _subheadTextLabel = [UILabel new];
    _bodyTextLabel = [UILabel new];
    _captionTextLabel = [UILabel new];
    
    _toggle = [UISwitch new];
    _slider = [UISlider new];
    NSArray<NSString *> *items = @[ @"One", @"Two", @"Three" ];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    
    self.bodyTextLabel.numberOfLines = 0;
    
    [self.button setTitle:@"Button" forState:UIControlStateNormal];
    [self.warningButton setTitle:@"Warning Button" forState:UIControlStateNormal];
    [self.secondaryButton setTitle:@"Button" forState:UIControlStateNormal];
    [self.warningSecondaryButton setTitle:@"Warning Button" forState:UIControlStateNormal];
    
    self.displayTextLabel.text = @"Display";
    self.headlineTextLabel.text = @"Headline";
    self.titleTextLabel.text = @"Title";
    self.subheadTextLabel.text = @"Subhead";
    self.bodyTextLabel.text = @"Body Donec ullamcorper nulla non metus "
        "auctor fringilla. Cum sociis natoque penatibus et magnis dis "
        "parturient montes, nascetur ridiculus mus.";
    self.captionTextLabel.text = @"Caption";
    
    self.toggle.on = YES;
    self.slider.value = 0.5f;
    self.segmentedControl.selectedSegmentIndex = 0;

    UIStackView *contentStackView = [self createContentStackView];
    [self addSubview:contentStackView];

    contentStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentStackView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [contentStackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [contentStackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [contentStackView.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;

    return self;
}

#pragma mark - StyleGuideView

static CGFloat const SectionPadding = 40;
static CGFloat const ElementPadding = 10;

- (UIStackView *)createButtonsStackView {
    NSArray<UIView *> *subviews = @[ self.button, self.warningButton ];
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:subviews];
    stackView.spacing = ElementPadding;
    stackView.distribution = UIStackViewDistributionFillEqually;
    return stackView;
}

- (UIStackView *)createSecondaryButtonsStackView {
    NSArray<UIView *> *subviews = @[ self.secondaryButton, self.warningSecondaryButton ];
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:subviews];
    stackView.spacing = ElementPadding;
    stackView.distribution = UIStackViewDistributionFillEqually;
    return stackView;
}

- (UIStackView *)createButtonsContainerStackView {
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        [self createButtonsStackView],
        [self createSecondaryButtonsStackView],
    ]];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = ElementPadding;
    return stackView;
}

- (UIStackView *)createTextLabelsStackView {
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.displayTextLabel,
        self.headlineTextLabel,
        self.titleTextLabel,
        self.subheadTextLabel,
        self.bodyTextLabel,
        self.captionTextLabel,
    ]];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = ElementPadding;
    return stackView;
}

- (UIStackView *)createControlsStackView {
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.toggle,
        self.slider,
    ]];
    stackView.spacing = ElementPadding;
    return stackView;
}

- (UIStackView *)createContentStackView {
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        [self createButtonsContainerStackView],
        [self createTextLabelsStackView],
        [self createControlsStackView],
        self.segmentedControl,
    ]];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = SectionPadding;
    stackView.layoutMarginsRelativeArrangement = YES;
    stackView.layoutMargins = (UIEdgeInsets){
        .top = SectionPadding,
        .left = ElementPadding,
        .bottom = SectionPadding,
        .right = ElementPadding,
    };
    return stackView;
}

#pragma mark - UIView

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

@end

NS_ASSUME_NONNULL_END
