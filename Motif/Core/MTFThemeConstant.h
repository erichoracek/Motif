//
//  MTFThemeConstant.h
//  Motif
//
//  Created by Eric Horacek on 12/24/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/// A named constant value from an MTFTheme.
@interface MTFThemeConstant : NSObject

/// The constant name, as specified in the theme file.
@property (nonatomic, copy, readonly) NSString *name;

/// The value that the theme constant is referencing.
@property (nonatomic, readonly) id value;

/// Shortcut for accessing the transformed value of the receiver from a value
/// transformer.
///
/// The trasformed values are cached before being returned, and as such this is
/// the best way to access value-transformed values on the theme constant.
///
/// @param transformer The value transformer that should transform the value of
/// the receiver.
///
/// @return The transformed value, or nil if there was an error transforming the
/// value
- (nullable id)transformedValueFromTransformer:(NSValueTransformer *)transformer error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
