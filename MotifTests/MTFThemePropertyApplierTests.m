//
//  MTFThemePropertyApplierTests.m
//  MotifTests
//
//  Created by Eric Horacek on 12/25/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "Motif.h"
#import "MTFTheme_Private.h"
#import "NSObject+ThemeClassAppliersPrivate.h"
#import "NSString+ThemeSymbols.h"

@interface MTFThemePropertyApplierTests : XCTestCase

@end

@interface MTFThemePropertyApplierTestClass : NSObject

@end

@interface MTFThemePropertyApplierTestSubclass : MTFThemePropertyApplierTestClass

@end

@interface MTFThemeClassPropertyApplierTestClass : NSObject

@property (readonly, nonatomic, strong) MTFThemeClass *themeClassProperty;

@end

@implementation MTFThemePropertyApplierTests

- (void)testPropertyApplier
{
    NSString *class = @".Class";
    NSString *property = @"property";
    NSString *value = @"value";
    MTFTheme *theme = [self themeWithClass:class property:property value:value];
    
    Class objectClass = MTFThemePropertyApplierTestClass.class;
    id object = [objectClass new];
    
    XCTestExpectation *applierExpectation = [self
        expectationWithDescription:@"Theme property applier expectation"];
    
    id <MTFThemeClassApplicable> propertyApplier = [objectClass
        mtf_registerThemeProperty:property
        applierBlock:^(id propertyValue, id objectToTheme) {
            XCTAssertEqualObjects(value, propertyValue, @"The value applied in the applier must equal the property value in the theme");
            XCTAssertEqual(object, objectToTheme, @"The object in the applier must the same object that has a theme applied to it");
            [applierExpectation fulfill];
        }];
    
    [theme applyClassWithName:class.mtf_symbol toObject:object];
    
    [self waitForExpectationsWithTimeout:0.0 handler:^(NSError *error) {
        [objectClass mtf_deregisterThemeClassApplier:propertyApplier];
    }];
}

#pragma mark - Required Classes

- (void)testPropertyApplierWithRequiredClass
{
    NSString *class = @".Class";
    NSString *property = @"property";
    NSNumber *value = @0;
    MTFTheme *theme = [self themeWithClass:class property:property value:value];
    
    Class objectClass = MTFThemePropertyApplierTestClass.class;
    id object = [objectClass new];
    
    XCTestExpectation *applierExpectation = [self expectationWithDescription:@"Theme property applier expectation"];
    
    id <MTFThemeClassApplicable> propertyApplier = [objectClass
        mtf_registerThemeProperty:property
        requiringValueOfClass:NSNumber.class
        applierBlock:^(id propertyValue, id objectToTheme) {
            XCTAssertEqualObjects(value, propertyValue, @"The value applied in the applier must equal the property value in the theme");
            XCTAssertEqual(object, objectToTheme, @"The object in the applier must the same object that has a theme applied to it");
            [applierExpectation fulfill];
        }];
    
    [theme applyClassWithName:class.mtf_symbol toObject:object];
    
    [self waitForExpectationsWithTimeout:0.0 handler:^(NSError *error) {
        [objectClass mtf_deregisterThemeClassApplier:propertyApplier];
    }];
}

- (void)testPropertyApplierWithInvalidRequiredClass
{
    NSString *class = @".Class";
    NSString *property = @"property";
    NSString *value = @"notANumber";
    MTFTheme *theme = [self themeWithClass:class property:property value:value];
    
    Class objectClass = MTFThemePropertyApplierTestClass.class;
    id object = [objectClass new];
    
    id <MTFThemeClassApplicable> propertyApplier = [objectClass
        mtf_registerThemeProperty:property
        requiringValueOfClass:NSNumber.class
        applierBlock:^(id propertyValue, id objectToTheme) {}];

    MTFDynamicThemeApplier *themeApplier = [[MTFDynamicThemeApplier alloc] initWithTheme:theme];
    XCTAssertThrows([themeApplier applyClassWithName:class.mtf_symbol toObject:object]);

    [objectClass mtf_deregisterThemeClassApplier:propertyApplier];
}

