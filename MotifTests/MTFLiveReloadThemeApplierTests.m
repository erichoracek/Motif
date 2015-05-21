//
//  MTFLiveReloadThemeApplierTests.m
//  Motif
//
//  Created by Eric Horacek on 4/27/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import <Motif/Motif.h>

@interface TestLiveReloadObject : NSObject

@property (nonatomic, copy) NSString *testLiveReloadProperty;

@end

@interface MTFLiveReloadThemeApplierTests : XCTestCase

@property (nonatomic, readonly) NSURL *themeDirectoryURL;
@property (nonatomic, readonly) NSURL *themeURL;
@property (nonatomic, readwrite) NSString *themeName;

@end

static NSString * const ClassName = @"Class";
static NSString * const PropertyValue1 = @"propertyValue1";
static NSString * const PropertyValue2 = @"propertyValue2";

@implementation MTFLiveReloadThemeApplierTests

- (void)setUp {
    [super setUp];

    self.themeName = [[NSProcessInfo processInfo] globallyUniqueString];

    [self writeJSONObject:[self themeWithPropertyValue:PropertyValue1] toURL:self.themeURL];
}

- (void)tearDown {
    [super tearDown];
    
    NSError *error;
    BOOL didRemoveFile = [NSFileManager.defaultManager removeItemAtURL:self.themeURL error:&error];
    
    XCTAssertTrue(didRemoveFile, @"Unable to remove file at location %@", self.themeURL);
}

- (void)testLiveReloadThemePropertyApplied {
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc] initWithJSONFile:self.themeURL error:&error];
    XCTAssertNil(error, @"Unable to create theme from JSON file %@", self.themeURL);
    
    MTFLiveReloadThemeApplier *applier = [[MTFLiveReloadThemeApplier alloc]
        initWithTheme:theme
        sourceDirectoryURL:self.themeDirectoryURL];
    XCTAssertNotNil(applier, @"Unable to create theme applier");
    
    TestLiveReloadObject *testObject = [TestLiveReloadObject new];
    [applier applyClassWithName:ClassName toObject:testObject];
    
    XCTAssertEqualObjects(testObject.testLiveReloadProperty, PropertyValue1);

    [self
        keyValueObservingExpectationForObject:testObject
        keyPath:NSStringFromSelector(@selector(testLiveReloadProperty))
        expectedValue:PropertyValue2];

    // Allow for file watching to be setup asynchronously
    dispatch_async(dispatch_get_main_queue(), ^{
        id JSONObject = [self themeWithPropertyValue:PropertyValue2];
        [self writeJSONObject:JSONObject toURL:self.themeURL];
    });

    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

#pragma mark - Helpers

- (NSDictionary *)themeWithPropertyValue:(NSString *)propertyvalue {
    return @{
        [NSString stringWithFormat:@".%@", ClassName]: @{
            NSStringFromSelector(@selector(testLiveReloadProperty)): propertyvalue
        }
    };
}

- (void)writeJSONObject:(id)JSONObject toURL:(NSURL *)URL {
    NSOutputStream *stream = [[NSOutputStream alloc] initWithURL:URL append:NO];
    XCTAssertNotNil(stream, @"Unable to create stream");
    
    [stream open];
    
    NSError *error;
    NSInteger bytesWritten = [NSJSONSerialization writeJSONObject:JSONObject toStream:stream options:0 error:&error];
    XCTAssertTrue(bytesWritten != 0, @"Unable to write JSON object");
    
    [stream close];
}

- (NSURL *)themeDirectoryURL {
    NSURL *URL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];

    XCTAssert([NSFileManager.defaultManager isWritableFileAtPath:URL.path], @"Temp path must be writable");

    return URL;
}

- (NSURL *)themeURL {
    NSString *pathComponent = [self.themeName stringByAppendingString:@".json"];

    return [self.themeDirectoryURL URLByAppendingPathComponent:pathComponent];
}

@end

@implementation TestLiveReloadObject

@end
