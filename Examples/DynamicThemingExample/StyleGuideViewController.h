//
//  StyleGuideViewController.h
//  DynamicThemesExample
//
//  Created by Eric Horacek on 1/1/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTFDynamicThemeApplier;

NS_ASSUME_NONNULL_BEGIN

@interface StyleGuideViewController : UIViewController

- (instancetype)initWithThemeApplier:(MTFDynamicThemeApplier *)themeApplier;

@property (nonatomic, readonly) MTFDynamicThemeApplier *themeApplier;

@end

NS_ASSUME_NONNULL_END
