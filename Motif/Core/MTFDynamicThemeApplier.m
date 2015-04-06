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
#import "NSObject+ThemeClassName.h"

@implementation MTFDynamicThemeApplier

#pragma mark - NSObject

- (instancetype)init {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    // Ensure that exception is thrown when just `init` is called.
    return [self initWithTheme:nil];
#pragma clang diagnostic pop
}

#pragma mark - MTFDynamicThemeApplier

#pragma mark Public

- (instancetype)initWithTheme:(MTFTheme *)theme {
    NSParameterAssert(theme);
    self = [super init];
    if (theme) {
        _theme = theme;
    }
    return self;
}

- (void)setTheme:(MTFTheme *)theme {
    NSAssert(theme, @"The theme property is not optional.");
    
    if (theme == _theme) {
        return;
    }
    // The theme has just changed if there is an existing theme and it was just
    // replaced
    BOOL shouldReapply = (_theme && theme);
    _theme = theme;
    if (shouldReapply) {
        [self applyTheme:theme toApplicants:self.applicants];
    }
}

- (BOOL)applyClassWithName:(NSString *)className toObject:(id)object {
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

- (void)applyTheme:(MTFTheme *)theme toApplicants:(NSHashTable *)applicants {
    for (NSObject *applicant in applicants) {
        [self
            applyClassWithName:applicant.mtf_themeClassName
            toObject:applicant];
    }
}

- (void)addApplicantsObject:(id)object {
    NSParameterAssert(object);
    [self.applicants addObject:object];
}

- (NSHashTable *)applicants {
    if (!_applicants) {
        self.applicants = NSHashTable.weakObjectsHashTable;
    }
    return _applicants;
}

@end
