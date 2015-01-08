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

@interface AUTThemeApplierTests : XCTestCase

@end

@implementation AUTThemeApplierTests

- (void)testApplicantMemoryManagement
{
    NSString *className = @"Class";
    
    AUTTheme *theme = [AUTTheme new];
    NSError *error;
    [theme addConstantsAndClassesFromRawAttributesDictionary:@{
        AUTThemeClassesKey: @{
            className: @{}
        }
    } forThemeWithName:@"" error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    NSObject *object = [NSObject new];
    AUTThemeApplier *themeApplier = [[AUTThemeApplier alloc] initWithTheme:theme];
    [themeApplier applyClassWithName:className toObject:object];
    
    NSHashTable *classApplicants = themeApplier.applicants[className];
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
