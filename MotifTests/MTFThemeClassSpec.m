//
//  MTFThemeClassSpec.m
//  Motif
//
//  Created by Eric Horacek on 1/4/16.
//  Copyright © 2016 Eric Horacek. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <Motif/Motif.h>
#import <Motif/MTFThemeClass_Private.h>
#import <Motif/MTFThemeConstant_Private.h>
#import <Motif/NSString+ThemeSymbols.h>
#import <Motif/NSObject+ThemeClassAppliersPrivate.h>

#import "MTFTestApplicants.h"

SpecBegin(MTFThemeClass)

describe(@"initialization", ^{
    it(@"should raise when initialized via init", ^{
        expect(^{
            __unused id parser = [(id)[MTFThemeClass alloc] init];
        }).to.raise(NSInternalInconsistencyException);
    });
});

describe(@"application", ^{
    __block BOOL success;
    __block NSError *error;
    __block MTFTheme *theme;

    beforeEach(^{
        success = NO;
        error = nil;
        theme = nil;
    });

    MTFTheme *(^themeFromDictionary)(NSDictionary *) = ^(NSDictionary *dictionary) {
        return [[MTFTheme alloc] initWithThemeDictionary:dictionary error:&error];
    };

    NSString *className = @".Class";
    NSString *anotherClassName = @".AnotherClass";
    NSString *stringValue = @"string";
    NSNumber *numberValue = @1.0;
    CGSize sizeValue = (CGSize){ .width = 1.0, .height = 1.0 };
    CGPoint pointValue = (CGPoint){ .x = 1.0, .y = 1.0 };

    describe(@"of @property values in the Objective-C runtime", ^{
        it(@"should occur with Obj-C type values", ^{
            theme = themeFromDictionary(@{
                className: @{
                    NSStringFromSelector(@selector(stringValue)): stringValue,
                    NSStringFromSelector(@selector(numberValue)): numberValue,
                }
            });
            expect(theme).to.beAnInstanceOf(MTFTheme.class);
            expect(error).to.beNil();
            
            MTFTestObjCClassPropertiesApplicant *applicant = [[MTFTestObjCClassPropertiesApplicant alloc] init];
            success = [theme applyClassWithName:className.mtf_symbol to:applicant error:&error];
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect(applicant.stringValue).to.equal(stringValue);
            expect(applicant.numberValue).to.equal(numberValue);
        });

        it(@"should occur with C type values", ^{
            theme = themeFromDictionary(@{
                className: @{
                    NSStringFromSelector(@selector(charValue)): numberValue,
                    NSStringFromSelector(@selector(intValue)): numberValue,
                    NSStringFromSelector(@selector(shortValue)): numberValue,
                    NSStringFromSelector(@selector(longValue)): numberValue,
                    NSStringFromSelector(@selector(longLongValue)): numberValue,
                    NSStringFromSelector(@selector(unsignedCharValue)): numberValue,
                    NSStringFromSelector(@selector(unsignedIntValue)): numberValue,
                    NSStringFromSelector(@selector(unsignedShortValue)): numberValue,
                    NSStringFromSelector(@selector(unsignedLongValue)): numberValue,
                    NSStringFromSelector(@selector(unsignedLongLongValue)): numberValue,
                    NSStringFromSelector(@selector(floatValue)): numberValue,
                    NSStringFromSelector(@selector(doubleValue)): numberValue,
                    NSStringFromSelector(@selector(boolValue)): numberValue,
                    NSStringFromSelector(@selector(sizeValue)): numberValue,
                    NSStringFromSelector(@selector(pointValue)): numberValue,
                }
            });
            expect(theme).to.beAnInstanceOf(MTFTheme.class);
            expect(error).to.beNil();
            
            MTFTestCTypePropertiesApplicant *applicant = [[MTFTestCTypePropertiesApplicant alloc] init];
            success = [theme applyClassWithName:className.mtf_symbol to:applicant error:&error];
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect(applicant.charValue).to.equal(numberValue);
            expect(applicant.intValue).to.equal(numberValue);
            expect(applicant.shortValue).to.equal(numberValue);
            expect(applicant.longValue).to.equal(numberValue);
            expect(applicant.longLongValue).to.equal(numberValue);
            expect(applicant.unsignedCharValue).to.equal(numberValue);
            expect(applicant.unsignedIntValue).to.equal(numberValue);
            expect(applicant.unsignedShortValue).to.equal(numberValue);
            expect(applicant.unsignedLongValue).to.equal(numberValue);
            expect(applicant.unsignedLongLongValue).to.equal(numberValue);
            expect(applicant.floatValue).to.equal(numberValue);
            expect(applicant.doubleValue).to.equal(numberValue);
            expect(applicant.boolValue).to.equal(numberValue);
            expect(applicant.sizeValue).to.equal(sizeValue);
            expect(applicant.sizeValue).to.equal(pointValue);
        });

        it(@"should occur with an inherited property", ^{
            theme = themeFromDictionary(@{
                className: @{
                    NSStringFromSelector(@selector(superclassProperty)): numberValue,
                }
            });
            expect(theme).to.beAnInstanceOf(MTFTheme.class);
            expect(error).to.beNil();
            
            MTFTestSubclassPropertyApplicant *applicant = [[MTFTestSubclassPropertyApplicant alloc] init];
            success = [theme applyClassWithName:className.mtf_symbol to:applicant error:&error];
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect(applicant.superclassProperty).to.equal(numberValue);
        });

        it(@"should apply a MTFThemeClass property", ^{
            theme = themeFromDictionary(@{
                className: @{
                    NSStringFromSelector(@selector(themeClass)): anotherClassName,
                },
                anotherClassName: @{},
            });
            expect(theme).to.beAnInstanceOf(MTFTheme.class);
            expect(error).to.beNil();
            
            MTFTestThemeClassPropertyApplicant *applicant = [[MTFTestThemeClassPropertyApplicant alloc] init];
            success = [theme applyClassWithName:className.mtf_symbol to:applicant error:&error];
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect(applicant.themeClass).notTo.beNil();
            expect(applicant.themeClass.name).to.equal(anotherClassName.mtf_symbol);
        });

        it(@"should apply a MTFThemeClass to a property", ^{
            theme = themeFromDictionary(@{
                className: @{
                    NSStringFromSelector(@selector(nestedApplicant)): anotherClassName,
                },
                anotherClassName: @{
                    NSStringFromSelector(@selector(stringValue)): stringValue,
                    NSStringFromSelector(@selector(numberValue)): numberValue,
                },
            });
            expect(theme).to.beAnInstanceOf(MTFTheme.class);
            expect(error).to.beNil();
            
            MTFTestThemeClassNestedPropertyApplicant *applicant = [[MTFTestThemeClassNestedPropertyApplicant alloc] init];
            applicant.nestedApplicant = [[MTFTestObjCClassPropertiesApplicant alloc] init];
            expect(applicant.nestedApplicant).notTo.beNil();

            success = [theme applyClassWithName:className.mtf_symbol to:applicant error:&error];
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect(applicant.nestedApplicant.stringValue).to.equal(stringValue);
            expect(applicant.nestedApplicant.numberValue).to.equal(numberValue);
        });

        it(@"should propagate errors that occur when applying a MTFThemeClass to a property", ^{
            theme = themeFromDictionary(@{
                className: @{
                    NSStringFromSelector(@selector(nestedApplicant)): anotherClassName,
                },
                anotherClassName: @{ @"invalid": @"invalid" },
            });
            expect(theme).to.beAnInstanceOf(MTFTheme.class);
            expect(error).to.beNil();
            
            MTFTestThemeClassNestedPropertyApplicant *applicant = [[MTFTestThemeClassNestedPropertyApplicant alloc] init];
            applicant.nestedApplicant = [[MTFTestObjCClassPropertiesApplicant alloc] init];
            expect(applicant.nestedApplicant).notTo.beNil();

            success = [theme applyClassWithName:className.mtf_symbol to:applicant error:&error];
            expect(success).to.beFalsy();
            expect(error).notTo.beNil();

            expect(error.domain).to.equal(MTFErrorDomain);
            expect(error.code).to.equal(MTFErrorFailedToApplyTheme);
            expect(error.userInfo[MTFApplicantErrorKey]).to.beIdenticalTo(applicant);
            expect(error.userInfo[MTFThemeClassNameErrorKey]).to.equal(className.mtf_symbol);
            expect(error.userInfo[MTFUnderlyingErrorsErrorKey]).to.haveACountOf(1);

            NSError *underlyingError = [error.userInfo[MTFUnderlyingErrorsErrorKey] firstObject];
            expect(underlyingError.domain).to.equal(MTFErrorDomain);
            expect(underlyingError.code).to.equal(MTFErrorFailedToApplyTheme);
            expect(underlyingError.userInfo[MTFApplicantErrorKey]).to.beIdenticalTo(applicant.nestedApplicant);
            expect(underlyingError.userInfo[MTFThemeClassNameErrorKey]).to.equal(anotherClassName.mtf_symbol);
        });

        it(@"should propagate errors from value transformers", ^{
            theme = themeFromDictionary(@{
                className: @{
                    NSStringFromSelector(@selector(pointValue)): @[ @"invalid" ],
                }
            });
            expect(theme).to.beAnInstanceOf(MTFTheme.class);
            expect(error).to.beNil();
            
            MTFTestCTypePropertiesApplicant *applicant = [[MTFTestCTypePropertiesApplicant alloc] init];
            success = [theme applyClassWithName:className.mtf_symbol to:applicant error:&error];
            expect(success).to.beFalsy();
            expect(error).notTo.beNil();

            expect(error.domain).to.equal(MTFErrorDomain);
            expect(error.code).to.equal(MTFErrorFailedToApplyTheme);
            expect(error.userInfo[MTFApplicantErrorKey]).to.beIdenticalTo(applicant);
            expect(error.userInfo[MTFThemeClassNameErrorKey]).to.equal(className.mtf_symbol);
            expect(error.userInfo[MTFUnderlyingErrorsErrorKey]).to.haveACountOf(1);
        });
    });

    describe(@"using registered appliers", ^{
        __block id<MTFThemeClassApplicable> applier;
        NSString *property = @"property";
        NSString *value = @"value";

        beforeEach(^{
            applier = nil;
        });

        afterEach(^{
            [NSObject mtf_deregisterThemeClassApplier:applier];
        });

        it(@"should occur", ^{
            __block BOOL didInvokeApplierBlock = NO;

            theme = themeFromDictionary(@{ className: @{ property: value } });
            expect(theme).to.beAnInstanceOf(MTFTheme.class);
            expect(error).to.beNil();

            applier = [NSObject
                mtf_registerThemeProperty:property
                applierBlock:^(id propertyValue, id objectToTheme, NSError **error) {
                    didInvokeApplierBlock = YES;
                    return YES;
                }];

            NSObject *applicant = [[NSObject alloc] init];
            success = [theme applyClassWithName:className.mtf_symbol to:applicant error:&error];
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect(didInvokeApplierBlock).to.beTruthy();
        });

        it(@"should propagate errors from appliers", ^{
            theme = themeFromDictionary(@{ className: @{ property: value } });
            expect(theme).to.beAnInstanceOf(MTFTheme.class);
            expect(error).to.beNil();

            NSString *description = [NSUUID UUID].UUIDString;

            applier = [NSObject
                mtf_registerThemeProperty:property
                applierBlock:^(id propertyValue, id objectToTheme, NSError **error) {
                    return [NSObject mtf_populateApplierError:error withDescription:description];
                }];

            NSObject *applicant = [[NSObject alloc] init];
            success = [theme applyClassWithName:className.mtf_symbol to:applicant error:&error];
            expect(success).to.beFalsy();
            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFErrorDomain);
            expect(error.code).to.equal(MTFErrorFailedToApplyTheme);
            expect(error.userInfo[MTFApplicantErrorKey]).to.beIdenticalTo(applicant);
            expect(error.userInfo[MTFUnappliedPropertiesErrorKey]).to.equal(@{ property: value });
            expect(error.userInfo[MTFThemeClassNameErrorKey]).to.equal(className.mtf_symbol);
            expect(error.userInfo[MTFUnderlyingErrorsErrorKey]).to.haveACountOf(1);
            expect([[error.userInfo[MTFUnderlyingErrorsErrorKey] firstObject] localizedDescription]).to.equal(description);
        });
    });

    describe(@"repeated applications", ^{
        it(@"should not reinvoke the setter when applying the same class", ^{
            theme = themeFromDictionary(@{
                className: @{
                    NSStringFromSelector(@selector(stringValue)): stringValue,
                }
            });
            expect(theme).to.beAnInstanceOf(MTFTheme.class);
            expect(error).to.beNil();
            
            MTFTestSetterCountingApplicant *applicant = [[MTFTestSetterCountingApplicant alloc] init];
            success = [theme applyClassWithName:className.mtf_symbol to:applicant error:&error];
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect(applicant.stringValue).to.equal(stringValue);
            expect(applicant.applications).to.equal(1);

            success = [theme applyClassWithName:className.mtf_symbol to:applicant error:&error];
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect(applicant.stringValue).to.equal(stringValue);
            expect(applicant.applications).to.equal(1);
        });
    });

    describe(@"failures", ^{
        it(@"should fail when a property is unapplied", ^{
            theme = themeFromDictionary(@{
                className: @{
                    NSStringFromSelector(@selector(stringValue)): stringValue,
                }
            });
            expect(theme).to.beAnInstanceOf(MTFTheme.class);
            expect(error).to.beNil();
            
            NSObject *applicant = [[NSObject alloc] init];
            success = [theme applyClassWithName:className.mtf_symbol to:applicant error:&error];
            expect(success).to.beFalsy();
            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFErrorDomain);
            expect(error.code).to.equal(MTFErrorFailedToApplyTheme);
            expect(error.userInfo[MTFApplicantErrorKey]).to.beIdenticalTo(applicant);
            expect(error.userInfo[MTFUnappliedPropertiesErrorKey]).to.equal(@{ NSStringFromSelector(@selector(stringValue)): stringValue });
            expect(error.userInfo[MTFThemeClassNameErrorKey]).to.equal(className.mtf_symbol);
        });
    });
});

