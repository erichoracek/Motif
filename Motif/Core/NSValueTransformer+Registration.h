//
//  NSValueTransformer+Registration.h
//  Motif
//
//  Created by Eric Horacek on 5/14/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

typedef NSValue * _Nullable (^MTFObjCValueTransformationBlock)(id value, NSError **error);

typedef _Nullable id (^MTFValueTransformationBlock)(id value, NSError **error);

/// Provides shorthand for registering value transformer instances with the
/// Objective-C runtime.
@interface NSValueTransformer (Registration)

/// Creates and registers a value transformer class and instance for
/// transforming a class to an NSValue-wrapped ObjC type.
///
/// @param name The name of the value transformer instance, used to query for
/// this instance via valueTransformerForName:.
///
/// @param transformedValueObjCType The ObjC type that the value transformer is
/// responsible for transforming its values to, as wrapped within an NSValue.
/// Should be the value returned by the \@encode directive.
///
/// @param reverseTransformedValueClass The class that the value transformer is
/// expecting as its input to transformValue:
///
/// @param transformationBlock The block that is used as the implementation of
/// the transformValue: method.
///
/// @return Whether the value transformer was successfully registered.
+ (BOOL)mtf_registerValueTransformerWithName:(NSString *)name transformedValueObjCType:(const char *)transformedValueObjCType reverseTransformedValueClass:(Class)reverseTransformedValueClass transformationBlock:(MTFObjCValueTransformationBlock)transformationBlock;

/// Creates and registers a value transformer class and instance for transforming
/// a class to another class.
///
/// @param name The name of the value transformer instance, used to query for
///  this instance via valueTransformerForName:.
///
/// @param transformedValueClass The class that the value transformer will
/// produce an instance of when transformValue: is invoked.
///
/// @param reverseTransformedValueClass The class that the value transformer is
/// expecting as its input to transformValue:
///
/// @param transformationBlock The block that is used as the implementation of
/// the transformValue: method.
///
/// @return Whether the value transformer was successfully registered.
+ (BOOL)mtf_registerValueTransformerWithName:(NSString *)name transformedValueClass:(Class)transformedValueClass reverseTransformedValueClass:(Class)reverseTransformedValueClass transformationBlock:(MTFValueTransformationBlock)transformationBlock;

/// Provides a convenience method for returning a nil transformed value and
/// populating an error with a description of the failure from within a
/// transformation block.
+ (nullable id)mtf_populateTransformationError:(NSError **)error withDescription:(NSString *)description;

/// Invokes mtf_populateTransformationError:withDescription: with the provided
/// formatted string.
+ (nullable id)mtf_populateTransformationError:(NSError **)error withDescriptionFormat:(NSString *)descriptionFormat, ... NS_FORMAT_FUNCTION(2,3);

@end

NS_ASSUME_NONNULL_END
