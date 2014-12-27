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
#import <AUTTheming/NSObject+ThemingPrivate.h>

@interface AUTThemeClassApplierTests : XCTestCase

@end

@implementation AUTThemeClassApplierTests

- (void)testClassApplier
{
    AUTTheme *theme = [AUTTheme new];
 
    NSString *class = @"class";
    NSDictionary *themeAttributesDictionary = @{
        AUTThemeClassesKey: @{
            class: @{}
        }
    };
    
    NSError *error;
    [theme addConstantsAndClassesFromRawAttributesDictionary:themeAttributesDictionary forThemeWithName:@"" error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    NSObject *object = [NSObject new];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Theme class applier expectation"];
    
    id <AUTThemeApplier> applier = [NSObject aut_registerThemeClassApplier:^(id objectToTheme) {
        XCTAssertEqual(object, objectToTheme, @"The object in the applier must the same object that has a theme applied to it");
        [expectation fulfill];
    }];
    
    [object aut_applyThemeClassWithName:class fromTheme:theme];
    
    [self waitForExpectationsWithTimeout:0.0 handler:^(NSError *error) {
        [NSObject aut_deregisterThemeApplier:applier];
    }];
}

@end
