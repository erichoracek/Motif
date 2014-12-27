//
//  NSObject+ThemeAppliers.h
//  Pods
//
//  Created by Eric Horacek on 12/25/14.
//
//

#import <Foundation/Foundation.h>

@class AUTThemeClass;
@protocol AUTThemeApplier;

typedef void (^AUTThemeClassApplierBlock)(id objectToTheme);

typedef void (^AUTThemePropertyApplierBlock)(id propertyValue, id objectToTheme);

typedef void (^AUTThemePropertiesApplierBlock)(NSDictionary *valuesForProperties, id objectToTheme);

@interface NSObject (ThemeAppliers)

+ (id <AUTThemeApplier>)aut_registerThemeClassApplier:(AUTThemeClassApplierBlock)applier;

+ (id <AUTThemeApplier>)aut_registerThemeProperty:(NSString *)property applier:(AUTThemePropertyApplierBlock)applier;

+ (id <AUTThemeApplier>)aut_registerThemeProperty:(NSString *)property valueTransformerName:(NSString *)transformerName applier:(AUTThemePropertyApplierBlock)applier;

+ (id <AUTThemeApplier>)aut_registerThemeProperty:(NSString *)property requiringValueOfClass:(Class)valueClass applier:(AUTThemePropertyApplierBlock)applier;

+ (id <AUTThemeApplier>)aut_registerThemeProperties:(NSArray *)properties applier:(AUTThemePropertiesApplierBlock)applier;

+ (id <AUTThemeApplier>)aut_registerThemeProperties:(NSArray *)properties valueTransformerNamesOrRequiredClasses:(NSArray *)transformersOrClasses applier:(AUTThemePropertiesApplierBlock)applier;

+ (void)aut_registerThemeApplier:(id <AUTThemeApplier>)applier;

@end
