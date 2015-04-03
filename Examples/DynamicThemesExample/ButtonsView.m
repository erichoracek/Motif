//
//  ButtonsView.m
//  ButtonsExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "ButtonsView.h"

@interface ButtonsView ()

@property (nonatomic, readonly) NSArray *textLabels;

@end

@implementation ButtonsView

#pragma mark - UIView

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

static CGFloat const SectionPadding = 40.0;
static CGFloat const ElementPadding = 10.0;

- (void)updateConstraints {
    [super updateConstraints];
        
    [self.saveButton
        mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(SectionPadding);
            make.left.equalTo(@(ElementPadding));
            make.right.equalTo(self.mas_centerX).offset(-(ElementPadding / 2.0));
            make.width.equalTo(self.deleteButton);
        }];
    
    [self.deleteButton
        mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_centerX).offset(ElementPadding / 2.0);
            make.centerY.equalTo(self.saveButton);
            make.width.equalTo(self.saveButton);
        }];
    
    [self.secondarySaveButton
        mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.saveButton.mas_bottom).offset(ElementPadding);
            make.left.equalTo(self.saveButton);
            make.width.equalTo(self.saveButton);
        }];
    
    [self.secondaryDeleteButton
        mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.deleteButton);
            make.centerY.equalTo(self.secondarySaveButton);
            make.width.equalTo(self.secondarySaveButton);
        }];
    
    __block UIView *topView = self.secondarySaveButton;
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
            make.height.equalTo(@32.0);
            make.bottom.equalTo(self.mas_bottom).offset(-SectionPadding);
        }];
}

#pragma mark - ButtonsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.alwaysBounceVertical = YES;
        
        _saveButton = [UIButton buttonWithType:UIButtonTypeSystem];;
        _deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _secondarySaveButton = [UIButton buttonWithType:UIButtonTypeSystem];;
        _secondaryDeleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
        
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
        
        [self addSubview:self.saveButton];
        [self addSubview:self.deleteButton];
        [self addSubview:self.secondarySaveButton];
        [self addSubview:self.secondaryDeleteButton];
        
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
        
        [self.deleteButton setTitle:@"Delete Button" forState:UIControlStateNormal];
        [self.saveButton setTitle:@"Save Button" forState:UIControlStateNormal];
        [self.secondaryDeleteButton setTitle:@"Delete Button" forState:UIControlStateNormal];
        [self.secondarySaveButton setTitle:@"Save Button" forState:UIControlStateNormal];
        
        self.displayTextLabel.text = @"Display";
        self.headlineTextLabel.text = @"Headline";
        self.titleTextLabel.text = @"Title";
        self.subheadTextLabel.text = @"Subhead";
        self.bodyTextLabel.text = @"Body Donec ullamcorper nulla non metus auctor fringilla. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.";
        self.captionTextLabel.text = @"Caption";
        
        self.toggle.on = YES;
        self.slider.value = 0.5;
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
