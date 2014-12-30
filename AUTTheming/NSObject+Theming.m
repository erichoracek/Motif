//
//  NSObject+Theming.m
//  Pods
//
//  Created by Eric Horacek on 12/25/14.
//
//

#import <objc/runtime.h>
#import "NSObject+Theming.h"
#import "NSObject+ThemingPrivate.h"
#import "AUTTheme.h"
#import "AUTThemeClass.h"
#import "AUTThemeApplier.h"

static char ThemeClassName;
static char Theme;

@implementation NSObject (Theming)

@dynamic aut_themeClassName;
@dynamic aut_theme;

#pragma mark - Public

#pragma mark Theme Class Name Property

- (NSString *)aut_themeClassName
{
    return objc_getAssociatedObject(self, &ThemeClassName);
}

- (void)aut_setThemeClassName:(NSString *)name
{
    objc_setAssociatedObject(self, &ThemeClassName, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark Theme Property

- (AUTTheme *)aut_theme
{
    return objc_getAssociatedObject(self, &Theme);
}

- (void)aut_setTheme:(AUTTheme *)theme
{
    objc_setAssociatedObject(self, &Theme, theme, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark Theme Application

- (void)aut_applyTheme:(AUTTheme *)theme
{
    NSParameterAssert(theme);
    self.aut_theme = theme;
    [self aut_applyTheme];
}

- (void)aut_applyThemeClassWithName:(NSString *)class
{
    NSParameterAssert(class);
    self.aut_themeClassName = class;
    [self aut_applyTheme];
}

- (void)aut_applyThemeClassWithName:(NSString *)class fromTheme:(AUTTheme *)theme
{
    NSParameterAssert(class);
    NSParameterAssert(theme);
    self.aut_theme = theme;
    self.aut_themeClassName = class;
    [self aut_applyTheme];
}

- (void)aut_applyTheme
{
    NSAssert(self.aut_theme, @"Must have a value for `aut_theme` to apply a theme.");
    NSAssert(self.aut_themeClassName, @"Must have a value for `aut_themeClassName` to apply a theme.");
    
    AUTThemeClass *class = [self.aut_theme themeClassForName:self.aut_themeClassName];
    NSAssert(class, @"No theme class found for the class name '%@'", self.aut_themeClassName);
    
    NSDictionary *valuesForProperties = class.properties;
    NSMutableSet *unappliedProperties = [NSMutableSet setWithArray:valuesForProperties.allKeys];
    
    for (id <AUTThemeClassApplicable> classApplier in [[self class] aut_themeAppliers]) {
        if ([classApplier shouldApplyClass:class]) {
            [classApplier applyClass:class fromTheme:self.aut_theme toObject:self];
            NSSet *appliedProperties = [NSSet setWithArray:classApplier.properties];
            [unappliedProperties minusSet:appliedProperties];
        }
    }
    
    // If no appliers are found for properties specified in the class, attempt to set the property value via setValue:forKeyPath:
    for (NSString *property in unappliedProperties) {
        // Must be wrapped in try-catch, since setValue:forKeyPath: throws exceptions when keyPath doesn't exist
        @try {
            id value = valuesForProperties[property];
            [self setValue:value forKeyPath:property];
        }
        @catch (NSException *exception) {
            NSString *className = NSStringFromClass([self class]);
            NSAssert3(NO, @"'%@' doesn't have a theme applier for the property '%@' or doesn't implement the keypath '%@'. You must support one of them.", className, property, property);
        }
    }
}

@end
