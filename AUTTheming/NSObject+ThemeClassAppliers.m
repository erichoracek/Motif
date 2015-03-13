//
//  NSObject+ThemeAppliers.m
//  Pods
//
//  Created by Eric Horacek on 12/25/14.
//
//

#import <objc/runtime.h>
#import "NSObject+ThemeClassAppliers.h"
#import "NSObject+ThemeClassAppliersPrivate.h"
#import "AUTThemeClassApplicable.h"

@implementation NSObject (ThemeAppliers)

#pragma mark - Public

+ (id)aut_registerThemeClassApplierBlock:(AUTThemeClassApplierBlock)applierBlock
{
    AUTThemeClassApplier *applier = [[AUTThemeClassApplier alloc] initWithClassApplierBlock:applierBlock];
    [self aut_registerThemeClassApplier:applier];
    return applier;
}

+ (id)aut_registerThemeProperty:(NSString *)property applierBlock:(AUTThemePropertyApplierBlock)applierBlock
{
    AUTThemeClassPropertyApplier *applier = [[AUTThemeClassPropertyApplier alloc] initWithProperty:property valueTransformerName:nil requiredClass:nil applierBlock:applierBlock];
    [self aut_registerThemeClassApplier:applier];
    return applier;
}

+ (id)aut_registerThemeProperty:(NSString *)property requiringValueOfClass:(Class)valueClass applierBlock:(AUTThemePropertyApplierBlock)applierBlock
{
    AUTThemeClassPropertyApplier *applier = [[AUTThemeClassPropertyApplier alloc] initWithProperty:property valueTransformerName:nil requiredClass:valueClass applierBlock:applierBlock];
    [self aut_registerThemeClassApplier:applier];
    return applier;
}

+ (id)aut_registerThemeProperty:(NSString *)property valueTransformerName:(NSString *)transformerName applierBlock:(AUTThemePropertyApplierBlock)applierBlock
{
    AUTThemeClassPropertyApplier *applier = [[AUTThemeClassPropertyApplier alloc] initWithProperty:property valueTransformerName:transformerName requiredClass:nil applierBlock:applierBlock];
    [self aut_registerThemeClassApplier:applier];
    return applier;
}

+ (id)aut_registerThemeProperties:(NSArray *)properties applierBlock:(AUTThemePropertiesApplierBlock)applierBlock
{
    AUTThemeClassPropertiesApplier *applier = [[AUTThemeClassPropertiesApplier alloc] initWithProperties:properties valueTransformersOrRequiredClasses:nil applierBlock:applierBlock];
    [self aut_registerThemeClassApplier:applier];
    return applier;
}

+ (id)aut_registerThemeProperties:(NSArray *)properties valueTransformerNamesOrRequiredClasses:(NSArray *)transformersOrClasses applierBlock:(AUTThemePropertiesApplierBlock)applierBlock
{
    AUTThemeClassPropertiesApplier *applier = [[AUTThemeClassPropertiesApplier alloc] initWithProperties:properties valueTransformersOrRequiredClasses:transformersOrClasses applierBlock:applierBlock];
    [self aut_registerThemeClassApplier:applier];
    return applier;
}

+ (void)aut_registerThemeClassApplier:(id <AUTThemeClassApplicable>)applier
{
    [[self aut_classThemeClassAppliers] addObject:applier];
}

@end

@implementation NSObject (ThemingPrivate)

#pragma mark - Public

+ (void)aut_deregisterThemeClassApplier:(id <AUTThemeClassApplicable>)applier
{
    [[self aut_classThemeClassAppliers] removeObject:applier];
}

+ (NSArray *)aut_themeClassAppliers
{
    NSMutableArray *appliers = [[NSMutableArray alloc] initWithArray:[self aut_classThemeClassAppliers]];
    Class superclass = [self superclass];
    do {
        [appliers addObjectsFromArray:[superclass aut_classThemeClassAppliers]];
    } while ((superclass = [superclass superclass]));
    return appliers;
}

+ (NSMutableArray *)aut_classThemeClassAppliers
{
    NSMutableArray *appliers = objc_getAssociatedObject(self, _cmd);
    if (!appliers) {
        appliers = [NSMutableArray new];
        objc_setAssociatedObject(self, _cmd, appliers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return appliers;
}

@end
