//
//  AUTThemeApplierTests.m
//  Tests
//
//  Created by Eric Horacek on 1/7/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import <AUTTheming/AUTTheming.h>
#import <AUTTheming/AUTTheme+Private.h>
#import <AUTTheming/AUTThemeApplier+Private.h>
#import <AUTTheming/NSString+ThemeSymbols.h>

@interface AUTThemeApplierTests : XCTestCase

@end

@implementation AUTThemeApplierTests

- (void)testThemeReapplication
{
    NSString *class = @".Class";
    NSString *property = @"property";
    NSString *value1 = @"value1";
    NSString *value2 = @"value2";
    
    NSError *error;
    AUTTheme *theme1 = [[AUTTheme alloc] initWithRawTheme:@{class: @{property: value1}} error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    AUTTheme *theme2 = [[AUTTheme alloc] initWithRawTheme:@{class: @{property: value2}} error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    Class objectClass = [NSObject class];
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
    
    AUTThemeApplier *applier = [[AUTThemeApplier alloc] initWithTheme:theme1];
    [applier applyClassWithName:class.aut_symbol toObject:object];
    applier.theme = theme2;
    
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testApplicantMemoryManagement
{
    NSString *class = @".Class";
    
    NSDictionary *rawTheme = @{class: @{}};
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithRawTheme:rawTheme error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    NSObject *object = [NSObject new];
    AUTThemeApplier *themeApplier = [[AUTThemeApplier alloc] initWithTheme:theme];
    [themeApplier applyClassWithName:class.aut_symbol toObject:object];
    
    NSHashTable *classApplicants = themeApplier.applicants[class.aut_symbol];
    XCTAssertNotNil(classApplicants, @"Must have an applicants hash table for the specified class");
    XCTAssertEqual(classApplicants.count, 1, @"Must have only one applicant added");
    // Ensure that autoreleased reference to object does no stay around and bump up the retain count of object for the duration of the test
    @autoreleasepool {
        XCTAssertTrue([classApplicants containsObject:object], @"Applicants must contain object which has theme applied to it");
    }
    
    CFIndex objectRetainCount = CFGetRetainCount((void *)object);
    XCTAssertEqual(objectRetainCount, 1, @"The object reference held onto by the applier should not be strong");
    
    // Deallocate object that had theme applied to it
    object = nil;
    
    // Must query `-[NSHashTable allObjects].count` because the hash table contains a nil reference at this point and has yet to clean it up and reconcile its count
    XCTAssertEqual(classApplicants.allObjects.count, 0, @"After object is deallocated, applicants must no longer contain it");
}

@end
