//
//  AUTThemeTests.m
//  Tests
//
//  Created by Eric Horacek on 12/23/14.
//
//

#import <XCTest/XCTest.h>
#import <AUTTheming/AUTTheming.h>
#import <AUTTheming/AUTTheme+Private.h>

@interface AUTThemeLoadingTests : XCTestCase

@end

@implementation AUTThemeLoadingTests

#pragma mark - File Tests

- (void)testNonFileURLIsInvalid
{
    AUTTheme *theme = [AUTTheme new];
    
    NSError *error;
    [theme addAttributesFromThemeAtURL:[NSURL URLWithString:@"http://www.google.com"] error:&error];
    
    XCTAssertNotNil(error, @"Must throw error with non-filesystem URL is specified for theme");
    XCTAssertEqual(error.domain, AUTThemingErrorDomain, @"Must have AUTTheming error domain");
}

- (void)testNonExistentFileURLIsInvalid
{
    AUTTheme *theme = [AUTTheme new];
    
    // Generate a non-existent file with a random UUID filename
    NSURL *documentsDirectory = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
    NSUUID *UUID = [NSUUID new];
    NSURL *URL = [documentsDirectory URLByAppendingPathComponent:UUID.UUIDString];
    
    NSError *error;
    [theme addAttributesFromThemeAtURL:URL error:&error];
    
    XCTAssertNotNil(error, @"Must throw error with non-existent file URL is specified for theme");
    XCTAssertEqual(error.domain, NSCocoaErrorDomain, @"Must have cocoa error domain");
    XCTAssertEqual(error.code, 260, @"Must be 'No such file or directory' error");
}

- (void)testInvalidJSONFileIsInvalid
{
    AUTTheme *theme = [AUTTheme new];
    
    NSURL *URL = [[NSBundle bundleForClass:[self class]] URLForResource:@"InvalidJSONTheme" withExtension:@"json"];
    
    NSError *error;
    [theme addAttributesFromThemeAtURL:URL error:&error];
    
    XCTAssertNotNil(error, @"Must throw error with non-existent file URL is specified for theme");
    XCTAssertEqual(error.domain, NSCocoaErrorDomain, @"Must have cocoa error domain");
    XCTAssertEqual(error.code, 3840, @"Must be 'Badly formed object character' error code");
}

- (void)testJSONFileIsAdded
{
    AUTTheme *theme = [AUTTheme new];

    NSURL *URL = [[NSBundle bundleForClass:[self class]] URLForResource:@"BasicTheme" withExtension:@"json"];
    
    NSError *error;
    [theme addAttributesFromThemeAtURL:URL error:&error];
    
    XCTAssertNil(error, @"Error must be nil with basic theme");
}

#pragma mark - Theme Names

- (void)testThemeNameMatchesFilename
{
    AUTTheme *theme = [AUTTheme new];
    
    NSString *themeName = @"BasicTheme";
    NSURL *URL = [[NSBundle bundleForClass:[self class]] URLForResource:themeName withExtension:@"json"];
    
    NSError *error;
    [theme addAttributesFromThemeAtURL:URL error:&error];
    
    XCTAssertNil(error, @"Error must be nil when loading valid theme");
}

- (void)testThemeNameMatchesFilenameWithoutExtension
{
    AUTTheme *theme = [AUTTheme new];
    
    NSString *themeName = @"BasicThemeWithNoExtension";
    NSURL *URL = [[NSBundle bundleForClass:[self class]] URLForResource:themeName withExtension:nil];
    
    NSError *error;
    [theme addAttributesFromThemeAtURL:URL error:&error];
    
    XCTAssertNil(error, @"Error must be nil when loading valid theme");
    XCTAssertTrue([theme.names containsObject:themeName], @"Theme must contain theme filename after it is added");
}

@end
