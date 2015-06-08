//
//  MTFThemePropertiesApplierTests.m
//  MotifTests
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Motif.h"
#import "MTFTheme_Private.h"
#import "NSObject+ThemeClassAppliersPrivate.h"
#import "NSString+ThemeSymbols.h"

@interface MTFThemePropertiesApplierTests : XCTestCase

@end

@interface MTFThemePropertiesApplierTestObject : NSObject

@end

@implementation MTFThemePropertiesApplierTests

- (void)testPropertiesApplier {
    NSString *class = @".Class";
    NSSet *properties = [NSSet setWithArray:@[@"property1", @"property2"]];
    NSSet *values = [NSSet setWithArray:@[@"value1", @"value2"]];

    MTFTheme *theme = [self
        themeWithClass:class
        properties:properties.allObjects
        values:values.allObjects];
    
    Class objectClass = MTFThemePropertiesApplierTestObject.class;
    id object = [objectClass new];
    
    XCTestExpectation *applierExpectation = [self expectationWithDescription:@"Theme property applier expectation"];
    
    id<MTFThemeClassApplicable> propertyApplier = [objectClass
        mtf_registerThemeProperties:properties.allObjects
        applierBlock:^(NSDictionary *valuesForProperties, id objectToTheme) {
            NSSet *propertiesSet = [NSSet setWithArray:valuesForProperties.allKeys];
            NSSet *valuesSet = [NSSet setWithArray:valuesForProperties.allValues];
            BOOL equalProperties = [properties isEqualToSet:propertiesSet];
            BOOL equalValues = [values isEqualToSet:valuesSet];
            XCTAssertTrue(equalProperties, @"Must pass the same set of properties that the appliers are registered");
            XCTAssertTrue(equalValues, @"Must pass the same set of value that the appliers are registered for");
            [applierExpectation fulfill];
        }];
    
    [theme applyClassWithName:class.mtf_symbol toObject:object];
    
    [self waitForExpectationsWithTimeout:0.0 handler:^(NSError *error) {
        [objectClass mtf_deregisterThemeClassApplier:propertyApplier];
    }];
}

- (void)testPropertiesApplierAppliesOnlyWhenAllPropertiesArePresent {
    NSString *class = @".Class";
    NSArray *properties = @[@"property1", @"property2", @"property3"];
    NSArray *values = @[@"value1", @"value2", @"value3"];

    NSArray *propertiesMinusOne = [properties subarrayWithRange:(NSRange){.location = 0, .length = 2}];
    NSArray *valuesMinusOne = [values subarrayWithRange:(NSRange){.location = 0, .length = 2}];

    MTFTheme *theme = [self
        themeWithClass:class
        properties:propertiesMinusOne
        values:valuesMinusOne];

    Class objectClass = MTFThemePropertiesApplierTestObject.class;
    id object = [objectClass new];

    id<MTFThemeClassApplicable> propertiesApplier = [objectClass
        mtf_registerThemeProperties:properties
        applierBlock:^(NSDictionary *valuesForProperties, id objectToTheme) {
            XCTFail(@"Must not invoke applier");
        }];

    XCTestExpectation *applierExpectation = [self expectationWithDescription:@"Theme property applier expectation"];

    id<MTFThemeClassApplicable> propertiesMinusOneApplier = [objectClass
        mtf_registerThemeProperties:propertiesMinusOne
        applierBlock:^(NSDictionary *valuesForProperties, id objectToTheme) {
            [applierExpectation fulfill];
        }];
    
    [theme applyClassWithName:class.mtf_symbol toObject:object];

    [self waitForExpectationsWithTimeout:0.0 handler:^(NSError *error) {
        [objectClass mtf_deregisterThemeClassApplier:propertiesApplier];
        [objectClass mtf_deregisterThemeClassApplier:propertiesMinusOneApplier];
    }];
}

#pragma mark - Helpers

- (MTFTheme *)themeWithClass:(NSString *)class properties:(NSArray *)properties values:(NSArray *)values
{
    NSMutableDictionary *rawClassDictionary = [NSMutableDictionary new];
    NSEnumerator *propertiesEnumerator = [properties objectEnumerator];
    NSEnumerator *valuesEnumerator = [values objectEnumerator];
    id property, value;
    while ((property = [propertiesEnumerator nextObject]) && (value = [valuesEnumerator nextObject])) {
        rawClassDictionary[property] = value;
    }
    
    NSDictionary *rawTheme = @{
        class: rawClassDictionary
    };
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc]
        initWithThemeDictionary:rawTheme
        error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    return theme;
}

@end

@implementation MTFThemePropertiesApplierTestObject

@end
