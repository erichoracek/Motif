//
//  MTFThemeClassPropertiesApplier.h
//  Motif
//
//  Created by Eric Horacek on 6/7/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Motif/MTFThemeClassApplicable.h>

NS_ASSUME_NONNULL_BEGIN

/// An applier that is responsible for applying a set of theme class properties
/// to an object
@interface MTFThemeClassPropertiesApplier : NSObject <MTFThemeClassApplicable>

- (instancetype)init NS_UNAVAILABLE;

/**
 Initializes a theme class properties applier.
 
 @param properties   The names of the properties that this applier is 
                     responsible for applying.

 @param applierBlock The block that is invoked when all of the specified
                     properties are contained within a theme class that is being
                     applied to the object that this applier is registered with.
 
 @return An initialized theme class properties applier.
 */
- (instancetype)initWithProperties:(NSArray<NSString *> *)properties applierBlock:(MTFThemePropertiesApplierBlock)applierBlock NS_DESIGNATED_INITIALIZER;

/**
 The block that is invoked to apply the property values to an instance of the
 class that this applier is registered with.
 */
@property (nonatomic, copy, readonly) MTFThemePropertiesApplierBlock applierBlock;

@end

/// An applier that is responsible for applying a set of theme class properties
/// of specific types to an object.
@interface MTFThemeClassTypedValuesPropertiesApplier : MTFThemeClassPropertiesApplier

- (instancetype)initWithProperties:(NSArray<NSString *> *)properties applierBlock:(MTFThemePropertiesApplierBlock)applierBlock NS_UNAVAILABLE;

/**
 Initializes a theme class properties applier.

 @param properties   The names of the properties that this applier is
                     responsible for applying.

 @param valueTypes   The classes or Objective-C types that the applied property
                     values should be type of. Should be in the same order as
                     the properties array, and consist of either Classes or
                     NSString- wrapped Objective-C types, e.g. `NSString.class`
                     or `@(\@encode(UIEdgeInsets))`.

 @param applierBlock The block that is invoked when all of the specified
                     properties are contained within a theme class that is being
                     applied to the object that this applier is registered with.

 @return An initialized theme class properties applier.
 */
- (instancetype)initWithProperties:(NSArray<NSString *> *)properties valueTypes:(NSArray *)valueTypes applierBlock:(MTFThemePropertiesApplierBlock)applierBlock NS_DESIGNATED_INITIALIZER;

/// An array of either the classes or ObjC types that this property applier
/// is expecting, in the order of its properties array.
@property (readonly, nonatomic, copy) NSArray *valueTypes;

@end

NS_ASSUME_NONNULL_END
