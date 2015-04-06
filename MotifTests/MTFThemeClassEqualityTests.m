//
//  MTFThemeClassEqualityTests.m
//  MotifTests
//
//  Created by Eric Horacek on 12/25/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MTFThemeConstant_Private.h"
#import "MTFThemeClass_Private.h"

@interface MTFThemeClassEqualityTests : XCTestCase

@end

@implementation MTFThemeClassEqualityTests

- (void)testThemeClassEquality
{
    NSString *key = @"key";
    NSString *rawValue = @"rawValue";
    NSString *mappedValue = @"mappedValue";
    MTFThemeConstant *constant1 = [[MTFThemeConstant alloc]
        initWithName:key
        rawValue:rawValue
        mappedValue:mappedValue];
    MTFThemeConstant *constant2 = [[MTFThemeConstant alloc]
        initWithName:key
        rawValue:rawValue
        mappedValue:mappedValue];
    
    NSString *name = @"name";
    MTFThemeClass *class1 = [[MTFThemeClass alloc]
        initWithName:name
        propertiesConstants:@{key: constant1}];
    MTFThemeClass *class2 = [[MTFThemeClass alloc]
        initWithName:name
        propertiesConstants:@{key: constant2}];
    
    XCTAssertEqualObjects(class1, class2, @"Equivalent objects must be equal.");
}

- (void)testThemeClassNameInequality
{
    NSString *name1 = @"name1";
    MTFThemeClass *class1 = [[MTFThemeClass alloc]
        initWithName:name1
        propertiesConstants:@{}];
    NSString *name2 = @"name2";
    MTFThemeClass *class2 = [[MTFThemeClass alloc]
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
    MTFThemeConstant *constant1 = [[MTFThemeConstant alloc]
        initWithName:key
        rawValue:rawValue
        mappedValue:mappedValue1];
    MTFThemeConstant *constant2 = [[MTFThemeConstant alloc]
        initWithName:key
        rawValue:rawValue
        mappedValue:mappedValue2];
    
    NSString *name = @"name";
    MTFThemeClass *class1 = [[MTFThemeClass alloc]
        initWithName:name
        propertiesConstants:@{key: constant1}];
    MTFThemeClass *class2 = [[MTFThemeClass alloc]
        initWithName:name
        propertiesConstants:@{key: constant2}];
    
    XCTAssertNotEqualObjects(class1, class2, @"Non-equivalent objects must not be equal.");
}

@end
