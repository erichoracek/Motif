//
//  MTFThemeClassApplierTests.m
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

@interface MTFThemeClassApplierTests : XCTestCase

@end

@implementation MTFThemeClassApplierTests

- (void)testClassApplier
{
    NSString *class = @".Class";
    NSDictionary *rawTheme = @{
        class: @{}
    };
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc]
        initWithThemeDictionary:rawTheme
        error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    NSObject *object = [NSObject new];
    
    XCTestExpectation *expectation = [self
        expectationWithDescription:@"Theme class applier expectation"];
    
    id <MTFThemeClassApplicable> classApplier = [NSObject
        mtf_registerThemeClassApplierBlock:^(MTFThemeClass *class, id objectToTheme) {
            XCTAssertEqual(object, objectToTheme, @"The object in the applier must the same object that has a theme applied to it");
            [expectation fulfill];
        }];
    
    [theme applyClassWithName:class.mtf_symbol toObject:object];
    
    [self waitForExpectationsWithTimeout:0.0 handler:^(NSError *error) {
        [NSObject mtf_deregisterThemeClassApplier:classApplier];
    }];
}

@end
