//
//  MTFScreenBrightnessThemeApplierSpec.m
//  Motif
//
//  Created by Eric Horacek on 1/10/16.
//  Copyright © 2016 Eric Horacek. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <Motif/Motif.h>
#import <Motif/NSString+ThemeSymbols.h>

#import "MTFTestScreen.h"
#import "MTFTestApplicants.h"

SpecBegin(MTFScreenBrightnessThemeApplier)

__block BOOL success;
__block NSError *error;
__block UIScreen *screen;
__block MTFTheme *lightTheme;
__block MTFTheme *darkTheme;

NSString *className = @".Class";
NSString *property = NSStringFromSelector(@selector(stringValue));
NSString *lightStringValue = @"value1";
NSString *darkStringValue = @"value2";

MTFTheme *(^themeFromDictionary)(NSDictionary *) = ^(NSDictionary *dictionary) {
    return [[MTFTheme alloc] initWithThemeDictionary:dictionary error:&error];
};

beforeEach(^{
    success = NO;
    error = nil;

    screen = [[MTFTestScreen alloc] init];

    lightTheme = themeFromDictionary(@{
        className: @{ property: lightStringValue }
    });
    expect(lightTheme).to.beAnInstanceOf(MTFTheme.class);
    expect(error).to.beNil();

    darkTheme = themeFromDictionary(@{
        className: @{ property: darkStringValue }
    });
    expect(darkTheme).to.beAnInstanceOf(MTFTheme.class);
    expect(error).to.beNil();
});

describe(@"initialization", ^{
    it(@"should initialize", ^{
        MTFScreenBrightnessThemeApplier *applier = [[MTFScreenBrightnessThemeApplier alloc]
            initWithLightTheme:lightTheme
            darkTheme:darkTheme];

        expect(applier).to.beAnInstanceOf(MTFScreenBrightnessThemeApplier.class);
    });

    it(@"should raise when initialized via initWithTheme:", ^{
        expect(^{
            __unused id applier = [(id)[MTFScreenBrightnessThemeApplier alloc] initWithTheme:lightTheme];
        }).to.raise(NSInternalInconsistencyException);
    });
});

describe(@"theme application upon initialization", ^{
    it(@"should occur when the screen is light", ^{
        // Default to light theme
        MTFTestScreenBrightness = 1.0f;

        MTFScreenBrightnessThemeApplier *applier = [[MTFScreenBrightnessThemeApplier alloc]
            initWithScreen:screen
            lightTheme:lightTheme
            darkTheme:darkTheme];

        expect(applier).to.beAnInstanceOf(MTFScreenBrightnessThemeApplier.class);

        MTFTestObjCClassPropertiesApplicant *applicant = [[MTFTestObjCClassPropertiesApplicant alloc] init];
        success = [applier applyClassWithName:className.mtf_symbol to:applicant error:&error];
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        expect(applicant.stringValue).to.equal(lightStringValue);
    });

    it(@"should occur when the screen is dark", ^{
        // Default to light theme
        MTFTestScreenBrightness = 0.0f;

        MTFScreenBrightnessThemeApplier *applier = [[MTFScreenBrightnessThemeApplier alloc]
            initWithScreen:screen
            lightTheme:lightTheme
            darkTheme:darkTheme];

        expect(applier).to.beAnInstanceOf(MTFScreenBrightnessThemeApplier.class);

        MTFTestObjCClassPropertiesApplicant *applicant = [[MTFTestObjCClassPropertiesApplicant alloc] init];
        success = [applier applyClassWithName:className.mtf_symbol to:applicant error:&error];
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        expect(applicant.stringValue).to.equal(darkStringValue);
    });
});

describe(@"reapplication", ^{
    it(@"should occur when the screen brightness is changed", ^{
        // Default to light theme
        MTFTestScreenBrightness = 1.0f;

        MTFScreenBrightnessThemeApplier *applier = [[MTFScreenBrightnessThemeApplier alloc]
            initWithScreen:screen
            lightTheme:lightTheme
            darkTheme:darkTheme];

        expect(applier).to.beAnInstanceOf(MTFScreenBrightnessThemeApplier.class);

        MTFTestObjCClassPropertiesApplicant *applicant = [[MTFTestObjCClassPropertiesApplicant alloc] init];
        success = [applier applyClassWithName:className.mtf_symbol to:applicant error:&error];
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        expect(applicant.stringValue).to.equal(lightStringValue);

        MTFTestScreenBrightness = 0.0f;
        [NSNotificationCenter.defaultCenter
            postNotificationName:UIScreenBrightnessDidChangeNotification
            object:screen];

        expect(applicant.stringValue).to.equal(darkStringValue);
    });

    it(@"should occur when changing the screen brightness threshold", ^{
        // Default to light theme
        MTFTestScreenBrightness = 0.6f;

        MTFScreenBrightnessThemeApplier *applier = [[MTFScreenBrightnessThemeApplier alloc]
            initWithScreen:screen
            lightTheme:lightTheme
            darkTheme:darkTheme];

        expect(applier).to.beAnInstanceOf(MTFScreenBrightnessThemeApplier.class);

        MTFTestObjCClassPropertiesApplicant *applicant = [[MTFTestObjCClassPropertiesApplicant alloc] init];
        success = [applier applyClassWithName:className.mtf_symbol to:applicant error:&error];
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        expect(applicant.stringValue).to.equal(lightStringValue);

        applier.brightnessThreshold = 0.7f;

        expect(applicant.stringValue).to.equal(darkStringValue);
    });
});

it(@"should raise when manually setting a theme", ^{
    MTFScreenBrightnessThemeApplier *applier = [[MTFScreenBrightnessThemeApplier alloc]
        initWithScreen:screen
        lightTheme:lightTheme
        darkTheme:darkTheme];

    expect(^{
        [(MTFDynamicThemeApplier *)applier setTheme:darkTheme error:NULL];
    }).to.raise(NSInternalInconsistencyException);
});

SpecEnd
