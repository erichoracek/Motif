//
//  AUTThemeTests.m
//  Tests
//
//  Created by Eric Horacek on 12/23/14.
//
//

#import <XCTest/XCTest.h>
#import <AUTTheming/AUTTheming.h>
#import <AUTTheming/AUTTheme_Private.h>

@interface AUTThemeLoadingTests : XCTestCase

@end

@implementation AUTThemeLoadingTests

#pragma mark - File Tests

- (void)testNonFileURLIsInvalid
{
    NSError *error;
    AUTTheme *theme;
    
    XCTestExpectation *exceptionExpectation = [self expectationWithDescription:@"Exception should be thrown when JSON file URL is invalid"];
    @try {
        theme = [[AUTTheme alloc] initWithJSONFile:[NSURL URLWithString:@"http://www.google.com"] error:&error];
    }
    @catch (NSException *exception) {
        [exceptionExpectation fulfill];
    }
    
    [self waitForExpectationsWithTimeout:0.0 handler:nil];
}

- (void)testNonExistentFileURLIsInvalid
{
    // Generate a non-existent file with a random UUID filename
    NSURL *documentsDirectory = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
    NSUUID *UUID = [NSUUID new];
    NSURL *fileURL = [documentsDirectory URLByAppendingPathComponent:UUID.UUIDString];
    
    NSError *error;
    AUTTheme *theme;
    
    XCTestExpectation *exceptionExpectation = [self expectationWithDescription:@"Exception should be thrown when JSON file URL is invalid"];
    @try {
        theme = [[AUTTheme alloc] initWithJSONFile:fileURL error:&error];
    }
    @catch (NSException *exception) {
        [exceptionExpectation fulfill];
    }
    
    [self waitForExpectationsWithTimeout:0.0 handler:nil];
}

- (void)testInvalidJSONFileIsInvalid
{
    NSURL *fileURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"InvalidJSONTheme" withExtension:@"json"];
    
    NSError *error;
    AUTTheme *theme;
    
    XCTestExpectation *exceptionExpectation = [self expectationWithDescription:@"Exception should be thrown when JSON file URL is invalid"];
    @try {
        theme = [[AUTTheme alloc] initWithJSONFile:fileURL error:&error];
    }
    @catch (NSException *exception) {
        [exceptionExpectation fulfill];
    }
    
    [self waitForExpectationsWithTimeout:0.0 handler:nil];
}

- (void)testJSONFileIsAdded
{
    NSURL *fileURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"BasicTheme" withExtension:@"json"];
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithJSONFile:fileURL error:&error];
    
    XCTAssertNotNil(theme, @"Theme must be non-nil");
    XCTAssertNil(error, @"Error must be nil with basic theme");
}

#pragma mark - Theme Names

- (void)testThemeNameMatchesFilename
{
    NSString *themeName = @"Basic";
    NSURL *fileURL = [[NSBundle bundleForClass:[self class]] URLForResource:themeName withExtension:@"json"];
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithJSONFile:fileURL error:&error];
    
    XCTAssertNotNil(theme, @"Theme must be non-nil");
    XCTAssertNil(error, @"Error must be nil when loading valid theme");
    XCTAssertEqualObjects(theme.names.firstObject, themeName, @"Theme must contain filename without extension");
}

- (void)testThemeNameMatchesFilenameAndTrimsTheme
{
    NSString *themeName = @"Basic";
    NSString *themeFilename = [NSString stringWithFormat:@"%@Theme", themeName];
    NSURL *fileURL = [[NSBundle bundleForClass:[self class]] URLForResource:themeFilename withExtension:@"json"];
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithJSONFile:fileURL error:&error];
    
    XCTAssertNotNil(theme, @"Theme must be non-nil");
    XCTAssertNil(error, @"Error must be nil when loading valid theme");
    XCTAssertEqualObjects(theme.names.firstObject, themeName, @"Theme must contain filename without extension");
}

- (void)testThemeNameMatchesFilenameWithoutExtension
{
    NSString *themeName = @"BasicThemeWithNoExtension";
    NSURL *fileURL = [[NSBundle bundleForClass:[self class]] URLForResource:themeName withExtension:nil];
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithJSONFile:fileURL error:&error];
    
    XCTAssertNil(error, @"Error must be nil when loading valid theme");
    XCTAssertTrue([theme.names containsObject:themeName], @"Theme must contain theme filename after it is added");
}

@end
