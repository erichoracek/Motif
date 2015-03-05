//
//  AUTThemeClassApplierTests.m
//  Tests
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AUTTheming/AUTTheming.h>
#import <AUTTheming/AUTTheme+Private.h>
#import <AUTTheming/NSObject+ThemeClassAppliersPrivate.h>
#import <AUTTheming/NSString+ThemeSymbols.h>

@interface AUTThemeClassApplierTests : XCTestCase

@end

@implementation AUTThemeClassApplierTests

- (void)testClassApplier
{
    NSString *class = @".Class";
    NSDictionary *rawTheme = @{
        class: @{}
    };
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithRawTheme:rawTheme error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    NSObject *object = [NSObject new];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Theme class applier expectation"];
    
    id <AUTThemeClassApplicable> classApplier = [NSObject aut_registerThemeClassApplierBlock:^(AUTThemeClass *class, id objectToTheme) {
        XCTAssertEqual(object, objectToTheme, @"The object in the applier must the same object that has a theme applied to it");
        [expectation fulfill];
    }];
    
    AUTThemeApplier *themeApplier = [[AUTThemeApplier alloc] initWithTheme:theme];
    [themeApplier applyClassWithName:class.aut_symbol toObject:object];
    
    [self waitForExpectationsWithTimeout:0.0 handler:^(NSError *error) {
        [NSObject aut_deregisterThemeClassApplier:classApplier];
    }];
}

@end
