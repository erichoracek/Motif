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

#import <Motif/MTFBackwardsCompatableNullability.h>
#import <Motif/MTFTheme.h>
#import <Motif/MTFThemeClass.h>
#import <Motif/MTFThemeClassApplicable.h>
#import <Motif/MTFDynamicThemeApplier.h>
#import <Motif/MTFThemeParser.h>
#import <Motif/NSObject+ThemeClassAppliers.h>
#import <Motif/NSObject+ThemeClassName.h>
#import <Motif/MTFReverseTransformedValueClass.h>
#import <Motif/MTFObjCTypeValueTransformer.h>

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
    #import <Motif/MTFScreenBrightnessThemeApplier.h>
    #import <Motif/MTFColorFromStringTransformer.h>
    #import <Motif/MTFEdgeInsetsFromStringTransformer.h>
    #import <Motif/MTFPointFromStringTransformer.h>
    #import <Motif/MTFRectFromStringTransformer.h>
    #import <Motif/MTFSizeFromStringTransformer.h>
#endif
