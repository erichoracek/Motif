//
//  AUTThemePropertyApplierTests.m
//  Tests
//
//  Created by Eric Horacek on 12/25/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <AUTTheming/AUTTheming.h>
#import <AUTTheming/AUTValueTransformers.h>
#import <AUTTheming/AUTTheme+Private.h>
#import <AUTTheming/NSObject+ThemeClassAppliersPrivate.h>
#import <AUTTheming/NSString+ThemeSymbols.h>

@interface AUTThemePropertyApplierTests : XCTestCase

@end

@interface AUTTestSubclass : NSObject

@end

@implementation AUTThemePropertyApplierTests

- (void)testPropertyApplier
{
    NSString *class = @".Class";
    NSString *property = @"property";
    NSString *value = @"value";
    AUTTheme *theme = [self themeWithClass:class property:property value:value];
    
    Class objectClass = [NSObject class];
    id object = [objectClass new];
    
    XCTestExpectation *applierExpectation = [self expectationWithDescription:@"Theme property applier expectation"];
    
    id <AUTThemeClassApplicable> propertyApplier = [objectClass aut_registerThemeProperty:property applierBlock:^(id propertyValue, id objectToTheme) {
        XCTAssertEqualObjects(value, propertyValue, @"The value applied in the applier must equal the property value in the theme");
        XCTAssertEqual(object, objectToTheme, @"The object in the applier must the same object that has a theme applied to it");
        [applierExpectation fulfill];
    }];
    
    AUTThemeApplier *themeApplier = [[AUTThemeApplier alloc] initWithTheme:theme];
    [themeApplier applyClassWithName:class.aut_symbol toObject:object];
    
    [self waitForExpectationsWithTimeout:0.0 handler:^(NSError *error) {
        [objectClass aut_deregisterThemeClassApplier:propertyApplier];
    }];
}

#pragma mark - Required Classes

- (void)testPropertyApplierWithRequiredClass
{
    NSString *class = @".Class";
    NSString *property = @"property";
    NSNumber *value = @0;
    AUTTheme *theme = [self themeWithClass:class property:property value:value];
    
    Class objectClass = [NSObject class];
    id object = [objectClass new];
    
    XCTestExpectation *applierExpectation = [self expectationWithDescription:@"Theme property applier expectation"];
    
    id <AUTThemeClassApplicable> propertyApplier = [objectClass aut_registerThemeProperty:property requiringValueOfClass:[NSNumber class] applierBlock:^(id propertyValue, id objectToTheme) {
        XCTAssertEqualObjects(value, propertyValue, @"The value applied in the applier must equal the property value in the theme");
        XCTAssertEqual(object, objectToTheme, @"The object in the applier must the same object that has a theme applied to it");
        [applierExpectation fulfill];
    }];
    
    AUTThemeApplier *themeApplier = [[AUTThemeApplier alloc] initWithTheme:theme];
    [themeApplier applyClassWithName:class.aut_symbol toObject:object];
    
    [self waitForExpectationsWithTimeout:0.0 handler:^(NSError *error) {
        [objectClass aut_deregisterThemeClassApplier:propertyApplier];
    }];
}

- (void)testPropertyApplierWithInvalidRequiredClass
{
    NSString *class = @".Class";
    NSString *property = @"property";
    NSString *value = @"supposedToBeNumber";
    AUTTheme *theme = [self themeWithClass:class property:property value:value];
    
    Class objectClass = [NSObject class];
    id object = [objectClass new];
    
    id <AUTThemeClassApplicable> propertyApplier = [objectClass aut_registerThemeProperty:property requiringValueOfClass:[NSNumber class] applierBlock:^(id propertyValue, id objectToTheme) {}];
    
    XCTestExpectation *exceptionExpectation = [self expectationWithDescription:@"Exception should be thrown when theme property value is of incorrect class"];
    @try {
        AUTThemeApplier *themeApplier = [[AUTThemeApplier alloc] initWithTheme:theme];
        [themeApplier applyClassWithName:class.aut_symbol toObject:object];
    }
    @catch (NSException *exception) {
        [exceptionExpectation fulfill];
    }
    
    [self waitForExpectationsWithTimeout:0.0 handler:^(NSError *error) {
        [objectClass aut_deregisterThemeClassApplier:propertyApplier];
    }];
}

