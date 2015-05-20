//
//  MTFThemeApplicable.h
//  Motif
//
//  Created by Eric Horacek on 12/26/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Motif/MTFBackwardsCompatableNullability.h>
#import <Motif/NSObject+ThemeClassAppliers.h>

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
 Returns whether the receiving applier should be used to apply the properties in
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

/**
 An applier that is invoked when a theme class is applied to an object.
 */
@interface MTFThemeClassApplier : NSObject <MTFThemeClassApplicable>

/**
 Initializes an theme class applier.
 
 @param applierBlock A block that is invoked when a class is applied to the
                     object that this applier is registered with.
 
 @return An initialized theme class applier.
 */
- (instancetype)initWithClassApplierBlock:(MTFThemeClassApplierBlock)applierBlock NS_DESIGNATED_INITIALIZER;


/**
 The block that is invoked when a theme class is applied to an instance of the
 class that this applier is registered with.
 */
@property (nonatomic, copy, readonly) MTFThemeClassApplierBlock applierBlock;

@end

/**
 An applier that is invoked when a specific property is applied to an object.
 */
@interface MTFThemeClassPropertyApplier : NSObject <MTFThemeClassApplicable>

/**
 Initializes a theme class property applier.
 
 @param property             The name of the property that this applier is 
                             responsible for applying.
 @param valueTransformerName The name of the value transformer used to transform
                             this value from the raw theme file to the value
                             that is a parameter to the applier block, or nil
                             if the value needs no transformation.
 @param requiredClass        The class that the property value is required to be
                             a kind of, or nil if the type of the value should 
                             not be checked.
 @param applierBlock         The block that is invoked to apply the property
                             value to the class that this applier is registered
                             with.
 
 @return An initialized theme class property applier.
 */
- (instancetype)initWithProperty:(NSString *)property valueTransformerName:(mtf_nullable NSString *)name requiredClass:(mtf_nullable Class)requiredClass applierBlock:(MTFThemePropertyApplierBlock)applierBlock NS_DESIGNATED_INITIALIZER;

/**
 The name of the property that this theme property applier is responsible for
 applying.
 */
@property (nonatomic, copy, readonly) NSString *property;

/**
 The name of the value transformer used to transform this value from the raw
 theme file to the value that is a parameter to the applier block, or nil if the
 value needs no transformation.
 */
@property (nonatomic, copy, readonly, mtf_nullable) NSString *valueTransformerName;

/**
 The class that the property value is required to be a kind of, or nil if the
 type of the value should not be checked.
 */
@property (nonatomic, readonly, mtf_nullable) Class requiredClass;

/**
 The block that is invoked to apply the property value to an instance of the
 class that this applier is registered with.
 */
@property (nonatomic, copy, readonly) MTFThemePropertyApplierBlock applierBlock;

@end

/**
 An applier that is invoked when a set of properties are applied to an object.
 */
@interface MTFThemeClassPropertiesApplier : NSObject <MTFThemeClassApplicable>

/**
 Initializes a theme class properties applier.
 
 @param properties                         The names of the properties that this
                                           applier is responsible for applying.
 @param valueTransformersOrRequiredClasses An array of value transformer names
                                           or required classes in the same order
                                           as the property names.
 @param applierBlock                       The block that is invoked when all of
                                           the specified properties are 
                                           contained within a theme class that
                                           is being applied to the object that 
                                           this applier is registered with.
 
 @return An initialized theme class properties applier.
 */
- (instancetype)initWithProperties:(NSArray *)properties valueTransformersOrRequiredClasses:(mtf_nullable NSArray *)valueTransformersOrRequiredClasses applierBlock:(MTFThemePropertiesApplierBlock)applierBlock NS_DESIGNATED_INITIALIZER;

/**
 An array specifying either of the following, in the same order as the
 properties that this applier is responsible for applying:
 
 - The name of the value transformer used to transform this value from the raw
 theme file to the value that is a parameter to the applier block, or nil if the
 value needs no transformation.
 - The class that the property value is required to be a kind of, or nil if the
 type of the value should not be checked.
 
 If nil, there are no value transfomer or required classes for this theme
 applier.
 */
@property (nonatomic, readonly, mtf_nullable) NSArray *valueTransformersOrRequiredClasses;

/**
 The block that is invoked to apply the property values to an instance of the
 class that this applier is registered with.
 */
@property (nonatomic, copy, readonly) MTFThemePropertiesApplierBlock applierBlock;

@end

MTF_NS_ASSUME_NONNULL_END
