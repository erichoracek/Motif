//
//  MTFErrors.h
//  Motif
//
//  Created by Eric Horacek on 12/24/15.
//  Copyright © 2015 Eric Horacek. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/// The domain for errors originating within Motif.
extern NSString * const MTFErrorDomain;

/// Error codes in MTFErrorDomain.
typedef NS_ENUM(NSInteger, MTFErrorCodes) {
    /// A theme was unable to be parsed from a raw theme dictionary.
    MTFErrorFailedToParseTheme = 1,

    /// A theme was unable to be successfully applied to an object.
    MTFErrorFailedToApplyTheme,
};

/// Associated with the object that failed to have a theme class applied to it.
extern NSString * const MTFApplicantErrorKey;

/// Associated with an NSDictionary of theme class property values keyed by
/// NSString theme class property names that were unable to be applied to the
/// applicant.
extern NSString * const MTFUnappliedPropertiesErrorKey;

/// Associated with an NSArray of underlying NSErrors that occurred when
/// applying a theme class to an applicant that resulted in an overall failure
/// to apply a theme class.
extern NSString * const MTFUnderlyingErrorsErrorKey;

/// Associated with an NSString identifying the name of the theme class that was
/// unable to by applied to the applicant.
extern NSString * const MTFThemeClassNameErrorKey;

NS_ASSUME_NONNULL_END
