//
//  StyleGuideViewController.h
//  DynamicThemesExample
//
//  Created by Eric Horacek on 1/1/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import UIKit;
@import Motif;

NS_ASSUME_NONNULL_BEGIN

@interface StyleGuideViewController : UIViewController

- (instancetype)initWithThemeApplier:(id<MTFThemeApplier>)themeApplier;

@end

NS_ASSUME_NONNULL_END
