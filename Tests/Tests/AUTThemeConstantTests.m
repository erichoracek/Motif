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
    AUTTheme *theme = [AUTTheme new];
    
    NSDictionary *themeAttributesDictionary = @{AUTThemeConstantsKey: @0};
    
    NSError *error;
    [theme addConstantsAndClassesFromRawAttributesDictionary:themeAttributesDictionary forThemeWithName:@"" error:&error];
    
    XCTAssertNotNil(error);
    XCTAssertEqual(error.domain, AUTThemingErrorDomain, @"Must have AUTTheming error domain");
}

- (void)testConstantMapping
{
    NSString *key = @"key";
    NSString *value = @"value";
    
    NSDictionary *themeAttributesDictionary = @{AUTThemeConstantsKey: @{key: value}};
    
    AUTTheme *theme = [AUTTheme new];
    [theme addConstantsAndClassesFromRawAttributesDictionary:themeAttributesDictionary forThemeWithName:@"" error:nil];
    
    XCTAssertEqualObjects(value, [theme constantValueForKey:key], @"Constant value for key from theme must be equivalent to constant value in attributes dictionary");
}

- (void)testConstantToConstantInterThemeMapping
{
    NSString *key1 = @"key1";
    NSString *key2 = @"key2";
    NSString *value = @"value";
    
    NSDictionary *themeAttributesDictionary1 = @{AUTThemeConstantsKey: @{key1: value}};
    NSDictionary *themeAttributesDictionary2 = @{AUTThemeConstantsKey: @{key2: key1}};
    
    AUTTheme *theme = [AUTTheme new];
    [theme addConstantsAndClassesFromRawAttributesDictionary:themeAttributesDictionary1 forThemeWithName:@"" error:nil];
    [theme addConstantsAndClassesFromRawAttributesDictionary:themeAttributesDictionary2 forThemeWithName:@"" error:nil];
    
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
    
    NSDictionary *themeAttributesDictionary1 = @{AUTThemeConstantsKey: @{key1: value}};
    NSDictionary *themeAttributesDictionary2 = @{AUTThemeConstantsKey: @{key2: key1}};
    NSDictionary *themeAttributesDictionary3 = @{AUTThemeConstantsKey: @{key3: key2}};
    
    AUTTheme *theme = [AUTTheme new];
    [theme addConstantsAndClassesFromRawAttributesDictionary:themeAttributesDictionary1 forThemeWithName:@"" error:nil];
    [theme addConstantsAndClassesFromRawAttributesDictionary:themeAttributesDictionary2 forThemeWithName:@"" error:nil];
    [theme addConstantsAndClassesFromRawAttributesDictionary:themeAttributesDictionary3 forThemeWithName:@"" error:nil];
    
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
    
    NSDictionary *themeAttributesDictionary = @{
        AUTThemeConstantsKey: @{
            key2: key1,
            key1: value
        }
    };
    
    AUTTheme *theme = [AUTTheme new];
    [theme addConstantsAndClassesFromRawAttributesDictionary:themeAttributesDictionary forThemeWithName:@"" error:nil];
    
    id key1Value = [theme constantValueForKey:key1];
    id key2Value = [theme constantValueForKey:key2];
    
    XCTAssertEqualObjects(key1Value, value, @"The key 1 constant must have a value of 'value'");
    XCTAssertEqualObjects(key2Value, value, @"The key 2 constant must have a value of 'value'");
}

@end
