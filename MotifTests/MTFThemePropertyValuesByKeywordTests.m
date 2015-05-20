//
//  MTFThemePropertyValuesByKeywordTests.m
//  Motif
//
//  Created by Eric Horacek on 5/19/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import Motif;
@import XCTest;

#import "NSObject+ThemeClassAppliersPrivate.h"
#import "NSString+ThemeSymbols.h"

typedef NS_ENUM(NSInteger, MTFTestEnumeration) {
    MTFTestEnumeration1,
    MTFTestEnumeration2,
    MTFTestEnumeration3
};

@interface MTFThemePropertyValuesByKeywordTestObject : NSObject

@property (readonly, nonatomic, assign) MTFTestEnumeration testEnumeration;

@end

@interface MTFThemePropertyValuesByKeywordTests : XCTestCase

@end

@implementation MTFThemePropertyValuesByKeywordTests

- (void)testAppliesProperty {
    NSString *class = @".Class";

    NSDictionary *rawTheme = @{
        class: @{
            @"testEnumeration": @"2"
        }
    };

    id<MTFThemeClassApplicable> applier = [MTFThemePropertyValuesByKeywordTestObject
        mtf_registerThemeProperty:@"testEnumeration"
        forKeyPath:NSStringFromSelector(@selector(testEnumeration))
        withValuesByKeyword:@{
            @"1": @(MTFTestEnumeration1),
            @"2": @(MTFTestEnumeration2),
            @"3": @(MTFTestEnumeration3),
        }];

    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc] initWithThemeDictionary:rawTheme error:&error];
    XCTAssertNil(error, @"Error must be nil");

    MTFThemePropertyValuesByKeywordTestObject *object = [[MTFThemePropertyValuesByKeywordTestObject alloc] init];

    BOOL didApply = [theme applyClassWithName:class.mtf_symbol toObject:object];
    XCTAssertTrue(didApply, @"Must apply successfully");

    XCTAssertEqual(object.testEnumeration, MTFTestEnumeration2, @"must apply correct value");

    [MTFThemePropertyValuesByKeywordTestObject mtf_deregisterThemeClassApplier:applier];
}

- (void)testThrowsOnInvalidPropertyValue {
    NSString *class = @".Class";

    NSDictionary *rawTheme = @{
        class: @{
            @"testEnumeration": @"invalidValue"
        }
    };

    id<MTFThemeClassApplicable> applier = [MTFThemePropertyValuesByKeywordTestObject
        mtf_registerThemeProperty:@"testEnumeration"
        forKeyPath:NSStringFromSelector(@selector(testEnumeration))
        withValuesByKeyword:@{
            @"1": @(MTFTestEnumeration1),
            @"2": @(MTFTestEnumeration2),
            @"3": @(MTFTestEnumeration3),
        }];

    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc] initWithThemeDictionary:rawTheme error:&error];
    XCTAssertNil(error, @"Error must be nil");

    MTFThemePropertyValuesByKeywordTestObject *object = [[MTFThemePropertyValuesByKeywordTestObject alloc] init];

    XCTAssertThrows([theme applyClassWithName:class.mtf_symbol toObject:object]);

    [MTFThemePropertyValuesByKeywordTestObject mtf_deregisterThemeClassApplier:applier];
}

@end

@implementation MTFThemePropertyValuesByKeywordTestObject

@end