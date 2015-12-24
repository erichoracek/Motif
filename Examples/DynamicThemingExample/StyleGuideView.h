//
//  StyleGuideView.h
//  DynamicThemesExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface StyleGuideView : UIScrollView

@property (nonatomic, readonly) UIButton *button;
@property (nonatomic, readonly) UIButton *warningButton;

@property (nonatomic, readonly) UIButton *secondaryButton;
@property (nonatomic, readonly) UIButton *warningSecondaryButton;

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

NS_ASSUME_NONNULL_END
