//
//  NSObject_ThemeClassAppliersSpec.m
//  Motif
//
//  Created by Eric Horacek on 1/10/16.
//  Copyright © 2016 Eric Horacek. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <Motif/Motif.h>
#import <Motif/MTFThemeConstant_Private.h>
#import <Motif/MTFThemeClass_Private.h>
#import <Motif/NSObject+ThemeClassAppliersPrivate.h>

#import "MTFTestApplicants.h"

SpecBegin(NSObject_ThemeClassAppliers)

__block BOOL success;
__block NSError *error;
__block id<MTFThemeClassApplicable> applier;
__block Class applicantClass;

beforeEach(^{
    success = NO;
    error = nil;
});

afterEach(^{
    [applicantClass mtf_deregisterThemeClassApplier:applier];
});

describe(@"-mtf_registerThemeProperty:forKeyPath:withValuesByKeyword:", ^{
    NSString *property = NSStringFromSelector(@selector(enumeration));
    NSString *value = @"2";
    NSString *invalidValue = @"4";

    beforeEach(^{
        applicantClass = MTFTestEnumerationPropertiesApplicant.class;
    });

    beforeEach(^{
        applier = [applicantClass
            mtf_registerThemeProperty:NSStringFromSelector(@selector(enumeration))
            forKeyPath:NSStringFromSelector(@selector(enumeration))
            withValuesByKeyword:@{
                @"1": @(MTFTestEnumeration1),
                @"2": @(MTFTestEnumeration2),
                @"3": @(MTFTestEnumeration3),
            }];
    });

    it(@"should set a value when it is present in a theme class", ^{
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            property: [[MTFThemeConstant alloc] initWithName:property rawValue:value referencedValue:nil]
        }];

        MTFTestEnumerationPropertiesApplicant *applicant = [[applicantClass alloc] init];
        NSSet *appliedProperties = [applier applyClass:class to:applicant error:&error];
        expect(appliedProperties).to.haveACountOf(1);
        expect(appliedProperties).to.contain(property);
        expect(error).to.beNil();

        expect(applicant.enumeration).to.equal(MTFTestEnumeration2);
    });

    it(@"should error when invoked with an invalid value", ^{
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            property: [[MTFThemeConstant alloc] initWithName:property rawValue:invalidValue referencedValue:nil]
        }];

        MTFTestEnumerationPropertiesApplicant *applicant = [[applicantClass alloc] init];
        NSSet *appliedProperties = [applier applyClass:class to:applicant error:&error];
        expect(appliedProperties).to.beNil();
        expect(error).notTo.beNil();
        expect(error.domain).to.equal(MTFErrorDomain);
        expect(error.code).to.equal(MTFErrorFailedToApplyTheme);
    });
});

SpecEnd

