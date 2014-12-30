//
//  AUTThemeApplier.h
//  Pods
//
//  Created by Eric Horacek on 12/26/14.
//
//

#import <Foundation/Foundation.h>
#import "NSObject+ThemeAppliers.h"

@class AUTThemeClass;
@class AUTTheme;

/**
 A theme applier is an abstract protocol that defines the methods and properties required to apply an AUTThemeClass from an AUTTheme to an object.
 
 You likely won't even have to use an AUTThemeApplier directly. The easiest way to register an applier is by using the `+[NSObject aut_registerTheme...applier:]` methods, which is a convenience method for creating and registering one of the below appliers.
 
 Alternatively, an applier can be initialized and added using the `+[NSObject aut_registerThemeApplier:]` method.
 */
@protocol AUTThemeApplier <NSObject>

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
- (void)applyClass:(AUTThemeClass *)class fromTheme:(AUTTheme *)theme toObject:(id)object;

@end

@interface AUTThemeClassApplier : NSObject <AUTThemeApplier>

- (instancetype)initWithClassApplier:(AUTThemeClassApplierBlock)applier;

@property (nonatomic, copy, readonly) AUTThemeClassApplierBlock applier;

@end

@interface AUTThemePropertyApplier : NSObject <AUTThemeApplier>

- (instancetype)initWithProperty:(NSString *)property applier:(AUTThemePropertyApplierBlock)applier valueTransformerName:(NSString *)name requiredClass:(Class)class;

@property (nonatomic, copy, readonly) NSString *property;
@property (nonatomic, copy, readonly) NSString *valueTransformerName;
@property (nonatomic, readonly) Class requiredClass;
@property (nonatomic, copy, readonly) AUTThemePropertyApplierBlock applier;

@end

@interface AUTThemePropertiesApplier : NSObject <AUTThemeApplier>

- (instancetype)initWithProperties:(NSArray *)properties valueTransformersOrRequiredClasses:(NSArray *)valueTransformersOrRequiredClasses applier:(AUTThemePropertiesApplierBlock)applier;

/**
 If nil, there are no value transfomer or required classes for this theme applier.
 */
@property (nonatomic, readonly) NSArray *valueTransformersOrRequiredClasses;


@property (nonatomic, copy, readonly) AUTThemePropertiesApplierBlock applier;

@end
