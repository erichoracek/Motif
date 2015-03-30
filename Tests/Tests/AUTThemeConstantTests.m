//
//  AUTThemeConstantTests.m
//  Tests
//
//  Created by Eric Horacek on 12/24/14.
//
//

#import <XCTest/XCTest.h>
#import <AUTTheming/AUTTheming.h>
#import <AUTTheming/AUTTheme_Private.h>
#import <AUTTheming/NSString+ThemeSymbols.h>

@interface AUTThemeConstantTests : XCTestCase

@end

@implementation AUTThemeConstantTests


- (void)testInvalidReferenceError
{
    NSDictionary *rawTheme = @{@"invalidSymbol": @0};
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc]
        initWithThemeDictionary:rawTheme
        error:&error];
    
    XCTAssertNotNil(theme);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.domain, AUTThemingErrorDomain, @"Must have AUTTheming error domain");
}

- (void)testConstantMapping
{
    NSString *constant = @"$constant";
    NSString *value = @"value";
    
    NSDictionary *rawTheme = @{constant: value};
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc]
        initWithThemeDictionary:rawTheme
        error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    id constantValue = [theme constantValueForKey:constant.aut_symbol];
    
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
    AUTTheme *theme = [[AUTTheme alloc]
        initWithThemeDictionaries:@[rawTheme1, rawTheme2]
        error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    id constant1Value = [theme constantValueForKey:constant1.aut_symbol];
    id constant2Value = [theme constantValueForKey:constant2.aut_symbol];
    
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
    AUTTheme *theme = [[AUTTheme alloc]
        initWithThemeDictionaries:@[rawTheme1, rawTheme2, rawTheme3]
        error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    id constant1Value = [theme constantValueForKey:constant1.aut_symbol];
    id constant2Value = [theme constantValueForKey:constant3.aut_symbol];
    id constant3Value = [theme constantValueForKey:constant2.aut_symbol];
    
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
    AUTTheme *theme = [[AUTTheme alloc]
        initWithThemeDictionary:rawTheme
        error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    id constant1Value = [theme constantValueForKey:constant1.aut_symbol];
    id constant2Value = [theme constantValueForKey:constant2.aut_symbol];
    
    XCTAssertEqualObjects(constant1Value, value, @"Constant 1 must have a value of 'value'");
    XCTAssertEqualObjects(constant2Value, value, @"Constant 2 must have a value of 'value'");
}

- (void)testInvalidReferenceConstantToConstantInnerThemeMapping
{
    NSString *constant = @"$constant";
    NSString *invalidConstantReference = @"$invalidConstantReference";
    
    NSDictionary *rawTheme = @{constant: invalidConstantReference};
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc]
        initWithThemeDictionary:rawTheme
        error:&error];
    XCTAssert(error, @"Error must be non-nil");
    
    id constantValue = [theme constantValueForKey:constant];
    
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
    AUTTheme *theme = [[AUTTheme alloc]
        initWithThemeDictionaries:@[rawTheme1, rawTheme2]
        error:&error];
    XCTAssertNotNil(error, @"Must have error when constant with duplicate name is registered");
    
    id constantValue = [theme constantValueForKey:constant.aut_symbol];
    
    XCTAssertNotNil(constantValue, @"Constant must exist when registered");
    XCTAssertEqualObjects(value2, constantValue, @"Value must match second registered constant");
}

@end
