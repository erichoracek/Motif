//
//  AUTThemeConstantTests.m
//  Tests
//
//  Created by Eric Horacek on 12/24/14.
//
//

#import <XCTest/XCTest.h>
#import <AUTTheming/AUTTheming.h>
#import <AUTTheming/AUTTheme+Private.h>

@interface AUTThemeConstantTests : XCTestCase

@end

@implementation AUTThemeConstantTests


- (void)testConstantMappingInvalidConstantObjectError
{
    NSDictionary *rawAttributesDictionary = @{AUTThemeConstantsKey: @0};
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithRawAttributesDictionary:rawAttributesDictionary error:&error];

    XCTAssertNotNil(theme);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.domain, AUTThemingErrorDomain, @"Must have AUTTheming error domain");
}

- (void)testConstantMapping
{
    NSString *key = @"key";
    NSString *value = @"value";
    
    NSDictionary *rawAttributesDictionary = @{AUTThemeConstantsKey: @{key: value}};
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithRawAttributesDictionary:rawAttributesDictionary error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    XCTAssertEqualObjects(value, [theme constantValueForKey:key], @"Constant value for key from theme must be equivalent to constant value in attributes dictionary");
}

- (void)testConstantToConstantInterThemeMapping
{
    NSString *key1 = @"key1";
    NSString *key2 = @"key2";
    NSString *value = @"value";
    
    NSDictionary *rawAttributesDictionary1 = @{AUTThemeConstantsKey: @{key1: value}};
    NSDictionary *rawAttributesDictionary2 = @{AUTThemeConstantsKey: @{key2: key1}};
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithRawAttributesDictionaries:@[rawAttributesDictionary1, rawAttributesDictionary2] error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    id key1Value = [theme constantValueForKey:key1];
    id key2Value = [theme constantValueForKey:key2];
    
    XCTAssertEqualObjects(key1Value, value, @"The key 1 constant must have a value of 'value'");
    XCTAssertEqualObjects(key2Value, value, @"The key 2 constant must have a value of 'value'");
}

- (void)testConstantToConstantToConstantInterThemeMapping
{
    NSString *key1 = @"key1";
    NSString *key2 = @"key2";
    NSString *key3 = @"key3";
    NSString *value = @"value";
    
    NSDictionary *rawAttributesDictionary1 = @{AUTThemeConstantsKey: @{key1: value}};
    NSDictionary *rawAttributesDictionary2 = @{AUTThemeConstantsKey: @{key2: key1}};
    NSDictionary *rawAttributesDictionary3 = @{AUTThemeConstantsKey: @{key3: key2}};
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithRawAttributesDictionaries:@[rawAttributesDictionary1, rawAttributesDictionary2, rawAttributesDictionary3] error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    id key1Value = [theme constantValueForKey:key1];
    id key2Value = [theme constantValueForKey:key2];
    id key3Value = [theme constantValueForKey:key3];
    
    XCTAssertEqualObjects(key1Value, value, @"The key 1 constant must have a value of 'value'");
    XCTAssertEqualObjects(key2Value, value, @"The key 2 constant must have a value of 'value'");
    XCTAssertEqualObjects(key3Value, value, @"The key 3 constant must have a value of 'value'");
}

- (void)testConstantToConstantInnerThemeMapping
{
    NSString *key1 = @"key1";
    NSString *key2 = @"key2";
    NSString *value = @"value";
    
    NSDictionary *rawAttributesDictionary = @{
        AUTThemeConstantsKey: @{
            key2: key1,
            key1: value
        }
    };
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithRawAttributesDictionary:rawAttributesDictionary error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    id key1Value = [theme constantValueForKey:key1];
    id key2Value = [theme constantValueForKey:key2];
    
    XCTAssertEqualObjects(key1Value, value, @"The key 1 constant must have a value of 'value'");
    XCTAssertEqualObjects(key2Value, value, @"The key 2 constant must have a value of 'value'");
}

#pragma mark - Identical Constants

- (void)testRegisteringMultipleConstantsWithIdenticalNamesAcrossThemes
{
    NSString *constant = @"constant";
    NSString *value1 = @"value1";
    NSString *value2 = @"value";
    
    NSDictionary *themeAttributesDictionary1 = @{
        AUTThemeConstantsKey: @{
            constant: value1
        }
    };
    NSDictionary *themeAttributesDictionary2 = @{
        AUTThemeConstantsKey: @{
            constant: value2
        }
    };
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithRawAttributesDictionaries:@[themeAttributesDictionary1, themeAttributesDictionary2] error:&error];
    XCTAssertNotNil(error, @"Must have error when constant with duplciate name is registered");
    
    id constantValue = [theme constantValueForKey:constant];
    XCTAssertNotNil(constantValue, @"Constant must exist when registered");
    XCTAssertEqualObjects(value2, constantValue, @"Value must match second registered constant");
}

@end
