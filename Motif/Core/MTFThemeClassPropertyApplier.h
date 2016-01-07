//
//  MTFThemeClassPropertyApplier.h
//  Motif
//
//  Created by Eric Horacek on 6/7/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Motif/MTFThemeClassApplicable.h>

NS_ASSUME_NONNULL_BEGIN

/// An applier that is responsible for applying a specific theme class property
/// to an object.
@interface MTFThemeClassPropertyApplier : NSObject <MTFThemeClassApplicable>

- (instancetype)init NS_UNAVAILABLE;

/// Initializes a theme class property applier with a property name and an
/// applier block.
- (instancetype)initWithProperty:(NSString *)property applierBlock:(MTFThemePropertyApplierBlock)applierBlock NS_DESIGNATED_INITIALIZER;

/// The name of the property that this theme property applier is responsible for
/// applying with the applierBlock.
@property (nonatomic, copy, readonly) NSString *property;

/// The block that is invoked to apply the property value to an instance of the
/// class that this applier is registered with.
@property (nonatomic, copy, readonly) MTFThemePropertyApplierBlock applierBlock;

@end

/// An applier that is responsible for applying a specific theme class property
/// of a certain class to an object.
@interface MTFThemeClassValueClassPropertyApplier : MTFThemeClassPropertyApplier

- (instancetype)initWithProperty:(NSString *)property applierBlock:(MTFThemePropertyApplierBlock)applierBlock NS_UNAVAILABLE;

/// Initializes a theme class property applier with a property name, value
/// class, and an applier block.
- (instancetype)initWithProperty:(NSString *)property valueClass:(Class)valueClass applierBlock:(MTFThemePropertyApplierBlock)applierBlock NS_DESIGNATED_INITIALIZER;

/// The class that the value of the property must be a kind of.
///
/// If the property is not kind of this class, it is not applied.
@property (readonly, nonatomic) Class valueClass;

/// Returns the value for applying the specified property value of a certain
/// class from a theme class.
///
/// If a property of the specified name is found but is not of the correct type,
/// this method attempts to locate a value transformer that is able to transform
/// the value to the specified type. If one is found, it transforms the returned
/// value if one is found.
///
/// @param property The name of the property to query the theme class for.
///
/// @param valueClass The class that the return value should be kind of.
///
/// @param themeClass The theme class that contains the property to be queried
/// for.
///
/// @return
+ (nullable NSDictionary<NSString *, id> *)valueForApplyingProperty:(NSString *)property asClass:(Class)valueClass fromThemeClass:(MTFThemeClass *)themeClass error:(NSError **)error;

@end

/// An applier that is responsible for applying a specific theme class property
/// of a certain Objective-C type to an object.
@interface MTFThemeClassValueObjCTypePropertyApplier : MTFThemeClassPropertyApplier

- (instancetype)initWithProperty:(NSString *)property applierBlock:(MTFThemePropertyApplierBlock)applierBlock NS_UNAVAILABLE;

/// Initializes a theme class property applier with a property name, value
/// Objective-C type, and an applier block.
///
/// @param valueObjCType The Objective-C type that the applied property value
///                      should be a type of. Should be invoked with the value
///                      returned by the @encode directive, e.g.
///                      @encode(UIEdgeInsets).
///
/// @return An initialized theme class property applier.
- (instancetype)initWithProperty:(NSString *)property valueObjCType:(const char *)valueObjCType applierBlock:(MTFThemePropertyApplierBlock)applierBlock NS_DESIGNATED_INITIALIZER;

/// The Objective-C type of the value that this applier is expecting.
@property (readonly, nonatomic) const char * valueObjCType;

/// Returns the value for applying the specified property value of a certain
/// Objective-C type from a theme class.
///
/// If a property of the specified name is found but is not of the correct type,
/// this method attempts to locate a value transformer that is able to transform
/// the value to the specified type. If one is found, it transforms the returned
/// value if one is found.
///
/// @param property The name of the property to query the theme class for.
///
/// @param objCType The Objective-C type that the return value should be kind
/// of. Should be invoked with the value returned by the @encode directive, e.g.
/// @encode(UIEdgeInsets).
///
/// @param themeClass The theme class that contains the property to be queried
/// for.
///
/// @return
+ (nullable NSDictionary<NSString *, id> *)valueForApplyingProperty:(NSString *)property asObjCType:(const char *)objCType fromThemeClass:(MTFThemeClass *)themeClass error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
