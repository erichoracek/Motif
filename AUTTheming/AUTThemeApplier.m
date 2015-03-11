//
//  AUTThemeApplier.m
//  Pods
//
//  Created by Eric Horacek on 12/29/14.
//
//

#import <libextobjc/EXTRuntimeExtensions.h>
#import "AUTThemeApplier.h"
#import "AUTThemeApplier_Private.h"
#import "AUTTheme.h"
#import "AUTThemeClass.h"
#import "AUTThemeClassApplicable.h"
#import "NSObject+ThemeClassAppliers.h"
#import "NSObject+ThemeClassAppliersPrivate.h"
#import "AUTReverseTransformedValueClass.h"
#import "NSValueTransformer+TypeFiltering.h"

@implementation AUTThemeApplier

#pragma mark Public

- (instancetype)init
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    // Ensure that exception is thrown when just `init` is called.
    self = [self initWithTheme:nil];
#pragma clang diagnostic pop
    return self;
}

- (instancetype)initWithTheme:(AUTTheme *)theme
{
    NSParameterAssert(theme);
    self = [super init];
    if (theme) {
        self.theme = theme;
    }
    return self;
}

- (void)setTheme:(AUTTheme *)theme __attribute__ ((nonnull))
{
    NSAssert(theme, @"The theme property is not optional.");
    if (theme == _theme) {
        return;
    }
    // The theme has just changed if there is an existing theme and it was just replaced
    BOOL shouldReapply = (_theme && theme);
    _theme = theme;
    if (shouldReapply) {
        [self applyTheme:theme toApplicants:self.applicants];
    }
}

- (void)applyClassWithName:(NSString *)className toObject:(id)object
{
    if (!className || !object) {
        return;
    }
    [self applyClassWithName:className fromTheme:self.theme toApplicant:object];
}

#pragma mark Private

- (void)applyClassWithName:(NSString *)className fromTheme:(AUTTheme *)theme toApplicant:(id)applicant
{
    if (!theme) {
        return;
    }
    AUTThemeClass *class = [theme themeClassForName:className];
    if (!class) {
        return;
    }
    [self applyClass:class toApplicant:applicant];
}

- (void)applyClass:(AUTThemeClass *)class toApplicant:(id)applicant
{
    NSParameterAssert(class);
    NSParameterAssert(applicant);
    
    [self addApplicant:applicant forClassWithName:class.name];
    
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
    
    // If no theme class appliers were found, attempt to locate a property on the applicant's class with the same name
    // as the theme class property. If one is found, us KVC to set its value.
    for (NSString *property in [unappliedProperties copy]) {
        
        // Traverse the class hierarchy from the applicant's class up by superclass
        Class applicantClass = [applicant class];
        do {
            // Locate any properties of the same name on the applicant's class hierarchy
            objc_property_t objc_property = class_getProperty(applicantClass, property.UTF8String);
            if (objc_property == NULL) {
                continue;
            }
            // Create a property attributes struct to figure out attributes of the properties
            ext_propertyAttributes *propertyAttributes = ext_copyPropertyAttributes(objc_property);
            if (propertyAttributes == NULL) {
                continue;
            }
            
            Class propertyClass = propertyAttributes->objectClass;
            const char *propertyObjCType = propertyAttributes->type;
            id value = properties[property];
            
            // Locate a value transformer that can be used to transform from the theme class property value to the
            // type of the property that was located
            NSValueTransformer *valueTransformer;
            if (propertyClass) {
                valueTransformer = [NSValueTransformer aut_valueTransformerForTransformingObject:value toClass:propertyClass];
            } else if (propertyObjCType) {
                valueTransformer = [NSValueTransformer aut_valueTransformerForTransformingObject:value toObjCType:propertyObjCType];
            }
            
            free(propertyAttributes);
            
            // If a value transformer is found, use KVC to set the transformed theme class property value on the
            // applicant object, and break out of this loop
            if (valueTransformer) {
                id transformedValue = [valueTransformer transformedValue:value];
                [applicant setValue:transformedValue forKey:property];
                [unappliedProperties minusSet:[NSSet setWithObject:property]];
                break;
            }
            
        } while ((applicantClass = [applicantClass superclass]));
    }
    
    // If no appliers are found for properties specified in the class, attempt to set the property value via setValue:forKeyPath:
    for (NSString *property in [unappliedProperties copy]) {
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

- (void)applyTheme:(AUTTheme *)theme toApplicants:(NSDictionary *)applicants
{
    for (NSString *className in applicants) {
        NSArray *classApplicants = [self applicantsForClassWithName:className fromApplicants:applicants];
        for (id classApplicant in classApplicants) {
            [self applyClassWithName:className toObject:classApplicant];
        }
    }
}

#pragma mark Theme Applicants

- (NSArray *)applicantsForClassWithName:(NSString *)className fromApplicants:(NSDictionary *)applicants
{
    NSParameterAssert(className);
    NSParameterAssert(applicants);
    
    NSHashTable *classApplicants = applicants[className];
    if (classApplicants) {
        NSArray *allClassApplicants = classApplicants.allObjects;
        return (allClassApplicants.count ? allClassApplicants : nil);
    }
    return nil;
}

- (void)addApplicant:(id)applicant forClassWithName:(NSString *)className
{
    NSParameterAssert(applicant);
    NSParameterAssert(className);
    
    NSHashTable *applicants = self.applicants[className];
    if (!applicants) {
        // Maintain a weak objects hash table to ensure the applicants are not retained by this applier instance
        applicants = [NSHashTable weakObjectsHashTable];
        self.applicants[className] = applicants;
    }
    [applicants addObject:applicant];
}

- (NSDictionary *)applicants
{
    if (!_applicants) {
        self.applicants = [NSMutableDictionary new];
    }
    return _applicants;
}

@end
