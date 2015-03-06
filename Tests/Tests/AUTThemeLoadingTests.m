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
    AUTTheme *theme = [[AUTTheme alloc] initWithFile:[NSURL URLWithString:@"http://www.google.com"] error:&error];
    
    XCTAssertNotNil(theme, @"Theme must be non-nil");
    XCTAssertNotNil(error, @"Must throw error with non-filesystem URL is specified for theme");
    XCTAssertEqual(error.domain, AUTThemingErrorDomain, @"Must have AUTTheming error domain");
}

- (void)testNonExistentFileURLIsInvalid
{
    // Generate a non-existent file with a random UUID filename
    NSURL *documentsDirectory = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
    NSUUID *UUID = [NSUUID new];
    NSURL *fileURL = [documentsDirectory URLByAppendingPathComponent:UUID.UUIDString];
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithFile:fileURL error:&error];
    
    XCTAssertNotNil(theme, @"Theme must be non-nil");
    XCTAssertNotNil(error, @"Must throw error with non-existent file URL is specified for theme");
    XCTAssertEqual(error.domain, NSCocoaErrorDomain, @"Must have cocoa error domain");
    XCTAssertEqual(error.code, 260, @"Must be 'No such file or directory' error");
}

- (void)testInvalidJSONFileIsInvalid
{
    NSURL *fileURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"InvalidJSONTheme" withExtension:@"json"];
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithFile:fileURL error:&error];
    
    XCTAssertNotNil(theme, @"Theme must be non-nil");
    XCTAssertNotNil(error, @"Must throw error with non-existent file URL is specified for theme");
    XCTAssertEqual(error.domain, NSCocoaErrorDomain, @"Must have cocoa error domain");
    XCTAssertEqual(error.code, 3840, @"Must be 'Badly formed object character' error code");
}

- (void)testJSONFileIsAdded
{
    NSURL *fileURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"BasicTheme" withExtension:@"json"];
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithFile:fileURL error:&error];
    
    XCTAssertNotNil(theme, @"Theme must be non-nil");
    XCTAssertNil(error, @"Error must be nil with basic theme");
}

#pragma mark - Theme Names

- (void)testThemeNameMatchesFilename
{
    NSString *themeName = @"Basic";
    NSURL *fileURL = [[NSBundle bundleForClass:[self class]] URLForResource:themeName withExtension:@"json"];
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithFile:fileURL error:&error];
    
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
    AUTTheme *theme = [[AUTTheme alloc] initWithFile:fileURL error:&error];
    
    XCTAssertNotNil(theme, @"Theme must be non-nil");
    XCTAssertNil(error, @"Error must be nil when loading valid theme");
    XCTAssertEqualObjects(theme.names.firstObject, themeName, @"Theme must contain filename without extension");
}

- (void)testThemeNameMatchesFilenameWithoutExtension
{
    NSString *themeName = @"BasicThemeWithNoExtension";
    NSURL *fileURL = [[NSBundle bundleForClass:[self class]] URLForResource:themeName withExtension:nil];
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithFile:fileURL error:&error];
    
    XCTAssertNil(error, @"Error must be nil when loading valid theme");
    XCTAssertTrue([theme.names containsObject:themeName], @"Theme must contain theme filename after it is added");
}

@end
