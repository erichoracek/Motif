//
//  NSObject+ThemeAppliers.h
//  Pods
//
//  Created by Eric Horacek on 12/25/14.
//
//

#import <Foundation/Foundation.h>

@class AUTThemeClass;
@protocol AUTThemeClassApplicable;

typedef void (^AUTThemeClassApplierBlock)(AUTThemeClass *class, id objectToTheme);

typedef void (^AUTThemePropertyApplierBlock)(id propertyValue, id objectToTheme);

typedef void (^AUTThemePropertiesApplierBlock)(NSDictionary *valuesForProperties, id objectToTheme);

@interface NSObject (ThemeAppliers)

+ (id <AUTThemeClassApplicable>)aut_registerThemeClassApplierBlock:(AUTThemeClassApplierBlock)applierBlock;

+ (id <AUTThemeClassApplicable>)aut_registerThemeProperty:(NSString *)property applierBlock:(AUTThemePropertyApplierBlock)applierBlock;

+ (id <AUTThemeClassApplicable>)aut_registerThemeProperty:(NSString *)property valueTransformerName:(NSString *)transformerName applierBlock:(AUTThemePropertyApplierBlock)applier;

+ (id <AUTThemeClassApplicable>)aut_registerThemeProperty:(NSString *)property requiringValueOfClass:(Class)valueClass applierBlock:(AUTThemePropertyApplierBlock)applierBlock;

+ (id <AUTThemeClassApplicable>)aut_registerThemeProperties:(NSArray *)properties applierBlock:(AUTThemePropertiesApplierBlock)applierBlock;

+ (id <AUTThemeClassApplicable>)aut_registerThemeProperties:(NSArray *)properties valueTransformerNamesOrRequiredClasses:(NSArray *)transformersOrClasses applierBlock:(AUTThemePropertiesApplierBlock)applierBlock;

+ (void)aut_registerThemeClassApplier:(id <AUTThemeClassApplicable>)applier;

@end
