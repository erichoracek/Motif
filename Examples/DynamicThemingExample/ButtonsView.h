//
//  ButtonsView.h
//  ButtonsExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonsView : UIScrollView

@property (nonatomic, readonly) UIButton *saveButton;
@property (nonatomic, readonly) UIButton *deleteButton;

@property (nonatomic, readonly) UIButton *secondarySaveButton;
@property (nonatomic, readonly) UIButton *secondaryDeleteButton;

@property (nonatomic, readonly) UILabel *displayTextLabel;
@property (nonatomic, readonly) UILabel *headlineTextLabel;
@property (nonatomic, readonly) UILabel *titleTextLabel;
@property (nonatomic, readonly) UILabel *subheadTextLabel;
@property (nonatomic, readonly) UILabel *bodyTextLabel;
@property (nonatomic, readonly) UILabel *captionTextLabel;

@property (nonatomic, readonly) UISwitch *toggle;
@property (nonatomic, readonly) UISlider *slider;
@property (nonatomic, readonly) UISegmentedControl *segmentedControl;

@end
