//
//  MTFScreenBrightnessThemeApplierTests.m
//  Motif
//
//  Created by Eric Horacek on 5/4/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <Motif/Motif.h>
#import "NSString+ThemeSymbols.h"

static CGFloat TestScreenBrightness = 0.0f;

@interface TestScreen : UIScreen

@end

@interface TestScreenBrightnessObject : NSObject

@property (nonatomic, copy) NSString *testScreenBrightnessProperty;

@end

@interface MTFScreenBrightnessThemeApplierTests : XCTestCase

@end

@implementation MTFScreenBrightnessThemeApplierTests

- (void)testBrightnessChangeTriggersReapplication {
    
    UIScreen *screen = [[TestScreen alloc] init];
    
    NSString *class = @".Class";
    NSString *lightThemePropertyValue = @"light";
    NSString *darkThemePropertyValue = @"dark";
    
    NSDictionary *lightThemeDictionary = @{
        class: @{
            NSStringFromSelector(@selector(testScreenBrightnessProperty)): lightThemePropertyValue
        }
    };
    
    NSDictionary *darkThemeDictionary = @{
        class: @{
            NSStringFromSelector(@selector(testScreenBrightnessProperty)): darkThemePropertyValue
        }
    };
    
    NSError *error;
    
    MTFTheme *lightTheme = [[MTFTheme alloc]
        initWithThemeDictionary:lightThemeDictionary
        error:&error];
    
    XCTAssertNil(error, @"Unable to create light theme from dictionary %@", lightThemeDictionary);
    
    MTFTheme *darkTheme = [[MTFTheme alloc]
        initWithThemeDictionary:darkThemeDictionary
        error:&error];
    
    XCTAssertNil(error, @"Unable to create dark theme from dictionary %@", lightThemeDictionary);
    
    // Default to light theme
    TestScreenBrightness = 1.0f;
    
    MTFScreenBrightnessThemeApplier *applier = [[MTFScreenBrightnessThemeApplier alloc] initWithScreen:screen lightTheme:lightTheme darkTheme:darkTheme];
    
    XCTAssertNotNil(applier, @"Unable to create screen brightness applier");
    
    TestScreenBrightnessObject *object = [[TestScreenBrightnessObject alloc] init];
    
    BOOL didApply = [applier applyClassWithName:class.mtf_symbol toObject:object];
    
    XCTAssertTrue(didApply, @"Unable to apply theme class to object");
    XCTAssertEqualObjects(object.testScreenBrightnessProperty, lightThemePropertyValue, @"Unable to light apply theme to object");
    
    TestScreenBrightness = 0.0f;
    [[NSNotificationCenter defaultCenter] postNotificationName:UIScreenBrightnessDidChangeNotification object:screen];
    
    XCTAssertEqualObjects(object.testScreenBrightnessProperty, darkThemePropertyValue, @"Dark theme was not applied to object");
}

- (void)testExceptionThrownWhenManuallySettingTheme {
    
    UIScreen *screen = [[TestScreen alloc] init];
    
    MTFTheme *lightTheme = [[MTFTheme alloc] initWithThemeDictionary:@{} error:nil];
    MTFTheme *darkTheme = [[MTFTheme alloc] initWithThemeDictionary:@{} error:nil];
    
    MTFScreenBrightnessThemeApplier *applier = [[MTFScreenBrightnessThemeApplier alloc] initWithScreen:screen lightTheme:lightTheme darkTheme:darkTheme];
    
    XCTAssertThrows([applier setTheme:darkTheme], @"An exception should be thrown when invoking setTheme:");
}

@end

@implementation TestScreen

- (CGFloat)brightness {
    return TestScreenBrightness;
}

@end

@implementation TestScreenBrightnessObject

@end
