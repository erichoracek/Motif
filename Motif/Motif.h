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

#import "MTFBackwardsCompatableNullability.h"
#import "MTFTheme.h"
#import "MTFThemeClass.h"
#import "MTFThemeClassApplicable.h"
#import "MTFDynamicThemeApplier.h"
#import "MTFThemeParser.h"
#import "NSObject+ThemeClassAppliers.h"
#import "NSObject+ThemeClassName.h"
#import "MTFReverseTransformedValueClass.h"
#import "MTFObjCTypeValueTransformer.h"

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
    #import "MTFScreenBrightnessThemeApplier.h"
    #import "MTFColorFromStringTransformer.h"
    #import "MTFEdgeInsetsFromStringTransformer.h"
    #import "MTFPointFromStringTransformer.h"
    #import "MTFRectFromStringTransformer.h"
    #import "MTFSizeFromStringTransformer.h"
#endif
