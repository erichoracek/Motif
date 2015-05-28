//
//  MTFYAMLSerialization.h
//  Motif
//
//  Created by Eric Horacek on 5/25/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import Foundation;
#import <Motif/MTFBackwardsCompatableNullability.h>

MTF_NS_ASSUME_NONNULL_BEGIN

/// Converts YAML to Foundation objects.
@interface MTFYAMLSerialization : NSObject

/// Returns a Foundation object from given YAML data.
///
/// @param data A data object containing YAML data.
///
/// @param error If an error occurs, upon return contains an NSError object that
///              describes the problem.
///
/// @return A Foundation object from the YAML data in data, or nil if an error
///         occurs.
+ (mtf_nullable id)YAMLObjectWithData:(NSData *)data error:(NSError **)error;

@end

/// The domain for YAML serialization errors.
extern NSString * const MTFYAMLSerializationErrorDomain;

/// An NSNumber containing the byte offset within the data that a serialization
/// error occurred at.
extern NSString * const MTFYAMLSerializationOffsetErrorKey;

/// An NSNumber containing the line number on which the error occurred.
extern NSString * const MTFYAMLSerializationLineErrorKey;

/// An NSNumber containing the column number on which the error occurred.
extern NSString * const MTFYAMLSerializationColumnErrorKey;

/// An NSNumber containing the character index on which the error occurred.
extern NSString * const MTFYAMLSerializationIndexErrorKey;

/// An NSString describing the context that a serialization error occurred
/// within.
extern NSString * const MTFYAMLSerializationContextDescriptionErrorKey;

/// An NSString containing the contents of the line on which the error occurred.
extern NSString * const MTFYAMLSerializationLineContentsErrorKey;

MTF_NS_ASSUME_NONNULL_END
