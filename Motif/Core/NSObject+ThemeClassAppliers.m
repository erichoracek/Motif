//
//  NSObject+ThemeAppliers.m
//  Motif
//
//  Created by Eric Horacek on 12/25/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+ThemeClassAppliers.h"
#import "NSObject+ThemeClassAppliersPrivate.h"
#import "MTFThemeClassApplicable.h"

@implementation NSObject (ThemeAppliers)

#pragma mark - Public

+ (id)mtf_registerThemeClassApplierBlock:(MTFThemeClassApplierBlock)applierBlock {
    NSParameterAssert(applierBlock);
    
    MTFThemeClassApplier *applier = [[MTFThemeClassApplier alloc] initWithClassApplierBlock:applierBlock];
    [self mtf_registerThemeClassApplier:applier];
    return applier;
}

+ (id)mtf_registerThemeProperty:(NSString *)property applierBlock:(MTFThemePropertyApplierBlock)applierBlock {
    NSParameterAssert(property);
    NSParameterAssert(applierBlock);
    
    MTFThemeClassPropertyApplier *applier = [[MTFThemeClassPropertyApplier alloc]
        initWithProperty:property
        valueTransformerName:nil
        requiredClass:nil
        applierBlock:applierBlock];
    
    [self mtf_registerThemeClassApplier:applier];
    return applier;
}

+ (id)mtf_registerThemeProperty:(NSString *)property requiringValueOfClass:(Class)valueClass applierBlock:(MTFThemePropertyApplierBlock)applierBlock {
    NSParameterAssert(property);
    NSAssert(
        valueClass,
        @"valueClass is Nil. Use the equivalent method without valueClass as a "
             "parameter instead.");
    NSParameterAssert(applierBlock);
    
    MTFThemeClassPropertyApplier *applier = [[MTFThemeClassPropertyApplier alloc] initWithProperty:property valueTransformerName:nil requiredClass:valueClass applierBlock:applierBlock];
    [self mtf_registerThemeClassApplier:applier];
    return applier;
}

+ (id)mtf_registerThemeProperty:(NSString *)property valueTransformerName:(NSString *)transformerName applierBlock:(MTFThemePropertyApplierBlock)applierBlock {
    NSParameterAssert(property);
    NSAssert(
        transformerName,
        @"transformerName is nil. Use the equivalent method without "
             "transformerName instead.");
    NSParameterAssert(applierBlock);
    
    MTFThemeClassPropertyApplier *applier = [[MTFThemeClassPropertyApplier alloc] initWithProperty:property valueTransformerName:transformerName requiredClass:nil applierBlock:applierBlock];
    [self mtf_registerThemeClassApplier:applier];
    return applier;
}

+ (id)mtf_registerThemeProperties:(NSArray *)properties applierBlock:(MTFThemePropertiesApplierBlock)applierBlock {
    NSParameterAssert(properties);
    NSParameterAssert(applierBlock);
    
    MTFThemeClassPropertiesApplier *applier = [[MTFThemeClassPropertiesApplier alloc] initWithProperties:properties valueTransformersOrRequiredClasses:nil applierBlock:applierBlock];
    [self mtf_registerThemeClassApplier:applier];
    return applier;
}

+ (id)mtf_registerThemeProperties:(NSArray *)properties valueTransformerNamesOrRequiredClasses:(NSArray *)transformersOrClasses applierBlock:(MTFThemePropertiesApplierBlock)applierBlock {
    NSParameterAssert(properties);
    NSAssert(
        transformersOrClasses,
        @"transformersOrClasses is nil. Use the equivalent method without "
             "transformersOrClasses instead.");
    NSParameterAssert(applierBlock);
    
    MTFThemeClassPropertiesApplier *applier = [[MTFThemeClassPropertiesApplier alloc] initWithProperties:properties valueTransformersOrRequiredClasses:transformersOrClasses applierBlock:applierBlock];
    [self mtf_registerThemeClassApplier:applier];
    return applier;
}

+ (id<MTFThemeClassApplicable>)mtf_registerThemeProperty:(NSString *)property forKeyPath:(NSString *)keyPath withValuesByKeyword:(NSDictionary *)valuesByKeyword {
    NSParameterAssert(property != nil);
    NSParameterAssert(keyPath != nil);
    NSParameterAssert(valuesByKeyword != nil);
    NSAssert(valuesByKeyword.count > 0, @"Must have at least one value by keyword");

    return [self
        mtf_registerThemeProperty:property
        requiringValueOfClass:NSString.class
        applierBlock:^(NSString *keyword, id applicant){
            NSNumber *value = valuesByKeyword[keyword];

            NSAssert(
                value != nil,
                @"Invalid %@ property value: %@, must be one of: %@.",
                property,
                keyword,
                [valuesByKeyword.allKeys componentsJoinedByString:@", "]);

            [applicant setValue:value forKeyPath:keyPath];
        }];
}

+ (void)mtf_registerThemeClassApplier:(id <MTFThemeClassApplicable>)applier {
    NSParameterAssert(applier);
    
    NSAssert(
        NSThread.isMainThread,
        @"Theme class applier registration should only be invoked from the "
            "main thread in +[NSObject load] or +[NSObject initialize] "
            "methods.");
    
    [self.mtf_classThemeClassAppliers addObject:applier];
}

@end

@implementation NSObject (ThemingPrivate)

#pragma mark - Public

+ (void)mtf_deregisterThemeClassApplier:(id <MTFThemeClassApplicable>)applier {
    NSParameterAssert(applier);
    
    NSAssert(
        NSThread.isMainThread,
        @"Theme class applier deregistration should only be invoked from the "
            "main thread.");
    
    [self.mtf_classThemeClassAppliers removeObject:applier];
}

+ (NSArray *)mtf_themeClassAppliers {
    NSMutableArray *appliers = [NSMutableArray new];
    Class class = self.class;
    do {
        NSArray *classAppliers = class.mtf_classThemeClassAppliers;
        [appliers addObjectsFromArray:classAppliers];
    } while ((class = class.superclass));
    return appliers;
}

+ (NSMutableArray *)mtf_classThemeClassAppliers {
    NSMutableArray *appliers = objc_getAssociatedObject(self, _cmd);
    if (!appliers) {
        appliers = [NSMutableArray new];
        objc_setAssociatedObject(
            self,
            _cmd,
            appliers,
            OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return appliers;
}

@end