- (void)testApplicationOfClassReferenceToProperty {
    NSString *class = @".Class";
    NSString *referencedClass = @".ReferencedClass";
    NSString *themeClassProperty = @"themeClassProperty";

     NSDictionary *rawTheme = @{
        class: @{
            themeClassProperty: referencedClass
        },
        referencedClass: @{}
    };
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc] initWithThemeDictionary:rawTheme error:&error];
    XCTAssertNil(error, @"Error must be nil");

    MTFThemeClassPropertyApplierTestClass *object = [[MTFThemeClassPropertyApplierTestClass alloc] init];

    BOOL didApply = [theme applyClassWithName:class.mtf_symbol toObject:object];

    XCTAssertTrue(didApply, @"Must successfully apply class");

    MTFThemeClass *propertyValue = object.themeClassProperty;

    XCTAssertNotNil(propertyValue, @"Must successfully apply theme class property");
    XCTAssertTrue([propertyValue isKindOfClass:MTFThemeClass.class], @"Must successfully apply theme class property");
    XCTAssertEqualObjects(propertyValue.name, referencedClass.mtf_symbol, @"Symbol must be correct reference");
}

- (void)testApplicationOfClassReferenceToPropertyWithInvalidClass {
    NSString *class = @".Class";
    NSString *referencedClass = @".ReferencedClass";
    NSString *themeClassProperty = @"themeClassProperty";
    NSString *invalidPropertyName = @"invalidProperty";

     NSDictionary *rawTheme = @{
        class: @{
            themeClassProperty: referencedClass
        },
        referencedClass: @{
            invalidPropertyName: @"invalidValue"
        }
    };
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc] initWithThemeDictionary:rawTheme error:&error];
    XCTAssertNil(error, @"Error must be nil");

    MTFThemeClassPropertyApplierTestClass *object = [[MTFThemeClassPropertyApplierTestClass alloc] init];

    BOOL didApply = NO;
    @try {
        didApply = [theme applyClassWithName:class.mtf_symbol toObject:object];
    }
    @catch (NSException *exception) {
        XCTAssertFalse(didApply, @"Must fail to apply class");

        MTFThemeClass *propertyValue = object.themeClassProperty;
        XCTAssertNotNil(propertyValue, @"Must successfully apply theme class property");
        XCTAssertTrue([propertyValue isKindOfClass:MTFThemeClass.class], @"Must successfully apply theme class property");
        XCTAssertEqualObjects(propertyValue.name, referencedClass.mtf_symbol, @"Symbol must be correct reference");

        XCTAssertEqualObjects(exception.name, MTFThemeClassUnappliedPropertyException, @"Must throw unapplied property exception");
        XCTAssertEqualObjects(exception.userInfo[MTFThemeClassExceptionUserInfoKeyUnappliedPropertyName], invalidPropertyName, @"Must throw exception for correct property");
    }
}

- (void)testMultiplePropertyAppliersWithDifferentRequiredClasses {
    NSString *class = @".Class";
    NSString *property = @"property";
    NSString *value = @"string";
    MTFTheme *theme = [self themeWithClass:class property:property value:value];

    Class objectClass = MTFThemePropertyApplierTestClass.class;
    id object = [objectClass new];

    XCTestExpectation *exceptionExpectation = [self expectationWithDescription:@"Exception should be thrown when theme property value is of incorrect class"];

    id <MTFThemeClassApplicable> numberPropertyApplier = [objectClass
        mtf_registerThemeProperty:property
        requiringValueOfClass:NSNumber.class
        applierBlock:^(id propertyValue, id objectToTheme) {
            XCTFail(@"Number applier should not be invoked");
        }];

    id <MTFThemeClassApplicable> stringPropertyApplier = [objectClass
        mtf_registerThemeProperty:property
        requiringValueOfClass:NSString.class
        applierBlock:^(id propertyValue, id objectToTheme) {
            [exceptionExpectation fulfill];
        }];

    MTFDynamicThemeApplier *themeApplier = [[MTFDynamicThemeApplier alloc] initWithTheme:theme];
    [themeApplier applyClassWithName:class.mtf_symbol toObject:object];

    [self waitForExpectationsWithTimeout:0.0 handler:^(NSError *error) {
        [objectClass mtf_deregisterThemeClassApplier:stringPropertyApplier];
        [objectClass mtf_deregisterThemeClassApplier:numberPropertyApplier];
    }];
}

#pragma mark - Value Transformers

