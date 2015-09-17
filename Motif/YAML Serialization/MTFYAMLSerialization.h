//
//  MTFYAMLSerialization.h
//  Motif
//
//  Created by Eric Horacek on 5/25/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/// Converts YAML to Foundation objects.
///
/// Implements the seq (NSArray), map (NSDictionary), and str (NSString) types
/// from the YAML 1.2 failsafe schema:
/// http://yaml.org/spec/1.2/spec.html#schema/failsafe/
///
/// Implements the int (NSNumber), float (NSNumber), and null (NSNull) types
/// from the YAML 1.2 JSON schema:
/// http://yaml.org/spec/1.2/spec.html#schema/JSON/
///
/// Does not support:
/// - Core YAML schema http://yaml.org/spec/1.2/spec.html#schema/core/
/// - Alias nodes http://yaml.org/spec/1.2/spec.html#id2786196
/// - Local tags http://yaml.org/spec/1.2/spec.html#id2764295
/// - Multiple documents http://yaml.org/spec/1.2/spec.html#id2800132
@interface MTFYAMLSerialization : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// Returns a Foundation object from given YAML data.
///
/// @param data A data object containing YAML data.
///
/// @param error If an error occurs, upon return contains an NSError object that
///              describes the problem.
///
/// @return A Foundation object from the YAML data in data, or nil if an error
///         occurs.
+ (nullable id)YAMLObjectWithData:(NSData *)data error:(NSError **)error;

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

NS_ASSUME_NONNULL_END
