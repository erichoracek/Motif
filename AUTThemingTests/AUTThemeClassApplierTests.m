//
//  AUTThemeClassApplierTests.m
//  Tests
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AUTTheming.h"
#import "AUTTheme_Private.h"
#import "NSObject+ThemeClassAppliersPrivate.h"
#import "NSString+ThemeSymbols.h"

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
    AUTTheme *theme = [[AUTTheme alloc]
        initWithThemeDictionary:rawTheme
        error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    NSObject *object = [NSObject new];
    
    XCTestExpectation *expectation = [self
        expectationWithDescription:@"Theme class applier expectation"];
    
    id <AUTThemeClassApplicable> classApplier = [NSObject
        aut_registerThemeClassApplierBlock:^(AUTThemeClass *class, id objectToTheme) {
            XCTAssertEqual(object, objectToTheme, @"The object in the applier must the same object that has a theme applied to it");
            [expectation fulfill];
        }];
    
    [theme applyClassWithName:class.aut_symbol toObject:object];
    
    [self waitForExpectationsWithTimeout:0.0 handler:^(NSError *error) {
        [NSObject aut_deregisterThemeClassApplier:classApplier];
    }];
}

@end
