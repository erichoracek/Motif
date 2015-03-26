//
//  AUTDynamicThemeApplier.m
//  Pods
//
//  Created by Eric Horacek on 12/29/14.
//
//

#import "AUTDynamicThemeApplier.h"
#import "AUTDynamicThemeApplier_Private.h"
#import "AUTTheme.h"
#import "AUTThemeClass.h"
#import "NSObject+ThemeClassName.h"

@implementation AUTDynamicThemeApplier

#pragma mark - NSObject

- (instancetype)init
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    // Ensure that exception is thrown when just `init` is called.
    self = [self initWithTheme:nil];
#pragma clang diagnostic pop
    return self;
}

#pragma mark - AUTDynamicThemeApplier

#pragma mark Public

- (instancetype)initWithTheme:(AUTTheme *)theme
{
    NSParameterAssert(theme);
    self = [super init];
    if (theme) {
        self.theme = theme;
    }
    return self;
}

- (void)setTheme:(AUTTheme *)theme
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

- (BOOL)applyClassWithName:(NSString *)className toObject:(id)object
{
    NSParameterAssert(className);
    NSParameterAssert(object);
    
    if (!className || !object) {
        return NO;
    }
    BOOL didApply = [self.theme applyClassWithName:className toObject:object];
    if (didApply) {
        [self addApplicantsObject:object];
    }
    return didApply;
}

#pragma mark Private

- (void)applyTheme:(AUTTheme *)theme toApplicants:(NSHashTable *)applicants
{
    for (NSObject *applicant in applicants) {
        [self applyClassWithName:applicant.aut_themeClassName toObject:applicant];
    }
}

- (void)addApplicantsObject:(id)object
{
    NSParameterAssert(object);
    [self.applicants addObject:object];
}

- (NSHashTable *)applicants
{
    if (!_applicants) {
        self.applicants = [NSHashTable weakObjectsHashTable];
    }
    return _applicants;
}

@end
