//
//  MTFDynamicThemeApplierSpec.m
//  Motif
//
//  Created by Eric Horacek on 1/7/16.
//  Copyright © 2016 Eric Horacek. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <Motif/Motif.h>
#import <Motif/NSString+ThemeSymbols.h>
#import <Motif/MTFDynamicThemeApplier_Private.h>

#import "MTFTestApplicants.h"

SpecBegin(MTFDynamicThemeApplier)

__block BOOL success;
__block NSError *error;
__block MTFTheme *theme;
__block MTFTheme *theme1;
__block MTFTheme *theme2;

beforeEach(^{
    success = NO;
    error = nil;
    theme = nil;
    theme1 = nil;
    theme2 = nil;
});

MTFTheme *(^themeFromDictionary)(NSDictionary *) = ^(NSDictionary *dictionary) {
    return [[MTFTheme alloc] initWithThemeDictionary:dictionary error:&error];
};

describe(@"initialization", ^{
    it(@"should raise when initialized via init", ^{
        expect(^{
            __unused id applier = [(id)[MTFDynamicThemeApplier alloc] init];
        }).to.raise(NSInternalInconsistencyException);
    });
});

describe(@"reapplication", ^{
    NSString *className = @".Class";
    NSString *property = NSStringFromSelector(@selector(stringValue));
    NSString *stringValue1 = @"value1";
    NSString *stringValue2 = @"value2";

    it(@"should occur when theme is changed", ^{
        theme1 = themeFromDictionary(@{
            className: @{ property: stringValue1 }
        });
        expect(theme1).to.beAnInstanceOf(MTFTheme.class);
        expect(error).to.beNil();

        theme2 = themeFromDictionary(@{
            className: @{ property: stringValue2 }
        });
        expect(theme2).to.beAnInstanceOf(MTFTheme.class);
        expect(error).to.beNil();

        MTFTestObjCClassPropertiesApplicant *applicant = [[MTFTestObjCClassPropertiesApplicant alloc] init];

        MTFDynamicThemeApplier *applier = [[MTFDynamicThemeApplier alloc] initWithTheme:theme1];
        success = [applier applyClassWithName:className.mtf_symbol to:applicant error:&error];
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        expect(applicant.stringValue).to.equal(stringValue1);

        success = [applier setTheme:theme2 error:&error];
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        expect(applicant.stringValue).to.equal(stringValue2);
    });

    it(@"should succeed if the theme is identical to the first", ^{
        theme = themeFromDictionary(@{
            className: @{ property: stringValue1 }
        });
        expect(theme).to.beAnInstanceOf(MTFTheme.class);
        expect(error).to.beNil();

        MTFTestObjCClassPropertiesApplicant *applicant = [[MTFTestObjCClassPropertiesApplicant alloc] init];

        MTFDynamicThemeApplier *applier = [[MTFDynamicThemeApplier alloc] initWithTheme:theme];
        success = [applier applyClassWithName:className.mtf_symbol to:applicant error:&error];
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        expect(applicant.stringValue).to.equal(stringValue1);

        success = [applier setTheme:theme error:&error];
        expect(success).to.beTruthy();
        expect(error).to.beNil();
    });

    it(@"should propagate errors when the theme is changed", ^{
        theme1 = themeFromDictionary(@{
            className: @{ property: stringValue1 }
        });
        expect(theme1).to.beAnInstanceOf(MTFTheme.class);
        expect(error).to.beNil();

        theme2 = themeFromDictionary(@{
            className: @{ @"invalid": @"invalid" }
        });
        expect(theme2).to.beAnInstanceOf(MTFTheme.class);
        expect(error).to.beNil();

        MTFTestObjCClassPropertiesApplicant *applicant = [[MTFTestObjCClassPropertiesApplicant alloc] init];

        MTFDynamicThemeApplier *applier = [[MTFDynamicThemeApplier alloc] initWithTheme:theme1];
        success = [applier applyClassWithName:className.mtf_symbol to:applicant error:&error];
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        expect(applicant.stringValue).to.equal(stringValue1);

        success = [applier setTheme:theme2 error:&error];
        expect(success).to.beFalsy();
        expect(error).notTo.beNil();

        expect(error.domain).to.equal(MTFErrorDomain);
        expect(error.code).to.equal(MTFErrorFailedToApplyTheme);
        expect(error.userInfo[MTFApplicantErrorKey]).to.beIdenticalTo(applicant);
        expect(error.userInfo[MTFThemeClassNameErrorKey]).to.equal(className.mtf_symbol);
    });
});

describe(@"memory management", ^{
    it(@"should not retain the object that a theme class is applied to", ^{
        NSString *className = @".Class";
        
        theme = themeFromDictionary(@{ className: @{} });
        expect(theme).to.beAnInstanceOf(MTFTheme.class);
        expect(error).to.beNil();

        NSObject *applicant = [[NSObject alloc] init];
        MTFDynamicThemeApplier *applier = [[MTFDynamicThemeApplier alloc]
            initWithTheme:theme];
        success = [applier applyClassWithName:className.mtf_symbol to:applicant error:&error];
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        NSHashTable *applicants = applier.applicants;
        expect(applicants).notTo.beNil();
        expect(applicants).to.haveACountOf(1);

        // Ensure that autoreleased tested reference to object does no stay
        // around and bump up the retain count of object for the duration of the
        // test scope.
        @autoreleasepool {
            expect(applicants).to.contain(applicant);
        }

        // Deallocate object that had theme applied to it.
        applicant = nil;
        
        // Must query `-[NSHashTable allObjects].count` because the hash table
        // contains a nil reference at this point and has yet to clean it up and
        // reconcile its count.
        expect(applicants.allObjects).to.haveACountOf(0);
    });
});

SpecEnd
