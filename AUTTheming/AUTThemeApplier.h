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

@protocol AUTThemeApplier <NSObject>

@property (nonatomic, readonly) NSArray *properties;

- (void)applyClass:(AUTThemeClass *)class fromTheme:(AUTTheme *)theme toObject:(id)object;

- (BOOL)shouldApplyClass:(AUTThemeClass *)class;

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
