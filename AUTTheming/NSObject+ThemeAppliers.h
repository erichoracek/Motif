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

typedef void (^AUTThemeClassApplierBlock)(id objectToTheme);

typedef void (^AUTThemePropertyApplierBlock)(id propertyValue, id objectToTheme);

typedef void (^AUTThemePropertiesApplierBlock)(NSDictionary *valuesForProperties, id objectToTheme);

@interface NSObject (ThemeAppliers)

+ (id <AUTThemeClassApplicable>)aut_registerThemeClassApplier:(AUTThemeClassApplierBlock)applier;

+ (id <AUTThemeClassApplicable>)aut_registerThemeProperty:(NSString *)property applier:(AUTThemePropertyApplierBlock)applier;

+ (id <AUTThemeClassApplicable>)aut_registerThemeProperty:(NSString *)property valueTransformerName:(NSString *)transformerName applier:(AUTThemePropertyApplierBlock)applier;

+ (id <AUTThemeClassApplicable>)aut_registerThemeProperty:(NSString *)property requiringValueOfClass:(Class)valueClass applier:(AUTThemePropertyApplierBlock)applier;

+ (id <AUTThemeClassApplicable>)aut_registerThemeProperties:(NSArray *)properties applier:(AUTThemePropertiesApplierBlock)applier;

+ (id <AUTThemeClassApplicable>)aut_registerThemeProperties:(NSArray *)properties valueTransformerNamesOrRequiredClasses:(NSArray *)transformersOrClasses applier:(AUTThemePropertiesApplierBlock)applier;

+ (void)aut_registerThemeApplier:(id <AUTThemeClassApplicable>)applier;

@end
