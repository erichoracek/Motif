//
//  NSObject+ThemeAppliers.h
//  Motif
//
//  Created by Eric Horacek on 12/25/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import Foundation;

@class MTFThemeClass;
@protocol MTFThemeClassApplicable;

NS_ASSUME_NONNULL_BEGIN

/**
 A block that is invoked to apply the property value to an instance of the class
 that this applier is registered with.
 
 @param propertyValue The property value that should be applied to the specified
                      object.
 @param objectToTheme The object that should have the specified property value
                      applied.
 */
typedef BOOL (^MTFThemePropertyApplierBlock)(id propertyValue, id objectToTheme, NSError  **error);

/// A block that is invoked to apply a property value to an instance of the
/// class that this applier is registered with.
///
/// @param propertyValue The property value that should be applied to the
///                      specified object, wrapping the desired Objective-C
///                      value. You should use -[NSValue getValue:] or one of
///                      the convenience getters, e.g. -[NSValue CGPointValue].
///
/// @param objectToTheme The object that should have the specified property
///                      value applied.
typedef BOOL (^MTFThemePropertyObjCValueApplierBlock)(NSValue *propertyValue, id objectToTheme, NSError **error);

/**
 A block that is invoked to apply the property values to an instance of the
 class that this applier is registered with.
 
 @param valuesForProperties A dictionary of theme class properties keyed by
                            their names, with values of their theme property
                            values.
 @param objectToTheme       The object that should have the specified property
                            values applied.
 */
typedef BOOL (^MTFThemePropertiesApplierBlock)(NSDictionary<NSString *, id> *valuesForProperties, id objectToTheme, NSError **error);

@interface NSObject (ThemeAppliers)

/**
 Registers a block that is invoked to apply a property value to an instance of
 the receiving class.
 
 @param property     The name of the theme class property that this applier
                     block is responsible for applying, e.g. "contentInsets".
 @param applierBlock The block that is invoked when the specified property is
                     applied to an instance of the receiving class.
 
 @return An opaque theme class applier. You may discard this reference.
 */
+ (id<MTFThemeClassApplicable>)mtf_registerThemeProperty:(NSString *)property applierBlock:(MTFThemePropertyApplierBlock)applierBlock;

/**
 Registers a block that is invoked to apply a property value to an instance of
 the receiving class.
 
 Before invoking the block, uses the specified class to ensure that the property
 value is a kind of the correct class.
 
 @param property     The name of the theme class property that this applier
                     block is responsible for applying, e.g. "contentInsets".
 @param valueClass   The class that the property value is required to be a kind
                     of.
 @param applierBlock The block that is invoked when the specified property is
                     applied to an instance of the receiving class.
 
 @return An opaque theme class applier. You may discard this reference.
 */
+ (id<MTFThemeClassApplicable>)mtf_registerThemeProperty:(NSString *)property requiringValueOfClass:(Class)valueClass applierBlock:(MTFThemePropertyApplierBlock)applierBlock;

/// Registers a block that is invoked to apply a property value to an instance
/// of the receiving class.
///
/// Before invoking the block, uses the specified value transformer to transform
/// the property value.
///
/// @param property      The name of the theme class property that this applier
///                      block is responsible for applying, e.g. contentInsets.
///
/// @param valueObjCType A C string containing the Objective-C type that the
///                      property value is required to be a kind of. Should be
///                      invoked with the value of the @encode directive, e.g.
///                      `@encode(CGPoint)`.
///
/// @param applierBlock The block that is invoked when the specified property is
///                     applied to an instance of the receiving class.
///
/// @return An opaque theme class applier. You may discard this reference.
+ (id<MTFThemeClassApplicable>)mtf_registerThemeProperty:(NSString *)property requiringValueOfObjCType:(const char *)valueObjCType applierBlock:(MTFThemePropertyObjCValueApplierBlock)applierBlock;

