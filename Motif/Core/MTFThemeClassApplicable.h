//
//  MTFThemeApplicable.h
//  Motif
//
//  Created by Eric Horacek on 12/26/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Motif/NSObject+ThemeClassAppliers.h>

@class MTFThemeClass;
@class MTFTheme;

NS_ASSUME_NONNULL_BEGIN

/// Objects that wish to apply an MTFThemeClass to an object should conform to
/// this protocol.
///
/// You likely won't ever have to use an object that conforms to
/// MTFThemeClassApplicable directly. The easiest way to register an applier is
/// by using the `+[NSObject mtf_registerTheme...applierBlock:]` methods, which
/// is a convenience method for creating and registering an applier that
/// conforms to this protocol.
@protocol MTFThemeClassApplicable <NSObject>

/// The properties that the theme applier is responsible for applying to an
/// object.
@property (nonatomic, copy, readonly) NSSet<NSString *> *properties;

/// Attempts to apply an MTFThemeClass to an object.
///
/// @param themeClass The theme class that should have its properties applied by
/// the receiver.
///
/// @param applicant The object that should have the class applied to it.
///
/// @return The properties that were successfully applied by the receiver, or
/// nil if an error occurred during application.
- (nullable NSSet <NSString *>*)applyClass:(MTFThemeClass *)themeClass to:(id)applicant error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
