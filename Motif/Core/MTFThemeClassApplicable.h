//
//  MTFThemeApplicable.h
//  Motif
//
//  Created by Eric Horacek on 12/26/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTFBackwardsCompatableNullability.h"
#import "NSObject+ThemeClassAppliers.h"

MTF_NS_ASSUME_NONNULL_BEGIN

@class MTFThemeClass;
@class MTFTheme;

/**
 MTFThemeClassApplicable is an abstract protocol that defines the methods and
 properties required to apply an MTFThemeClass from an MTFTheme to an object.
 
 You likely won't ever have to use an object that conforms to
 MTFThemeClassApplicable directly. The easiest way to register an applier is by
 using the `+[NSObject mtf_registerTheme...applierBlock:]` methods, which is a
 convenience method for creating and registering one of the below appliers.
 
 Alternatively, an applier can be initialized and added using the
 `+[NSObject mtf_registerThemeApplier:]` method.
 */
@protocol MTFThemeClassApplicable <NSObject>

/**
 The properties that the theme applier is responsible for applying to the target
 object.
 */
@property (nonatomic, readonly) NSArray *properties;

/**
 Returns whether the receiving applier should be used apply the properties in
 the specified class to an object.
 
 @param class The theme class that is being querying for application.
 
 @return Whether the receiving applier should apply the specified theme class.
 */
- (BOOL)shouldApplyClass:(MTFThemeClass *)themeClass;

/**
 Applies an MTFThemeClass from an MTFTheme to an object.
 
 @param class  The class that should have its properties applied
 @param theme  The theme that should be applied to the specified class.
 @param object The object that should have the class applied to it.
 */
- (void)applyClass:(MTFThemeClass *)themeClass toObject:(id)object;

@end

@interface MTFThemeClassApplier : NSObject <MTFThemeClassApplicable>

- (instancetype)initWithClassApplierBlock:(MTFThemeClassApplierBlock)applierBlock NS_DESIGNATED_INITIALIZER;

@property (nonatomic, copy, readonly) MTFThemeClassApplierBlock applierBlock;

@end

@interface MTFThemeClassPropertyApplier : NSObject <MTFThemeClassApplicable>

- (instancetype)initWithProperty:(NSString *)property valueTransformerName:(mtf_nullable NSString *)name requiredClass:(mtf_nullable Class)requiredClass applierBlock:(MTFThemePropertyApplierBlock)applierBlock NS_DESIGNATED_INITIALIZER;

@property (nonatomic, copy, readonly) NSString *property;

@property (nonatomic, copy, readonly, mtf_nullable) NSString *valueTransformerName;

@property (nonatomic, readonly, mtf_nullable) Class requiredClass;

@property (nonatomic, copy, readonly) MTFThemePropertyApplierBlock applierBlock;

@end

@interface MTFThemeClassPropertiesApplier : NSObject <MTFThemeClassApplicable>

- (instancetype)initWithProperties:(NSArray *)properties valueTransformersOrRequiredClasses:(mtf_nullable NSArray *)valueTransformersOrRequiredClasses applierBlock:(MTFThemePropertiesApplierBlock)applierBlock NS_DESIGNATED_INITIALIZER;

/**
 If nil, there are no value transfomer or required classes for this theme applier.
 */
@property (nonatomic, readonly, mtf_nullable) NSArray *valueTransformersOrRequiredClasses;


@property (nonatomic, copy, readonly) MTFThemePropertiesApplierBlock applierBlock;

@end

MTF_NS_ASSUME_NONNULL_END