- (void)testPropertyApplierWithValueTransformer
{
    NSString *class = @".Class";
    NSString *property = @"property";
    
    NSString *valueTransfomerName = MTFPointFromArrayTransformerName;
    
    CGPoint point = CGPointMake(10.0, 10.0);
    NSValue *pointValue = [NSValue valueWithCGPoint:point];
    NSArray *pointThemeValue = @[@10.0, @10.0];
    
    MTFTheme *theme = [self themeWithClass:class property:property value:pointThemeValue];
    
    Class objectClass = MTFThemePropertyApplierTestClass.class;
    id object = [objectClass new];
    
    XCTestExpectation *applierExpectation = [self expectationWithDescription:@"Theme property applier expectation"];
    
    id <MTFThemeClassApplicable> propertyApplier = [objectClass mtf_registerThemeProperty:property valueTransformerName:valueTransfomerName applierBlock:^(id propertyValue, id objectToTheme) {
        XCTAssertEqualObjects(pointValue, propertyValue, @"The value applied in the applier must equal the property value in the theme");
        XCTAssertEqual(object, objectToTheme, @"The object in the applier must the same object that has a theme applied to it");
        [applierExpectation fulfill];
    }];
    
    [theme applyClassWithName:class.mtf_symbol toObject:object];
    
    [self waitForExpectationsWithTimeout:0.0 handler:^(NSError *error) {
        [objectClass mtf_deregisterThemeClassApplier:propertyApplier];
    }];
}

#pragma mark - Inheritance

- (void)testPropertyApplierInheritance
{
    NSString *class = @".Class";
    NSString *property = @"property";
    NSString *value = @"value";
    MTFTheme *theme = [self themeWithClass:class property:property value:value];
    
    Class objectClass = MTFThemePropertyApplierTestSubclass.class;
    Class objectSuperclass = [objectClass superclass];
    
    id object = [objectClass new];
    
    XCTestExpectation *applierExpectation = [self expectationWithDescription:@"Theme property applier expectation"];
    
    id <MTFThemeClassApplicable> propertyApplier = [objectSuperclass mtf_registerThemeProperty:property applierBlock:^(id propertyValue, id objectToTheme) {
        XCTAssertEqualObjects(value, propertyValue, @"The value applied in the applier must equal the property value in the theme");
        XCTAssertEqual(object, objectToTheme, @"The object in the applier must the same object that has a theme applied to it");
        [applierExpectation fulfill];
    }];
    
    [theme applyClassWithName:class.mtf_symbol toObject:object];
    
    [self
        waitForExpectationsWithTimeout:0.0
        handler:^(NSError *error) {
            [objectSuperclass mtf_deregisterThemeClassApplier:propertyApplier];
        }];
}

#pragma mark - Multiple Appliers

- (void)testApplierNotPresentInClassIsNotApplied
{
    NSString *class = @".Class";
    NSString *property = @"property";
    NSString *propertyNotInClass = @"propertyNotInClass";
    NSString *value = @"value";
    MTFTheme *theme = [self themeWithClass:class property:property value:value];
    
    Class objectClass = MTFThemePropertyApplierTestSubclass.class;
    id object = [objectClass new];
    
    XCTestExpectation *applierExpectation = [self expectationWithDescription:@"Theme property applier expectation"];
    
    id <MTFThemeClassApplicable> propertyApplier = [objectClass
        mtf_registerThemeProperty:property
        applierBlock:^(id propertyValue, id objectToTheme) {
            XCTAssertEqual(
                object,
                objectToTheme,
                @"The object in the applier must the same object that has a "
                    "theme applied to it");

            [applierExpectation fulfill];
        }];
    
    id <MTFThemeClassApplicable> propertyNotInClassApplier = [objectClass
        mtf_registerThemeProperty:propertyNotInClass
        applierBlock:^(id propertyValue, id objectToTheme) {
            XCTFail(@"This applier must not be invoked");
        }];
    
    [theme applyClassWithName:class.mtf_symbol toObject:object];
    
    [self
        waitForExpectationsWithTimeout:0.0
        handler:^(NSError *error) {
            [objectClass mtf_deregisterThemeClassApplier:propertyApplier];
            [objectClass mtf_deregisterThemeClassApplier:propertyNotInClassApplier];
        }];
}

#pragma mark - Helpers

- (MTFTheme *)themeWithClass:(NSString *)class property:(NSString *)property value:(id)value
{
    NSDictionary *rawTheme = @{
        class: @{
            property: value
        }
    };
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc] initWithThemeDictionary:rawTheme error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    return theme;
}

@end

@implementation MTFThemePropertyApplierTestClass

@end

@implementation MTFThemePropertyApplierTestSubclass

@end

@implementation MTFThemeClassPropertyApplierTestClass

- (void)setThemeClassProperty:(MTFThemeClass *)themeClassProperty {
    _themeClassProperty = themeClassProperty;

    NSObject *object = [[NSObject alloc] init];
    [themeClassProperty applyToObject:object];
}

@end
