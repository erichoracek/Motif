//
//  NSObject+ThemeAppliers.m
//  Motif
//
//  Created by Eric Horacek on 12/25/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import ObjectiveC;

#import "MTFThemeClassPropertyApplier.h"
#import "MTFThemeClassPropertiesApplier.h"
#import "MTFThemeClassApplicable.h"
#import "MTFErrors.h"

#import "NSObject+ThemeClassAppliersPrivate.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSObject (ThemeAppliers)

#pragma mark - Public

+ (id<MTFThemeClassApplicable>)mtf_registerThemeProperty:(NSString *)property applierBlock:(MTFThemePropertyApplierBlock)applierBlock {
    NSParameterAssert(property != nil);
    NSParameterAssert(applierBlock != nil);
    
    MTFThemeClassPropertyApplier *applier = [[MTFThemeClassPropertyApplier alloc]
        initWithProperty:property
        applierBlock:applierBlock];
    
    [self mtf_registerThemeClassApplier:applier];
    return applier;
}

+ (id<MTFThemeClassApplicable>)mtf_registerThemeProperty:(NSString *)property requiringValueOfClass:(Class)valueClass applierBlock:(MTFThemePropertyApplierBlock)applierBlock {
    NSParameterAssert(property != nil);
    NSParameterAssert(valueClass != nil);
    NSParameterAssert(applierBlock != nil);
    
    MTFThemeClassValueClassPropertyApplier *applier = [[MTFThemeClassValueClassPropertyApplier alloc]
        initWithProperty:property
        valueClass:valueClass
        applierBlock:applierBlock];
        
    [self mtf_registerThemeClassApplier:applier];
    return applier;
}

+ (id<MTFThemeClassApplicable>)mtf_registerThemeProperty:(NSString *)property requiringValueOfObjCType:(const char *)valueObjCType applierBlock:(MTFThemePropertyObjCValueApplierBlock)applierBlock {
    NSParameterAssert(property != nil);
    NSParameterAssert(applierBlock != nil);
    NSParameterAssert(valueObjCType != nil);

    MTFThemeClassValueObjCTypePropertyApplier *applier = [[MTFThemeClassValueObjCTypePropertyApplier alloc]
        initWithProperty:property
        valueObjCType:valueObjCType
        applierBlock:applierBlock];

    [self mtf_registerThemeClassApplier:applier];
    return applier;
}

+ (id<MTFThemeClassApplicable>)mtf_registerThemeProperties:(NSArray<NSString *> *)properties applierBlock:(MTFThemePropertiesApplierBlock)applierBlock {
    NSParameterAssert(properties != nil);
    NSParameterAssert(applierBlock != nil);
    
    MTFThemeClassPropertiesApplier *applier = [[MTFThemeClassPropertiesApplier alloc]
        initWithProperties:properties
        applierBlock:applierBlock];

    [self mtf_registerThemeClassApplier:applier];
    return applier;
}

+ (id<MTFThemeClassApplicable>)mtf_registerThemeProperties:(NSArray<NSString *> *)properties requiringValuesOfType:(NSArray *)valueTypes applierBlock:(MTFThemePropertiesApplierBlock)applierBlock {
    NSParameterAssert(properties != nil);
    NSParameterAssert(valueTypes != nil);
    NSParameterAssert(applierBlock != nil);
    
    MTFThemeClassTypedValuesPropertiesApplier *applier = [[MTFThemeClassTypedValuesPropertiesApplier alloc]
        initWithProperties:properties
        valueTypes:valueTypes
        applierBlock:applierBlock];

    [self mtf_registerThemeClassApplier:applier];
    return applier;
}

+ (id<MTFThemeClassApplicable>)mtf_registerThemeProperty:(NSString *)property forKeyPath:(NSString *)keyPath withValuesByKeyword:(NSDictionary<NSString *, id> *)valuesByKeyword {
    NSParameterAssert(property != nil);
    NSParameterAssert(keyPath != nil);
    NSParameterAssert(valuesByKeyword != nil);
    NSAssert(valuesByKeyword.count > 0, @"Must have at least one value by keyword");

    return [self
        mtf_registerThemeProperty:property
        requiringValueOfClass:NSString.class
        applierBlock:^(NSString *keyword, id applicant, NSError **error){
            NSNumber *value = valuesByKeyword[keyword];

            if (value == nil) {
                return [self
                    mtf_populateApplierError:error
                    withDescriptionFormat:
                        @"Invalid %@ key %@, must be one of: %@.",
                        property,
                        keyword,
                        [valuesByKeyword.allKeys componentsJoinedByString:@", "]];
            }

            [applicant setValue:value forKeyPath:keyPath];

            return YES;
        }];
}

+ (void)mtf_registerThemeClassApplier:(id<MTFThemeClassApplicable>)applier {
    NSParameterAssert(applier != nil);
    
    NSAssert(
        NSThread.isMainThread,
        @"Theme class applier registration should only be invoked from the "
            "main thread in +[NSObject load] or +[NSObject initialize] "
            "methods.");
    
    [self.mtf_classThemeClassAppliers addObject:applier];
}

+ (BOOL)mtf_populateApplierError:(NSError **)error withDescription:(NSString *)description {
    NSParameterAssert(description != nil);

    if (error != NULL) {
        *error = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToApplyTheme userInfo:@{
            NSLocalizedDescriptionKey: description,
        }];
    }

    return NO;
}

+ (BOOL)mtf_populateApplierError:(NSError **)error withDescriptionFormat:(NSString *)descriptionFormat, ... NS_FORMAT_FUNCTION(2,3) {
    NSParameterAssert(descriptionFormat != nil);

    if (error == NULL) return NO;

    va_list args;
    va_start(args, descriptionFormat);
    NSString *description = [[NSString alloc] initWithFormat:descriptionFormat arguments:args];
    va_end(args);

    return [self mtf_populateApplierError:error withDescription:description];
}

@end

@implementation NSObject (ThemingPrivate)

#pragma mark - Public

+ (void)mtf_deregisterThemeClassApplier:(id<MTFThemeClassApplicable>)applier {
    NSParameterAssert(applier != nil);
    
    NSAssert(
        NSThread.isMainThread,
        @"Theme class applier deregistration should only be invoked from the "
            "main thread.");
    
    [self.mtf_classThemeClassAppliers removeObject:applier];
}

+ (NSArray<id<MTFThemeClassApplicable>> *)mtf_themeClassAppliers {
    NSMutableArray<id<MTFThemeClassApplicable>> *appliers = [NSMutableArray array];
    Class class = self.class;
    do {
        NSMutableArray<id<MTFThemeClassApplicable>> *classAppliers = class.mtf_classThemeClassAppliers;
        [appliers addObjectsFromArray:classAppliers];
    } while ((class = class.superclass));
    return appliers;
}

+ (NSMutableArray<id<MTFThemeClassApplicable>> *)mtf_classThemeClassAppliers {
    NSMutableArray<id<MTFThemeClassApplicable>> *appliers = objc_getAssociatedObject(self, _cmd);
    if (appliers == nil) {
        appliers = [NSMutableArray array];
        objc_setAssociatedObject(
            self,
            _cmd,
            appliers,
            OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return appliers;
}

@end

NS_ASSUME_NONNULL_END
