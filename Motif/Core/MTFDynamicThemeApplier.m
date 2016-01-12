//
//  MTFDynamicThemeApplier.m
//  Motif
//
//  Created by Eric Horacek on 12/29/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "MTFDynamicThemeApplier.h"
#import "MTFDynamicThemeApplier_Private.h"
#import "MTFTheme.h"
#import "MTFThemeClass.h"
#import "NSObject+ThemeClass.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MTFDynamicThemeApplier

#pragma mark - Lifecycle

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Use the designated initializer instead" userInfo:nil];
}

- (instancetype)initWithTheme:(MTFTheme *)theme {
    NSParameterAssert(theme != nil);

    self = [super init];

    _theme = theme;
    _applicants = [NSHashTable weakObjectsHashTable];

    return self;
}

#pragma mark - MTFDynamicThemeApplier

#pragma mark Public

- (BOOL)setTheme:(MTFTheme *)theme error:(NSError **)error {
    NSParameterAssert(theme != nil);
    
    if (theme == _theme) return YES;

    _theme = theme;

    return [self applyTheme:theme toApplicants:self.applicants error:error];
}

#pragma mark Private

- (BOOL)applyTheme:(MTFTheme *)theme toApplicants:(NSHashTable *)applicants error:(NSError **)error {
    NSParameterAssert(theme != nil);
    NSParameterAssert(applicants != nil);

    BOOL themeSuccess = YES;

    for (NSObject *applicant in applicants) {
        BOOL classSuccess = [self
            applyClassWithName:applicant.mtf_themeClassName
            to:applicant
            error:error];

        if (!classSuccess) {
            themeSuccess = NO;
        }
    }

    return themeSuccess;
}

#pragma mark - MTFDynamicThemeApplier <MTFThemeApplier>

- (BOOL)applyClassWithName:(NSString *)className to:(id)applicant error:(NSError **)error {
    NSParameterAssert(className != nil);
    NSParameterAssert(applicant != nil);

    if ([self.theme applyClassWithName:className to:applicant error:error]) {
        [self.applicants addObject:applicant];

        return YES;
    }

    return NO;
}

@end

NS_ASSUME_NONNULL_END
