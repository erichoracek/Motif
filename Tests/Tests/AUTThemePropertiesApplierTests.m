//
//  AUTThemePropertiesApplierTests.m
//  Tests
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import <AUTTheming/AUTTheming.h>
#import <AUTTheming/AUTTheme_Private.h>
#import <AUTTheming/NSObject+ThemeClassAppliersPrivate.h>
#import <AUTTheming/NSString+ThemeSymbols.h>

@interface AUTThemePropertiesApplierTests : XCTestCase

@end

@interface DeallocatingObject : UIView

@end

@implementation AUTThemePropertiesApplierTests

- (void)testPropertiesApplier
{
    NSString *class = @".Class";
    NSSet *properties = [NSSet setWithArray:@[@"property1", @"property2"]];
    NSSet *values = [NSSet setWithArray:@[@"value1", @"value2"]];
    AUTTheme *theme = [self themeWithClass:class properties:properties.allObjects values:values.allObjects];
    
    Class objectClass = [NSObject class];
    id object = [objectClass new];
    
    XCTestExpectation *applierExpectation = [self expectationWithDescription:@"Theme property applier expectation"];
    
    id <AUTThemeClassApplicable> propertyApplier = [objectClass aut_registerThemeProperties:properties.allObjects applierBlock:^(NSDictionary *valuesForProperties, id objectToTheme) {
        BOOL equalProperties = [properties isEqualToSet:[NSSet setWithArray:valuesForProperties.allKeys]];
        BOOL equalValues = [values isEqualToSet:[NSSet setWithArray:valuesForProperties.allValues]];
        XCTAssertTrue(equalProperties, @"Must pass the same set of properties that the appliers are registered");
        XCTAssertTrue(equalValues, @"Must pass the same set of value that the appliers are registered for");
        [applierExpectation fulfill];
    }];
    
    AUTThemeApplier *themeApplier = [[AUTThemeApplier alloc] initWithTheme:theme];
    [themeApplier applyClassWithName:class.aut_symbol toObject:object];
    
    [self waitForExpectationsWithTimeout:0.0 handler:^(NSError *error) {
        [objectClass aut_deregisterThemeClassApplier:propertyApplier];
    }];
}

- (void)testPropertiesRequiredClassApplier
{
    
}

#pragma mark - Helpers

- (AUTTheme *)themeWithClass:(NSString *)class properties:(NSArray *)properties values:(NSArray *)values
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
    AUTTheme *theme = [[AUTTheme alloc] initWithThemeDictionary:rawTheme error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    return theme;
}

@end

@implementation DeallocatingObject

- (void)dealloc
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end