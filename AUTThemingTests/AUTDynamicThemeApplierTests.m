//
//  AUTDynamicThemeApplierTests.m
//  Tests
//
//  Created by Eric Horacek on 1/7/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "AUTTheming.h"
#import "AUTTheme_Private.h"
#import "AUTDynamicThemeApplier_Private.h"
#import "NSString+ThemeSymbols.h"

@interface AUTDynamicThemeApplierTests : XCTestCase

@end

@implementation AUTDynamicThemeApplierTests

- (void)testThemeReapplication
{
    NSString *class = @".Class";
    NSString *property = @"property";
    NSString *value1 = @"value1";
    NSString *value2 = @"value2";
    
    NSError *error;
    AUTTheme *theme1 = [[AUTTheme alloc]
        initWithThemeDictionary:@{class: @{property: value1}}
        error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    AUTTheme *theme2 = [[AUTTheme alloc]
        initWithThemeDictionary:@{class: @{property: value2}}
        error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    Class objectClass = NSObject.class;
    id object = [objectClass new];
    
    XCTestExpectation *theme1ApplicationExpectation = [self expectationWithDescription:@"theme 1 application"];
    XCTestExpectation *theme2ApplicationExpectation = [self expectationWithDescription:@"theme 2 application"];
    
    [objectClass aut_registerThemeProperty:property applierBlock:^(id propertyValue, id objectToTheme) {
        if (propertyValue == value1) {
            [theme1ApplicationExpectation fulfill];
        }
        else if (propertyValue == value2) {
            [theme2ApplicationExpectation fulfill];
        }
    }];
    
    AUTDynamicThemeApplier *applier = [[AUTDynamicThemeApplier alloc]
        initWithTheme:theme1];
    [applier applyClassWithName:class.aut_symbol toObject:object];
    applier.theme = theme2;
    
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testApplicantMemoryManagement
{
    NSString *class = @".Class";
    
    NSDictionary *rawTheme = @{class: @{}};
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc]
        initWithThemeDictionary:rawTheme
        error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    NSObject *object = [NSObject new];
    AUTDynamicThemeApplier *themeApplier = [[AUTDynamicThemeApplier alloc]
        initWithTheme:theme];
    [themeApplier applyClassWithName:class.aut_symbol toObject:object];
    
    NSHashTable *applicants = themeApplier.applicants;
    XCTAssertNotNil(applicants, @"Must have an applicants hash table");
    XCTAssertEqual(applicants.count, (NSUInteger)1, @"Must have only one applicant added");
    // Ensure that autoreleased reference to object does no stay around and bump up the retain count of object for the duration of the test
    @autoreleasepool {
        XCTAssertTrue([applicants containsObject:object], @"Applicants must contain object which has theme applied to it");
    }
    
    CFIndex objectRetainCount = CFGetRetainCount((void *)object);
    XCTAssertEqual(objectRetainCount, 1, @"The object reference held onto by the applier should not be strong");
    
    // Deallocate object that had theme applied to it
    object = nil;
    
    // Must query `-[NSHashTable allObjects].count` because the hash table contains a nil reference at this point and has yet to clean it up and reconcile its count
    XCTAssertEqual(applicants.allObjects.count, (NSUInteger)0, @"After object is deallocated, applicants must no longer contain it");
}

@end
