//
//  NSObject+ThemeAppliers.m
//  Pods
//
//  Created by Eric Horacek on 12/25/14.
//
//

#import <objc/runtime.h>
#import "NSObject+ThemeAppliers.h"
#import "NSObject+ThemingPrivate.h"
#import "AUTThemeApplier.h"

@implementation NSObject (ThemeAppliers)

#pragma mark - Public

+ (id)aut_registerThemeClassApplier:(AUTThemeClassApplierBlock)applierBlock
{
    AUTThemeClassApplier *applier = [[AUTThemeClassApplier alloc] initWithClassApplier:applierBlock];
    [self aut_registerThemeApplier:applier];
    return applier;
}

+ (id)aut_registerThemeProperty:(NSString *)property applier:(AUTThemePropertyApplierBlock)applierBlock
{
    AUTThemeClassPropertyApplier *applier = [[AUTThemeClassPropertyApplier alloc] initWithProperty:property applier:applierBlock valueTransformerName:nil requiredClass:nil];
    [self aut_registerThemeApplier:applier];
    return applier;
}

+ (id)aut_registerThemeProperty:(NSString *)property requiringValueOfClass:(Class)valueClass applier:(AUTThemePropertyApplierBlock)applierBlock
{
    AUTThemeClassPropertyApplier *applier = [[AUTThemeClassPropertyApplier alloc] initWithProperty:property applier:applierBlock valueTransformerName:nil requiredClass:valueClass];
    [self aut_registerThemeApplier:applier];
    return applier;
}

+ (id)aut_registerThemeProperty:(NSString *)property valueTransformerName:(NSString *)transformerName applier:(AUTThemePropertyApplierBlock)applierBlock
{
    AUTThemeClassPropertyApplier *applier = [[AUTThemeClassPropertyApplier alloc] initWithProperty:property applier:applierBlock valueTransformerName:transformerName requiredClass:nil];
    [self aut_registerThemeApplier:applier];
    return applier;
}

+ (id)aut_registerThemeProperties:(NSArray *)properties applier:(AUTThemePropertiesApplierBlock)applierBlock
{
    AUTThemeClassPropertiesApplier *applier = [[AUTThemeClassPropertiesApplier alloc] initWithProperties:properties valueTransformersOrRequiredClasses:nil applier:applierBlock];
    [self aut_registerThemeApplier:applier];
    return applier;
}

+ (id)aut_registerThemeProperties:(NSArray *)properties valueTransformerNamesOrRequiredClasses:(NSArray *)transformersOrClasses applier:(AUTThemePropertiesApplierBlock)applierBlock
{
    AUTThemeClassPropertiesApplier *applier = [[AUTThemeClassPropertiesApplier alloc] initWithProperties:properties valueTransformersOrRequiredClasses:transformersOrClasses applier:applierBlock];
    [self aut_registerThemeApplier:applier];
    return applier;
}

+ (void)aut_registerThemeApplier:(id <AUTThemeClassApplicable>)applier
{
    [[self aut_classThemeAppliers] addObject:applier];
}

@end

@implementation NSObject (ThemingPrivate)

#pragma mark - Public

+ (void)aut_deregisterThemeApplier:(id <AUTThemeClassApplicable>)applier
{
    [[self aut_classThemeAppliers] removeObject:applier];
}

+ (NSArray *)aut_themeAppliers;
{
    NSMutableArray *appliers = [[NSMutableArray alloc] initWithArray:[self aut_classThemeAppliers]];
    Class superclass = [self superclass];
    do {
        [appliers addObjectsFromArray:[superclass aut_classThemeAppliers]];
    } while ((superclass = [superclass superclass]));
    return appliers;
}

+ (NSMutableArray *)aut_classThemeAppliers
{
    NSMutableArray *appliers = objc_getAssociatedObject(self, _cmd);
    if (!appliers) {
        appliers = [NSMutableArray new];
        objc_setAssociatedObject(self, _cmd, appliers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return appliers;
}

@end
