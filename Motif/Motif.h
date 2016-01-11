//
//  Motif.h
//  Motif
//
//  Created by Eric Horacek on 3/29/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import Foundation;

//! Project version number for Motif.
FOUNDATION_EXPORT double MotifVersionNumber;

//! Project version string for Motif.
FOUNDATION_EXPORT const unsigned char MotifVersionString[];

#import <Motif/MTFThemeApplier.h>
#import <Motif/MTFDynamicThemeApplier.h>
#import <Motif/MTFLiveReloadThemeApplier.h>
#import <Motif/MTFTheme.h>
#import <Motif/MTFThemeClass.h>
#import <Motif/MTFErrors.h>
#import <Motif/MTFValueTransformerErrorHandling.h>
#import <Motif/MTFThemeClassApplicable.h>
#import <Motif/NSObject+ThemeClass.h>
#import <Motif/NSObject+ThemeClassAppliers.h>
#import <Motif/NSValueTransformer+Registration.h>
#import <Motif/NSValueTransformer+TypeFiltering.h>

#if TARGET_OS_IPHONE
    #import <Motif/MTFScreenBrightnessThemeApplier.h>
#endif
