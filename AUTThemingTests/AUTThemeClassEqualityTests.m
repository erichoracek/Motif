//
//  AUTThemeClassEqualityTests.m
//  Tests
//
//  Created by Eric Horacek on 12/25/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AUTThemeConstant_Private.h"
#import "AUTThemeClass_Private.h"

@interface AUTThemeClassEqualityTests : XCTestCase

@end

@implementation AUTThemeClassEqualityTests

- (void)testThemeClassEquality
{
    NSString *key = @"key";
    NSString *rawValue = @"rawValue";
    NSString *mappedValue = @"mappedValue";
    AUTThemeConstant *constant1 = [[AUTThemeConstant alloc]
        initWithKey:key
        rawValue:rawValue
        mappedValue:mappedValue];
    AUTThemeConstant *constant2 = [[AUTThemeConstant alloc]
        initWithKey:key
        rawValue:rawValue
        mappedValue:mappedValue];
    
    NSString *name = @"name";
    AUTThemeClass *class1 = [[AUTThemeClass alloc]
        initWithName:name
        propertiesConstants:@{key: constant1}];
    AUTThemeClass *class2 = [[AUTThemeClass alloc]
        initWithName:name
        propertiesConstants:@{key: constant2}];
    
    XCTAssertEqualObjects(class1, class2, @"Equivalent objects must be equal.");
}

- (void)testThemeClassNameInequality
{
    NSString *name1 = @"name1";
    AUTThemeClass *class1 = [[AUTThemeClass alloc]
        initWithName:name1
        propertiesConstants:@{}];
    NSString *name2 = @"name2";
    AUTThemeClass *class2 = [[AUTThemeClass alloc]
        initWithName:name2
        propertiesConstants:@{}];
    
    XCTAssertNotEqualObjects(class1, class2, @"Non-equivalent objects must not be equal.");
}

- (void)testThemeClassPropertiesConstantsInequality
{
    NSString *key = @"key";
    NSString *rawValue = @"rawValue";
    NSString *mappedValue1 = @"mappedValue1";
    NSString *mappedValue2 = @"mappedValue2";
    AUTThemeConstant *constant1 = [[AUTThemeConstant alloc]
        initWithKey:key
        rawValue:rawValue
        mappedValue:mappedValue1];
    AUTThemeConstant *constant2 = [[AUTThemeConstant alloc]
        initWithKey:key
        rawValue:rawValue
        mappedValue:mappedValue2];
    
    NSString *name = @"name";
    AUTThemeClass *class1 = [[AUTThemeClass alloc]
        initWithName:name
        propertiesConstants:@{key: constant1}];
    AUTThemeClass *class2 = [[AUTThemeClass alloc]
        initWithName:name
        propertiesConstants:@{key: constant2}];
    
    XCTAssertNotEqualObjects(class1, class2, @"Non-equivalent objects must not be equal.");
}

@end
