//
//  NSObject+ThemeAppliers.h
//  Motif
//
//  Created by Eric Horacek on 12/25/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTFBackwardsCompatableNullability.h"

MTF_NS_ASSUME_NONNULL_BEGIN

@class MTFThemeClass;
@protocol MTFThemeClassApplicable;

typedef void (^MTFThemeClassApplierBlock)(MTFThemeClass *class, id objectToTheme);

typedef void (^MTFThemePropertyApplierBlock)(id propertyValue, id objectToTheme);

typedef void (^MTFThemePropertiesApplierBlock)(NSDictionary *valuesForProperties, id objectToTheme);

@interface NSObject (ThemeAppliers)

+ (id <MTFThemeClassApplicable>)mtf_registerThemeClassApplierBlock:(MTFThemeClassApplierBlock)applierBlock;

+ (id <MTFThemeClassApplicable>)mtf_registerThemeProperty:(NSString *)property applierBlock:(MTFThemePropertyApplierBlock)applierBlock;

+ (id <MTFThemeClassApplicable>)mtf_registerThemeProperty:(NSString *)property valueTransformerName:(NSString *)transformerName applierBlock:(MTFThemePropertyApplierBlock)applier;

+ (id <MTFThemeClassApplicable>)mtf_registerThemeProperty:(NSString *)property requiringValueOfClass:(Class)valueClass applierBlock:(MTFThemePropertyApplierBlock)applierBlock;

+ (id <MTFThemeClassApplicable>)mtf_registerThemeProperties:(NSArray *)properties applierBlock:(MTFThemePropertiesApplierBlock)applierBlock;

+ (id <MTFThemeClassApplicable>)mtf_registerThemeProperties:(NSArray *)properties valueTransformerNamesOrRequiredClasses:(NSArray *)transformersOrClasses applierBlock:(MTFThemePropertiesApplierBlock)applierBlock;

+ (void)mtf_registerThemeClassApplier:(id <MTFThemeClassApplicable>)applier;

@end

MTF_NS_ASSUME_NONNULL_END
