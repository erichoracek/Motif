//
//  AUTTheming.h
//  AUTTheming
//
//  Created by Eric Horacek on 3/29/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for AUTTheming.
FOUNDATION_EXPORT double AUTThemingVersionNumber;

//! Project version string for AUTTheming.
FOUNDATION_EXPORT const unsigned char AUTThemingVersionString[];

#import "AUTBackwardsCompatableNullability.h"
#import "AUTTheme.h"
#import "AUTThemeClass.h"
#import "AUTThemeClassApplicable.h"
#import "AUTDynamicThemeApplier.h"
#import "AUTThemeParser.h"
#import "NSObject+ThemeClassAppliers.h"
#import "NSObject+ThemeClassName.h"

#import "AUTReverseTransformedValueClass.h"
#import "AUTObjCTypeValueTransformer.h"

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
    #import "AUTScreenBrightnessThemeApplier.h"
    #import "AUTColorFromStringTransformer.h"
    #import "AUTEdgeInsetsFromStringTransformer.h"
    #import "AUTPointFromStringTransformer.h"
    #import "AUTRectFromStringTransformer.h"
    #import "AUTSizeFromStringTransformer.h"
#endif
