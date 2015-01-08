//
//  AUTThemeApplicable.h
//  Pods
//
//  Created by Eric Horacek on 12/26/14.
//
//

#import <Foundation/Foundation.h>
#import "NSObject+ThemeClassAppliers.h"

@class AUTThemeClass;
@class AUTTheme;

/**
 AUTThemeClassApplicable is an abstract protocol that defines the methods and properties required to apply an AUTThemeClass from an AUTTheme to an object.
 
 You likely won't even have to use an object that conforms to AUTThemeClassApplicable directly. The easiest way to register an applier is by using the `+[NSObject aut_registerTheme...applierBlock:]` methods, which is a convenience method for creating and registering one of the below appliers.
 
 Alternatively, an applier can be initialized and added using the `+[NSObject aut_registerThemeApplier:]` method.
 */
@protocol AUTThemeClassApplicable <NSObject>

/**
 The properties that the theme applier is responsible for applying to the target object.
 */
@property (nonatomic, readonly) NSArray *properties;

/**
 Returns whether the receiving applier should be used apply the properties in the specified class to an object.
 
 @param class The theme class that is being querying for application.
 
 @return Whether the receiving applier should apply the specified theme class.
 */
- (BOOL)shouldApplyClass:(AUTThemeClass *)class;

/**
 Applies an AUTThemeClass from an AUTTheme to an object.
 
 @param class  The class that should have its properties applied
 @param theme  The theme that should be applied to the specified class.
 @param object The object that should have the class applied to it.
 */
- (void)applyClass:(AUTThemeClass *)class toObject:(id)object;

@end

@interface AUTThemeClassApplier : NSObject <AUTThemeClassApplicable>

- (instancetype)initWithClassApplierBlock:(AUTThemeClassApplierBlock)applierBlock NS_DESIGNATED_INITIALIZER __attribute__ ((nonnull));

@property (nonatomic, copy, readonly) AUTThemeClassApplierBlock applierBlock;

@end

@interface AUTThemeClassPropertyApplier : NSObject <AUTThemeClassApplicable>

- (instancetype)initWithProperty:(NSString *)property valueTransformerName:(NSString *)name requiredClass:(Class)class applierBlock:(AUTThemePropertyApplierBlock)applierBlock NS_DESIGNATED_INITIALIZER __attribute__ ((nonnull (1, 4)));

@property (nonatomic, copy, readonly) NSString *property;
@property (nonatomic, copy, readonly) NSString *valueTransformerName;
@property (nonatomic, readonly) Class requiredClass;
@property (nonatomic, copy, readonly) AUTThemePropertyApplierBlock applierBlock;

@end

@interface AUTThemeClassPropertiesApplier : NSObject <AUTThemeClassApplicable>

- (instancetype)initWithProperties:(NSArray *)properties valueTransformersOrRequiredClasses:(NSArray *)valueTransformersOrRequiredClasses applierBlock:(AUTThemePropertiesApplierBlock)applierBlock NS_DESIGNATED_INITIALIZER __attribute__ ((nonnull (1, 3)));

/**
 If nil, there are no value transfomer or required classes for this theme applier.
 */
@property (nonatomic, readonly) NSArray *valueTransformersOrRequiredClasses;


@property (nonatomic, copy, readonly) AUTThemePropertiesApplierBlock applierBlock;

@end
