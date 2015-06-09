//
//  Motif.h
//  Motif
//
//  Created by Eric Horacek on 3/29/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for Motif.
FOUNDATION_EXPORT double MotifVersionNumber;

//! Project version string for Motif.
FOUNDATION_EXPORT const unsigned char MotifVersionString[];

#import <Motif/MTFTheme.h>
#import <Motif/MTFThemeClass.h>
#import <Motif/MTFThemeClassApplicable.h>
#import <Motif/MTFDynamicThemeApplier.h>
#import <Motif/MTFLiveReloadThemeApplier.h>
#import <Motif/NSObject+ThemeClassAppliers.h>
#import <Motif/NSObject+ThemeClassName.h>
#import <Motif/NSValueTransformer+ValueTransformerRegistration.h>
#import <Motif/NSValueTransformer+TypeFiltering.h>

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
    #import <Motif/MTFScreenBrightnessThemeApplier.h>
#endif