describe(@"equality", ^{
    NSString *name = @"name";
    NSString *anotherName = @"anotherName";
    NSString *key = @"key";
    NSString *rawValue = @"rawValue";
    NSString *mappedValue = @"mappedValue";
    NSString *anotherMappedValue = @"anotherMappedValue";

    it(@"should be equal to another class with equal properties", ^{
        MTFThemeConstant *constant1 = [[MTFThemeConstant alloc]
            initWithName:key
            rawValue:rawValue
            mappedValue:mappedValue];

        MTFThemeConstant *constant2 = [[MTFThemeConstant alloc]
            initWithName:key
            rawValue:rawValue
            mappedValue:mappedValue];

        MTFThemeClass *class1 = [[MTFThemeClass alloc]
            initWithName:name
            propertiesConstants:@{ key: constant1 }];

        MTFThemeClass *class2 = [[MTFThemeClass alloc]
            initWithName:name
            propertiesConstants:@{ key: constant2 }];

        expect(class1).to.equal(class2);
    });

    it(@"should not be equal to another class with a different name", ^{
        MTFThemeClass *class1 = [[MTFThemeClass alloc]
            initWithName:name
            propertiesConstants:@{}];

        MTFThemeClass *class2 = [[MTFThemeClass alloc]
            initWithName:anotherName
            propertiesConstants:@{}];

        expect(class1).notTo.equal(class2);
    });

    it(@"should not be equal to another class with different properties", ^{
        MTFThemeConstant *constant1 = [[MTFThemeConstant alloc]
            initWithName:key
            rawValue:rawValue
            mappedValue:mappedValue];

        MTFThemeConstant *constant2 = [[MTFThemeConstant alloc]
            initWithName:key
            rawValue:rawValue
            mappedValue:anotherMappedValue];

        MTFThemeClass *class1 = [[MTFThemeClass alloc]
            initWithName:name
            propertiesConstants:@{ key: constant1 }];

        MTFThemeClass *class2 = [[MTFThemeClass alloc]
            initWithName:name
            propertiesConstants:@{ key: constant2 }];

        expect(class1).notTo.equal(class2);
    });
});

SpecEnd
