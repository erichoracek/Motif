//
//  AUTThemeConstantEqualityTests.m
//  Tests
//
//  Created by Eric Horacek on 12/25/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AutTheming/AUTThemeConstant_Private.h>

@interface AUTThemeConstantEqualityTests : XCTestCase

@end

@implementation AUTThemeConstantEqualityTests

- (void)testThemeConstantEquality
{
    NSString *key = @"key";
    NSString *rawValue = @"rawValue";
    NSString *mappedValue = @"mappedValue";
    
    AUTThemeConstant *constant1 = [[AUTThemeConstant alloc] initWithKey:key rawValue:rawValue mappedValue:mappedValue];
    AUTThemeConstant *constant2 = [[AUTThemeConstant alloc] initWithKey:key rawValue:rawValue mappedValue:mappedValue];
    
    XCTAssertEqualObjects(constant1, constant2, @"Equivalent objects must be equal.");
}

- (void)testThemeConstantKeyInequality
{
    NSString *key1 = @"key1";
    NSString *key2 = @"key2";
    NSString *rawValue = @"rawValue";
    NSString *mappedValue = @"mappedValue";
    
    AUTThemeConstant *constant1 = [[AUTThemeConstant alloc] initWithKey:key1 rawValue:rawValue mappedValue:mappedValue];
    AUTThemeConstant *constant2 = [[AUTThemeConstant alloc] initWithKey:key2 rawValue:rawValue mappedValue:mappedValue];
    
    XCTAssertNotEqualObjects(constant1, constant2, @"Objects with different keys must not be equal.");
}

- (void)testThemeConstantRawValueInequality
{
    NSString *key = @"key";
    NSString *rawValue1 = @"rawValue1";
    NSString *rawValue2 = @"rawValue2";
    NSString *mappedValue = @"mappedValue";
    
    AUTThemeConstant *constant1 = [[AUTThemeConstant alloc] initWithKey:key rawValue:rawValue1 mappedValue:mappedValue];
    AUTThemeConstant *constant2 = [[AUTThemeConstant alloc] initWithKey:key rawValue:rawValue2 mappedValue:mappedValue];
    
    XCTAssertNotEqualObjects(constant1, constant2, @"Objects with different raw values must not be equal.");
}

- (void)testThemeConstantMappedValueInequality
{
    NSString *key = @"key";
    NSString *rawValue = @"rawValue";
    NSString *mappedValue1 = @"mappedValue1";
    NSString *mappedValue2 = @"mappedValue2";
    
    AUTThemeConstant *constant1 = [[AUTThemeConstant alloc] initWithKey:key rawValue:rawValue mappedValue:mappedValue1];
    AUTThemeConstant *constant2 = [[AUTThemeConstant alloc] initWithKey:key rawValue:rawValue mappedValue:mappedValue2];
    
    XCTAssertNotEqualObjects(constant1, constant2, @"Objects with different raw values must not be equal.");
}

@end
