//
//  MTFScreenBrightnessThemeApplier.h
//  Motif
//
//  Created by Eric Horacek on 4/4/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Motif/MTFDynamicThemeApplier.h>
#import <Motif/MTFBackwardsCompatableNullability.h>

MTF_NS_ASSUME_NONNULL_BEGIN

/**
 A theme applier that changes its theme relative to the brightness of a
 specified UIScreen. When the brightness of the UIScreen is above the
 brightnessThreshold, the lightTheme is applied, and when the brightness of the
 UIScreen is below the brightnessThreshold, the darkTheme is applied.
 
 Do not call setTheme on this theme applier, as it will throw an execption at
 runtime.
 */
@interface MTFScreenBrightnessThemeApplier : MTFDynamicThemeApplier

/**
 Initializes a screen brightness theme applier with the main screen.
 
 @param lightTheme The theme applied when the brightness is above a threshold.
 @param darkTheme  The theme applied when the brighness is below a threshold.
 
 @return An new instance of the a brightness theme applier.
 */
- (instancetype)initWithLightTheme:(MTFTheme *)lightTheme darkTheme:(MTFTheme *)darkTheme;

/**
 Initializes a screen brightness theme applier.
 
 @param screen     The screen whose brightness is monitored by this applier.
 @param lightTheme The theme applied when the brightness is above a threshold.
 @param darkTheme  The theme applied when the brighness is below a threshold.
 
 @return An new instance of the a brightness theme applier.
 */
- (instancetype)initWithScreen:(UIScreen *)screen lightTheme:(MTFTheme *)lightTheme darkTheme:(MTFTheme *)darkTheme NS_DESIGNATED_INITIALIZER;

/**
 The threshold at which changes to the screen brightness will toggle the current
 theme on this theme applier.
 
 Default value of 0.5.
 */
@property (nonatomic) CGFloat brightnessThreshold;

/**
 The screen's whose brightness is monitored by this object.
 */
@property (nonatomic, readonly) UIScreen *screen;

/**
 The theme that is applied when the the screen's brightness is above the
 brightness threshold.
 */
@property (nonatomic, readonly) MTFTheme *lightTheme;

/**
 The theme that is applied when the screen's brightness is below the brightness
 threshold.
 */
@property (nonatomic, readonly) MTFTheme *darkTheme;

@end

MTF_NS_ASSUME_NONNULL_END
