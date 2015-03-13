//
//  AUTThemeApplier.m
//  Pods
//
//  Created by Eric Horacek on 12/29/14.
//
//

#import "AUTDynamicThemeApplier.h"
#import "AUTDynamicThemeApplier_Private.h"
#import "AUTTheme.h"
#import "AUTThemeClass.h"

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

#pragma mark - AUTThemeApplier

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

- (BOOL)applyClassWithName:(NSString *)className toObject:(id)object
{
    if (!className || !object) {
        return NO;
    }
    BOOL didApply = [self.theme applyClassWithName:className toObject:object];
    if (didApply) {
        [self addApplicant:object forClassWithName:className];
    }
    return didApply;
}

#pragma mark Private

- (void)applyTheme:(AUTTheme *)theme toApplicants:(NSDictionary *)applicants
{
    for (NSString *className in applicants) {
        NSArray *classApplicants = [self applicantsForClassWithName:className fromApplicants:applicants];
        for (id classApplicant in classApplicants) {
            [self applyClassWithName:className toObject:classApplicant];
        }
    }
}

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
