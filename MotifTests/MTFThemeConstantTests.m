//
//  MTFThemeConstantTests.m
//  MotifTests
//
//  Created by Eric Horacek on 12/24/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Motif.h"
#import "MTFTheme_Private.h"
#import "NSString+ThemeSymbols.h"

@interface MTFThemeConstantTests : XCTestCase

@end

@implementation MTFThemeConstantTests


- (void)testInvalidReferenceError
{
    NSDictionary *rawTheme = @{@"invalidSymbol": @0};
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc]
        initWithThemeDictionary:rawTheme
        error:&error];
    
    XCTAssertNotNil(theme);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.domain, MTFThemingErrorDomain, @"Must have MTFTheming error domain");
}

- (void)testConstantMapping
{
    NSString *constant = @"$constant";
    NSString *value = @"value";
    
    NSDictionary *rawTheme = @{constant: value};
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc]
        initWithThemeDictionary:rawTheme
        error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    id constantValue = [theme constantValueForName:constant.mtf_symbol];
    
    XCTAssertEqualObjects(value, constantValue, @"Constant value for key from theme must be equivalent to constant value in attributes dictionary");
}

- (void)testConstantToConstantInterThemeMapping
{
    NSString *constant1 = @"$constant1";
    NSString *constant2 = @"$constant2";
    NSString *value = @"value";
    
    NSDictionary *rawTheme1 = @{constant1: value};
    NSDictionary *rawTheme2 = @{constant2: constant1};
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc]
        initWithThemeDictionaries:@[rawTheme1, rawTheme2]
        error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    id constant1Value = [theme constantValueForName:constant1.mtf_symbol];
    id constant2Value = [theme constantValueForName:constant2.mtf_symbol];
    
    XCTAssertEqualObjects(constant1Value, value, @"Constant 1 must have a value of 'value'");
    XCTAssertEqualObjects(constant2Value, value, @"Constant 2 must have a value of 'value'");
}

- (void)testConstantToConstantToConstantInterThemeMapping
{
    NSString *constant1 = @"$constant1";
    NSString *constant2 = @"$constant2";
    NSString *constant3 = @"$constant3";
    NSString *value = @"value";
    
    NSDictionary *rawTheme1 = @{constant1: value};
    NSDictionary *rawTheme2 = @{constant2: constant1};
    NSDictionary *rawTheme3 = @{constant3: constant2};
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc]
        initWithThemeDictionaries:@[rawTheme1, rawTheme2, rawTheme3]
        error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    id constant1Value = [theme constantValueForName:constant1.mtf_symbol];
    id constant2Value = [theme constantValueForName:constant3.mtf_symbol];
    id constant3Value = [theme constantValueForName:constant2.mtf_symbol];
    
    XCTAssertEqualObjects(constant1Value, value, @"Constant 1 must have a value of 'value'");
    XCTAssertEqualObjects(constant2Value, value, @"Constant 2 must have a value of 'value'");
    XCTAssertEqualObjects(constant3Value, value, @"Constant 3 must have a value of 'value'");
}

- (void)testConstantToConstantInnerThemeMapping
{
    NSString *constant1 = @"$constant1";
    NSString *constant2 = @"$constant2";
    NSString *value = @"value";
    
    NSDictionary *rawTheme = @{
        constant2: constant1,
        constant1: value
    };
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc]
        initWithThemeDictionary:rawTheme
        error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    id constant1Value = [theme constantValueForName:constant1.mtf_symbol];
    id constant2Value = [theme constantValueForName:constant2.mtf_symbol];
    
    XCTAssertEqualObjects(constant1Value, value, @"Constant 1 must have a value of 'value'");
    XCTAssertEqualObjects(constant2Value, value, @"Constant 2 must have a value of 'value'");
}

- (void)testInvalidReferenceConstantToConstantInnerThemeMapping
{
    NSString *constant = @"$constant";
    NSString *invalidConstantReference = @"$invalidConstantReference";
    
    NSDictionary *rawTheme = @{constant: invalidConstantReference};
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc]
        initWithThemeDictionary:rawTheme
        error:&error];
    XCTAssert(error, @"Error must be non-nil");
    
    id constantValue = [theme constantValueForName:constant];
    
    XCTAssertNil(constantValue, @"Constant must have a value of 'value'");
}

#pragma mark - Identical Constants

- (void)testRegisteringMultipleConstantsWithIdenticalNamesAcrossThemes
{
    NSString *constant = @"$constant";
    NSString *value1 = @"value1";
    NSString *value2 = @"value2";
    
    NSDictionary *rawTheme1 = @{constant: value1};
    NSDictionary *rawTheme2 = @{constant: value2};
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc]
        initWithThemeDictionaries:@[rawTheme1, rawTheme2]
        error:&error];
    XCTAssertNotNil(error, @"Must have error when constant with duplicate name is registered");
    
    id constantValue = [theme constantValueForName:constant.mtf_symbol];
    
    XCTAssertNotNil(constantValue, @"Constant must exist when registered");
    XCTAssertEqualObjects(value2, constantValue, @"Value must match second registered constant");
}

@end
