//
//  AUTThemeApplier.m
//  Pods
//
//  Created by Eric Horacek on 12/29/14.
//
//

#import "AUTThemeApplier.h"
#import "AUTThemeApplier+Private.h"
#import "AUTTheme.h"
#import "AUTThemeClass.h"
#import "AUTThemeClassApplicable.h"
#import "NSObject+ThemeClassAppliers.h"
#import "NSObject+ThemeClassAppliersPrivate.h"

@implementation AUTThemeApplier

#pragma mark Public

- (instancetype)initWithTheme:(AUTTheme *)theme
{
    self = [super init];
    if (theme) {
        self.theme = theme;
    }
    return self;
}

- (void)setTheme:(AUTTheme *)theme
{
    if (theme != _theme) {
        // The theme has just changed if there is an existing theme and it was just replaced
        BOOL shouldReapply = (_theme && theme);
        _theme = theme;
        if (shouldReapply) {
            [self applyThemeToPreviousApplicants];
        }
    }
}

- (void)applyClassWithName:(NSString *)className toObject:(id)object
{
    if (!className || !object) {
        return;
    }
    if (!self.theme) {
        return;
    }
    AUTThemeClass *class = [self.theme themeClassForName:className];
    if (!class) {
        return;
    }
    [self applyClass:class toObject:object];
}

#pragma mark Private

- (void)applyClass:(AUTThemeClass *)class toObject:(id)applicant
{
    NSParameterAssert(class);
    NSParameterAssert(applicant);
    
    [self addThemeApplicant:applicant forClassName:class.name];
    
    NSDictionary *properties = class.properties;
    NSMutableSet *unappliedProperties = [NSMutableSet setWithArray:properties.allKeys];
    
    // Apply each of the class appliers registered on the applicant's class
    for (id <AUTThemeClassApplicable> classApplier in [[applicant class] aut_themeClassAppliers]) {
        if ([classApplier shouldApplyClass:class]) {
            [classApplier applyClass:class toObject:applicant];
            NSSet *appliedProperties = [NSSet setWithArray:classApplier.properties];
            [unappliedProperties minusSet:appliedProperties];
        }
    }
    
    // If no appliers are found for properties specified in the class, attempt to set the property value via setValue:forKeyPath:
    for (NSString *property in unappliedProperties) {
        // Must be wrapped in try-catch, since setValue:forKeyPath: throws exceptions when keyPath doesn't exist
        @try {
            id value = properties[property];
            [applicant setValue:value forKeyPath:property];
        }
        @catch (NSException *exception) {
            NSString *className = NSStringFromClass([applicant class]);
            NSAssert3(NO, @"'%@' doesn't have a theme applier for the property '%@' or doesn't implement the keypath '%@'. You must support one of them.", className, property, property);
        }
    }
}

- (void)applyThemeToPreviousApplicants
{
    for (NSString *className in self.themeApplicants) {
        NSArray *applicants = [self themeApplicantsForClassName:className];
        for (id applicant in applicants) {
            [self applyClassWithName:className toObject:applicant];
        }
    }
}

- (void)addThemeApplicant:(id)object forClassName:(NSString *)className
{
    NSParameterAssert(object);
    NSParameterAssert(className);
    
    NSHashTable *applicants = self.themeApplicants[className];
    if (!applicants) {
        // Maintain a weak objects has table to ensure the applicants are not retained by the applier
        applicants = [NSHashTable weakObjectsHashTable];
        self.themeApplicants[className] = applicants;
    }
    [applicants addObject:object];
}

- (NSArray *)themeApplicantsForClassName:(NSString *)className
{
    NSParameterAssert(className);
    
    NSHashTable *applicants = self.themeApplicants[className];
    if (applicants) {
        NSArray *allObjects = applicants.allObjects;
        return (allObjects.count ? allObjects : nil);
    }
    return nil;
}

- (NSDictionary *)themeApplicants
{
    if (!_themeApplicants) {
        self.themeApplicants = [NSMutableDictionary new];
    }
    return _themeApplicants;
}

@end
