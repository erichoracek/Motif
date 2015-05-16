//
//  MTFThemeTests.m
//  MotifTests
//
//  Created by Eric Horacek on 12/23/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Motif.h"
#import "MTFTheme_Private.h"

@interface MTFThemeLoadingTests : XCTestCase

@end

@implementation MTFThemeLoadingTests

#pragma mark - File Tests

- (void)testNonFileURLIsInvalid {
    NSURL *URL = [NSURL URLWithString:@"http://www.google.com"];

    MTFTheme *theme;
    XCTAssertThrows(
        theme = [[MTFTheme alloc] initWithJSONFile:URL error:nil],
        @"Exception should be thrown when JSON file URL is invalid");
}

- (void)testNonExistentFileURLIsInvalid
{
    // Generate a non-existent file with a random UUID filename
    NSURL *documentsDirectory = [NSFileManager.defaultManager
        URLsForDirectory:NSDocumentDirectory
        inDomains:NSUserDomainMask].lastObject;
    
    NSUUID *UUID = [NSUUID new];
    
    NSURL *fileURL = [documentsDirectory URLByAppendingPathComponent:UUID.UUIDString];

    MTFTheme *theme;
    XCTAssertThrows(
        theme = [[MTFTheme alloc] initWithJSONFile:fileURL error:nil],
        @"Exception should be thrown when JSON file URL is invalid");
}

- (void)testInvalidJSONFileIsInvalid {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSURL *fileURL = [bundle
        URLForResource:@"InvalidJSONTheme"
        withExtension:@"json"];

    MTFTheme *theme;
    XCTAssertThrows(
        theme = [[MTFTheme alloc] initWithJSONFile:fileURL error:nil],
        @"Exception should be thrown when JSON file URL is invalid");
}

- (void)testJSONFileIsAdded {
    NSURL *fileURL = [[NSBundle bundleForClass:self.class] URLForResource:@"BasicTheme" withExtension:@"json"];
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc] initWithJSONFile:fileURL error:&error];
    
    XCTAssertNotNil(theme, @"Theme must be non-nil");
    XCTAssertNil(error, @"Error must be nil with basic theme");
}

#pragma mark - Theme Names

- (void)testThemeNameMatchesFilename {
    NSString *themeName = @"Basic";
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSURL *fileURL = [bundle URLForResource:themeName withExtension:@"json"];
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc] initWithJSONFile:fileURL error:&error];
    
    XCTAssertNotNil(theme, @"Theme must be non-nil");
    XCTAssertNil(error, @"Error must be nil when loading valid theme");
    XCTAssertEqualObjects(theme.names.firstObject, themeName, @"Theme must contain filename without extension");
}

- (void)testThemeNameMatchesFilenameAndTrimsTheme {
    NSString *themeName = @"Basic";
    NSString *themeFilename = [NSString stringWithFormat:@"%@Theme", themeName];
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSURL *fileURL = [bundle URLForResource:themeFilename withExtension:@"json"];
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc] initWithJSONFile:fileURL error:&error];
    
    XCTAssertNotNil(theme, @"Theme must be non-nil");
    XCTAssertNil(error, @"Error must be nil when loading valid theme");
    XCTAssertEqualObjects(theme.names.firstObject, themeName, @"Theme must contain filename without extension");
}

- (void)testThemeNameMatchesFilenameWithoutExtension {
    NSString *themeName = @"BasicThemeWithNoExtension";
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSURL *fileURL = [bundle URLForResource:themeName withExtension:nil];
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc] initWithJSONFile:fileURL error:&error];
    
    XCTAssertNil(error, @"Error must be nil when loading valid theme");
    XCTAssertTrue([theme.names containsObject:themeName], @"Theme must contain theme filename after it is added");
}

@end
