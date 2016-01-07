//
//  MTFValueTransformerErrorHandling.h
//  Motif
//
//  Created by Eric Horacek on 12/24/15.
//  Copyright © 2015 Eric Horacek. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@protocol MTFValueTransformerErrorHandling <NSObject>

/// Transforms a value, returning any error that occurred during transformation.
///
/// @param value The value to transform.
///
/// @param error If not NULL, should be set to an error that occurred during
/// transformation if it was unsuccessful.
///
/// @return The transformed value, or nil if transformation was unsuccessful.
- (nullable id)transformedValue:(id)value error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
