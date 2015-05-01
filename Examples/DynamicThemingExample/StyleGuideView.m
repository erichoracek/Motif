//
//  StyleGuideView.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "StyleGuideView.h"

@interface StyleGuideView ()

@property (nonatomic, readonly) NSArray *textLabels;

@end

@implementation StyleGuideView

#pragma mark - UIView

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

static CGFloat const SectionPadding = 40.0f;
static CGFloat const ElementPadding = 10.0f;
static CGFloat const SegmentedControlHeight = 32.0f;

- (void)updateConstraints {
    [self.button
        mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(SectionPadding);
            make.left.equalTo(@(ElementPadding));
            make.right.equalTo(self.mas_centerX).offset(-(ElementPadding / 2.0));
            make.width.equalTo(self.warningButton);
        }];
    
    [self.warningButton
        mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_centerX).offset(ElementPadding / 2.0);
            make.centerY.equalTo(self.button);
            make.width.equalTo(self.button);
        }];
    
    [self.secondaryButton
        mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.button.mas_bottom).offset(ElementPadding);
            make.left.equalTo(self.button);
            make.width.equalTo(self.button);
        }];
    
    [self.warningSecondaryButton
        mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.warningButton);
            make.centerY.equalTo(self.secondaryButton);
            make.width.equalTo(self.secondaryButton);
        }];
    
    __block UIView *topView = self.secondaryButton;
    [self.textLabels enumerateObjectsUsingBlock:^(UILabel *textLabel, NSUInteger textLabelIndex, BOOL *stop) {
        [textLabel
            mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(ElementPadding);
                make.right.equalTo(self).offset(-ElementPadding);
                make.top.equalTo(topView.mas_bottom).offset((textLabelIndex == 0) ? SectionPadding : ElementPadding);
                make.width.equalTo(self).offset(-ElementPadding * 2.0);
            }];
        
        topView = textLabel;
    }];
    
    [self.toggle
        mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ElementPadding);
            make.top.equalTo([self.textLabels.lastObject mas_bottom]).offset(SectionPadding);
        }];
    
    [self.slider
        mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.toggle.mas_right).offset(ElementPadding);
            make.right.equalTo(self).offset(-ElementPadding);
            make.centerY.equalTo(self.toggle);
        }];
    
    [self.segmentedControl
        mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.toggle.mas_bottom).offset(SectionPadding);
            make.left.equalTo(self).offset(ElementPadding);
            make.right.equalTo(self).offset(-ElementPadding);
            make.height.equalTo(@(SegmentedControlHeight));
            make.bottom.equalTo(self.mas_bottom).offset(-SectionPadding);
        }];
    
    [super updateConstraints];
}

#pragma mark - ButtonsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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
        _segmentedControl = [[UISegmentedControl alloc]
            initWithItems:@[
                @"One",
                @"Two",
                @"Three"
            ]];
        
        [self addSubview:self.button];
        [self addSubview:self.warningButton];
        [self addSubview:self.secondaryButton];
        [self addSubview:self.warningSecondaryButton];
        
        [self addSubview:self.displayTextLabel];
        [self addSubview:self.headlineTextLabel];
        [self addSubview:self.titleTextLabel];
        [self addSubview:self.subheadTextLabel];
        [self addSubview:self.bodyTextLabel];
        [self addSubview:self.captionTextLabel];
        
        [self addSubview:self.toggle];
        [self addSubview:self.slider];
        [self addSubview:self.segmentedControl];
        
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
    }
    return self;
}

- (NSArray *)textLabels {
    return @[
        self.displayTextLabel,
        self.headlineTextLabel,
        self.titleTextLabel,
        self.subheadTextLabel,
        self.bodyTextLabel,
        self.captionTextLabel
    ];
}

@end