#pragma mark - Value Transformers

- (void)testPropertyApplierWithValueTransformer
{
    NSString *class = @".Class";
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
    
    id <AUTThemeClassApplicable> propertyApplier = [objectClass aut_registerThemeProperty:property valueTransformerName:valueTransfomerName applierBlock:^(id propertyValue, id objectToTheme) {
        XCTAssertEqualObjects(pointValue, propertyValue, @"The value applied in the applier must equal the property value in the theme");
        XCTAssertEqual(object, objectToTheme, @"The object in the applier must the same object that has a theme applied to it");
        [applierExpectation fulfill];
    }];
    
    AUTThemeApplier *themeApplier = [[AUTThemeApplier alloc] initWithTheme:theme];
    [themeApplier applyClassWithName:class.aut_symbol toObject:object];
    
    [self waitForExpectationsWithTimeout:0.0 handler:^(NSError *error) {
        [objectClass aut_deregisterThemeClassApplier:propertyApplier];
    }];
}

#pragma mark - Inheritance

- (void)testPropertyApplierInheritance
{
    NSString *class = @".Class";
    NSString *property = @"property";
    NSString *value = @"value";
    AUTTheme *theme = [self themeWithClass:class property:property value:value];
    
    Class objectClass = [AUTTestSubclass class];
    Class objectSuperclass = [objectClass superclass];
    
    id object = [objectClass new];
    
    XCTestExpectation *applierExpectation = [self expectationWithDescription:@"Theme property applier expectation"];
    
    id <AUTThemeClassApplicable> propertyApplier = [objectSuperclass aut_registerThemeProperty:property applierBlock:^(id propertyValue, id objectToTheme) {
        XCTAssertEqualObjects(value, propertyValue, @"The value applied in the applier must equal the property value in the theme");
        XCTAssertEqual(object, objectToTheme, @"The object in the applier must the same object that has a theme applied to it");
        [applierExpectation fulfill];
    }];
    
    AUTThemeApplier *themeApplier = [[AUTThemeApplier alloc] initWithTheme:theme];
    [themeApplier applyClassWithName:class.aut_symbol toObject:object];
    
    [self waitForExpectationsWithTimeout:0.0 handler:^(NSError *error) {
        [objectSuperclass aut_deregisterThemeClassApplier:propertyApplier];
    }];
}

#pragma mark - Multiple Appliers

- (void)testApplierNotPresentInClassIsNotApplied
{
    NSString *class = @".Class";
    NSString *property = @"property";
    NSString *propertyNotInClass = @"propertyNotInClass";
    NSString *value = @"value";
    AUTTheme *theme = [self themeWithClass:class property:property value:value];
    
    Class objectClass = [NSObject class];
    id object = [objectClass new];
    
    XCTestExpectation *applierExpectation = [self expectationWithDescription:@"Theme property applier expectation"];
    
    id <AUTThemeClassApplicable> propertyApplier = [objectClass aut_registerThemeProperty:property applierBlock:^(id propertyValue, id objectToTheme) {
        XCTAssertEqual(object, objectToTheme, @"The object in the applier must the same object that has a theme applied to it");
        [applierExpectation fulfill];
    }];
    
    id <AUTThemeClassApplicable> propertyNotInClassApplier = [objectClass aut_registerThemeProperty:propertyNotInClass applierBlock:^(id propertyValue, id objectToTheme) {
        XCTFail(@"This applier must not be invoked");
    }];
    
    AUTThemeApplier *themeApplier = [[AUTThemeApplier alloc] initWithTheme:theme];
    [themeApplier applyClassWithName:class.aut_symbol toObject:object];
    
    [self waitForExpectationsWithTimeout:0.0 handler:^(NSError *error) {
        [objectClass aut_deregisterThemeClassApplier:propertyApplier];
        [objectClass aut_deregisterThemeClassApplier:propertyNotInClassApplier];
    }];
}

#pragma mark - Helpers

- (AUTTheme *)themeWithClass:(NSString *)class property:(NSString *)property value:(id)value
{
    NSDictionary *rawTheme = @{
        class: @{
            property: value
        }
    };
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithRawTheme:rawTheme error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    return theme;
}

@end

@implementation AUTTestSubclass

@end