/**
 Registers a block that is invoked to apply the property values to an instance
 of the receiving class.
 
 The block is only invoked when all of the specified properties are present.
 
 @param properties   The names of the theme class properties that this applier
                     block is responsible for applying.

 @param applierBlock The block that is invoked when the specified properties are
                     applied to an instance of the receiving class.

 @return An opaque theme class applier. You may discard this reference.
 */
+ (id<MTFThemeClassApplicable>)mtf_registerThemeProperties:(NSArray<NSString *> *)properties applierBlock:(MTFThemePropertiesApplierBlock)applierBlock;

/**
 Registers a block that is invoked to apply the property values to an instance
 of the receiving class.
 
 The block is only invoked when all of the specified properties are present.
 
 Before invoking the block, uses the specified value transformer to transform
 the property values, or uses the specified required class to ensure that the
 property values are a kind of the correct class.
 
 @param properties The names of the theme class properties that this applier
                   block is responsible for applying.

 @param valueTypes The classes or Objective-C types that the applied property
                   values should be type of. Should be in the same order as
                   the properties array, and consist of either Classes or
                   NSString-wrapped Objective-C types, e.g. `NSString.class`
                   or `@(@encode(UIEdgeInsets))`.

 @param applierBlock The block that is invoked when the specified properties are
                     applied to an instance of the receiving class.
 
 @return An opaque theme class applier. You may discard this reference.
 */
+ (id<MTFThemeClassApplicable>)mtf_registerThemeProperties:(NSArray<NSString *> *)properties requiringValuesOfType:(NSArray *)valueTypes applierBlock:(MTFThemePropertiesApplierBlock)applierBlock;

/// Registers a set of keywords that are each mapped to a specific value, such
/// that when the specified property is applied with one of the keywords as its
/// value, its corresponding value is set with KVC for the specified key path on
/// the object that it was applied to.
///
/// If the applied property value doesn't match the any of the keywords, the
/// applier block returns NO and populates its pass-by-reference error.
///
/// Examples
///
///      // Applies a textAlignment theme property to UILabels
///      [UILabel
///          mtf_registerThemeProperty:@"textAlignment"
///          forKeyPath:NSStringFromSelector(@selector(textAlignment))
///          withValuesByKeyword:@{
///              @"left": @(NSTextAlignmentLeft),
///              @"center": @(NSTextAlignmentCenter),
///              @"right": @(NSTextAlignmentRight),
///              @"justified": @(NSTextAlignmentJustified),
///              @"natural": @(NSTextAlignmentNatural)
///          }];
///
/// @param property The name of the theme class property that this applier is
/// responsible for applying.
///
/// @param keyPath The key path that the values in the valuesByKeyword dictionary
/// are set to.
///
/// @param valuesByKeyword A dictionary that specifies a mapping from keywords in
/// theme class properties to values that are set for the specified key path.
///
/// @return An opaque theme class applier. You may discard this reference.
+ (id<MTFThemeClassApplicable>)mtf_registerThemeProperty:(NSString *)property forKeyPath:(NSString *)keyPath withValuesByKeyword:(NSDictionary<NSString *, id> *)valuesByKeyword;

/// Registers the specified theme class applier with the receiving class.
///
/// @param applier The applier to register.
+ (void)mtf_registerThemeClassApplier:(id<MTFThemeClassApplicable>)applier;

/// Provides a convenience method for indicating that the application of a theme
/// class was unsuccessful by returning NO and populating an error with a
/// description of the failure from within an applier block.
+ (BOOL)mtf_populateApplierError:(NSError **)error withDescription:(NSString *)description;

/// Invokes mtf_populateApplierError:withDescription: with the provided
/// formatted string.
+ (BOOL)mtf_populateApplierError:(NSError **)error withDescriptionFormat:(NSString *)descriptionFormat, ... NS_FORMAT_FUNCTION(2,3);

@end

NS_ASSUME_NONNULL_END
