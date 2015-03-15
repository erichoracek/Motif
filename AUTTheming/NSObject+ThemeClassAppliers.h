//
//  NSObject+ThemeAppliers.h
//  Pods
//
//  Created by Eric Horacek on 12/25/14.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AUTThemeClass;
@protocol AUTThemeClassApplicable;

typedef void (^AUTThemeClassApplierBlock)(AUTThemeClass * __nonnull class, id __nonnull objectToTheme);

typedef void (^AUTThemePropertyApplierBlock)(id __nonnull propertyValue, id __nonnull objectToTheme);

typedef void (^AUTThemePropertiesApplierBlock)(NSDictionary * __nonnull valuesForProperties, id __nonnull objectToTheme);

@interface NSObject (ThemeAppliers)

+ (id <AUTThemeClassApplicable>)aut_registerThemeClassApplierBlock:(AUTThemeClassApplierBlock)applierBlock;

+ (id <AUTThemeClassApplicable>)aut_registerThemeProperty:(NSString *)property applierBlock:(AUTThemePropertyApplierBlock)applierBlock;

+ (id <AUTThemeClassApplicable>)aut_registerThemeProperty:(NSString *)property valueTransformerName:(NSString *)transformerName applierBlock:(AUTThemePropertyApplierBlock)applier;

+ (id <AUTThemeClassApplicable>)aut_registerThemeProperty:(NSString *)property requiringValueOfClass:(Class)valueClass applierBlock:(AUTThemePropertyApplierBlock)applierBlock;

+ (id <AUTThemeClassApplicable>)aut_registerThemeProperties:(NSArray *)properties applierBlock:(AUTThemePropertiesApplierBlock)applierBlock;

+ (id <AUTThemeClassApplicable>)aut_registerThemeProperties:(NSArray *)properties valueTransformerNamesOrRequiredClasses:(NSArray *)transformersOrClasses applierBlock:(AUTThemePropertiesApplierBlock)applierBlock;

+ (void)aut_registerThemeClassApplier:(id <AUTThemeClassApplicable>)applier;

@end

NS_ASSUME_NONNULL_END
