//
//  AUTThemePropertyApplierTests.m
//  Tests
//
//  Created by Eric Horacek on 12/25/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AUTTheming/AUTTheming.h>
#import <AUTTheming/AUTValueTransformers.h>
#import <AUTTheming/AUTTheme+Private.h>
#import <AUTTheming/NSObject+ThemingPrivate.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface AUTThemePropertyApplierTests : XCTestCase

@end

@interface AUTTestSubclass : NSObject

@end

@implementation AUTThemePropertyApplierTests

- (void)testPropertyApplier
{
    NSString *class = @"class";
    NSString *property = @"property";
    NSString *value = @"value";
    AUTTheme *theme = [self themeWithClass:class property:property value:value];
    
    Class objectClass = [NSObject class];
    id object = [objectClass new];
    
    XCTestExpectation *applierExpectation = [self expectationWithDescription:@"Theme property applier expectation"];
    
    id <AUTThemeApplier> propertyApplier = [objectClass aut_registerThemeProperty:property applier:^(id propertyValue, id objectToTheme) {
        XCTAssertEqualObjects(value, propertyValue, @"The value applied in the applier must equal the property value in the theme");
        XCTAssertEqual(object, objectToTheme, @"The object in the applier must the same object that has a theme applied to it");
        [applierExpectation fulfill];
    }];
    
    [object aut_applyThemeClassWithName:class fromTheme:theme];
    
    [self waitForExpectationsWithTimeout:0.0 handler:^(NSError *error) {
        [objectClass aut_deregisterThemeApplier:propertyApplier];
    }];
}

#pragma mark - Required Classes

- (void)testPropertyApplierWithRequiredClass
{
    NSString *class = @"class";
    NSString *property = @"property";
    NSNumber *value = @0;
    AUTTheme *theme = [self themeWithClass:class property:property value:value];
    
    Class objectClass = [NSObject class];
    id object = [objectClass new];
    
    XCTestExpectation *applierExpectation = [self expectationWithDescription:@"Theme property applier expectation"];
    
    id <AUTThemeApplier> applier = [objectClass aut_registerThemeProperty:property requiringValueOfClass:[NSNumber class] applier:^(id propertyValue, id objectToTheme) {
        XCTAssertEqualObjects(value, propertyValue, @"The value applied in the applier must equal the property value in the theme");
        XCTAssertEqual(object, objectToTheme, @"The object in the applier must the same object that has a theme applied to it");
        [applierExpectation fulfill];
    }];
    
    [object aut_applyThemeClassWithName:class fromTheme:theme];
    
    [self waitForExpectationsWithTimeout:0.0 handler:^(NSError *error) {
        [objectClass aut_deregisterThemeApplier:applier];
    }];
}

- (void)testPropertyApplierWithInvalidRequiredClass
{
    NSString *class = @"class";
    NSString *property = @"property";
    NSString *value = @"supposedToBeNumber";
    AUTTheme *theme = [self themeWithClass:class property:property value:value];
    
    Class objectClass = [NSObject class];
    id object = [objectClass new];
    
    id <AUTThemeApplier> applier = [objectClass aut_registerThemeProperty:property requiringValueOfClass:[NSNumber class] applier:^(id propertyValue, id objectToTheme) {}];
    
    XCTestExpectation *exceptionExpectation = [self expectationWithDescription:@"Exception should be thrown when theme property value is of incorrect class"];
    @try {
        [object aut_applyThemeClassWithName:class fromTheme:theme];
    }
    @catch (NSException *exception) {
        [exceptionExpectation fulfill];
    }
    
    [self waitForExpectationsWithTimeout:0.0 handler:^(NSError *error) {
        [objectClass aut_deregisterThemeApplier:applier];
    }];
}

#pragma mark - Value Transformers

