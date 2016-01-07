//
//  ButtonsViewController.h
//  ButtonsExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

@import UIKit;
@import Motif;

NS_ASSUME_NONNULL_BEGIN

@interface ButtonsViewController : UIViewController

- (instancetype)initWithThemeApplier:(id<MTFThemeApplier>)themeApplier;

@end

NS_ASSUME_NONNULL_END