- (void)testPropertyApplierWithValueTransformer
{
    NSString *class = @"class";
    NSString *property = @"property";
    
    NSString *valueTransfomerName = AUTPointFromStringTransformerName;
    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:valueTransfomerName];
    
    CGPoint point = CGPointMake(10.0, 10.0);
    NSValue *pointValue = [NSValue valueWithCGPoint:point];
    NSString *pointThemeValue = [valueTransformer reverseTransformedValue:pointValue];
    
    AUTTheme *theme = [self themeWithClass:class property:property value:pointThemeValue];
    
    Class objectClass = [NSObject class];
    id object = [objectClass new];
    
    XCTestExpectation *applierExpectation = [self expectationWithDescription:@"Theme property applier expectation"];
    
    id <AUTThemeApplier> applier = [objectClass aut_registerThemeProperty:property valueTransformerName:valueTransfomerName applier:^(id propertyValue, id objectToTheme) {
        XCTAssertEqualObjects(pointValue, propertyValue, @"The value applied in the applier must equal the property value in the theme");
        XCTAssertEqual(object, objectToTheme, @"The object in the applier must the same object that has a theme applied to it");
        [applierExpectation fulfill];
    }];
    
    [object aut_applyThemeClassWithName:class fromTheme:theme];
    
    [self waitForExpectationsWithTimeout:0.0 handler:^(NSError *error) {
        [objectClass aut_deregisterThemeApplier:applier];
    }];
}

#pragma mark - Inheritance

- (void)testPropertyApplierInheritance
{
    NSString *class = @"class";
    NSString *property = @"property";
    NSString *value = @"value";
    AUTTheme *theme = [self themeWithClass:class property:property value:value];
    
    Class objectClass = [AUTTestSubclass class];
    Class objectSuperclass = [objectClass superclass];
    
    id object = [objectClass new];
    
    XCTestExpectation *applierExpectation = [self expectationWithDescription:@"Theme property applier expectation"];
    
    id <AUTThemeApplier> applier = [objectSuperclass aut_registerThemeProperty:property applier:^(id propertyValue, id objectToTheme) {
        XCTAssertEqualObjects(value, propertyValue, @"The value applied in the applier must equal the property value in the theme");
        XCTAssertEqual(object, objectToTheme, @"The object in the applier must the same object that has a theme applied to it");
        [applierExpectation fulfill];
    }];
    
    [object aut_applyThemeClassWithName:class fromTheme:theme];
    
    [self waitForExpectationsWithTimeout:0.0 handler:^(NSError *error) {
        [objectSuperclass aut_deregisterThemeApplier:applier];
    }];
}

#pragma mark - Multiple Appliers

- (void)testApplierNotPresentInClassIsNotApplied
{
    NSString *class = @"class";
    NSString *property = @"property";
    NSString *propertyNotInClass = @"propertyNotInClass";
    NSString *value = @"value";
    AUTTheme *theme = [self themeWithClass:class property:property value:value];
    
    Class objectClass = [NSObject class];
    id object = [objectClass new];
    
    XCTestExpectation *applierExpectation = [self expectationWithDescription:@"Theme property applier expectation"];
    
    id <AUTThemeApplier> propertyApplier = [objectClass aut_registerThemeProperty:property applier:^(id propertyValue, id objectToTheme) {
        XCTAssertEqual(object, objectToTheme, @"The object in the applier must the same object that has a theme applied to it");
        [applierExpectation fulfill];
    }];
    
    id <AUTThemeApplier> propertyNotInClassApplier = [objectClass aut_registerThemeProperty:propertyNotInClass applier:^(id propertyValue, id objectToTheme) {
        XCTFail(@"This applier must not be invoked");
    }];
    
    [object aut_applyThemeClassWithName:class fromTheme:theme];
    
    [self waitForExpectationsWithTimeout:0.0 handler:^(NSError *error) {
        [objectClass aut_deregisterThemeApplier:propertyApplier];
        [objectClass aut_deregisterThemeApplier:propertyNotInClassApplier];
    }];
}

#pragma mark - Helpers

- (AUTTheme *)themeWithClass:(NSString *)class property:(NSString *)property value:(id)value
{
    AUTTheme *theme = [AUTTheme new];
    
    NSDictionary *themeAttributesDictionary = @{
        AUTThemeClassesKey: @{
            class: @{
                property: value
            }
        }
    };
    
    NSError *error;
    [theme addConstantsAndClassesFromRawAttributesDictionary:themeAttributesDictionary forThemeWithName:@"" error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    return theme;
}

@end

@implementation AUTTestSubclass

@end
