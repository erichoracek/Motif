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

@end

static NSString * const ClassName = @"Class";
static NSString * const PropertyValue1 = @"propertyValue1";
static NSString * const PropertyValue2 = @"propertyValue2";

@implementation MTFLiveReloadThemeApplierTests

- (void)setUp {
    [super setUp];
    
    [self writeJSONObject:[self themeWithPropertyValue:PropertyValue1] toURL:self.themeURL];
}

- (void)tearDown {
    [super tearDown];
    
    NSError *error;
    BOOL didRemoveFile = [NSFileManager.defaultManager removeItemAtURL:self.themeURL error:&error];
    
    XCTAssertTrue(didRemoveFile, @"Unable to remove file at location %@", self.themeURL);
}

- (void)testExample {
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc] initWithJSONFile:self.themeURL error:&error];
    XCTAssertNil(error, @"Unable to create theme from JSON file %@", self.themeURL);
    
    MTFLiveReloadThemeApplier *applier = [[MTFLiveReloadThemeApplier alloc]
        initWithTheme:theme
        sourceDirectoryPath:self.themeDirectoryURL.path];
    XCTAssertNotNil(applier, @"Unable to create theme applier");
    
    TestLiveReloadObject *testObject = [TestLiveReloadObject new];
    [applier applyClassWithName:ClassName toObject:testObject];
    
    XCTAssertEqualObjects(testObject.testLiveReloadProperty, PropertyValue1);
    
    [self writeJSONObject:[self themeWithPropertyValue:PropertyValue2] toURL:self.themeURL];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Should write value to file"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        XCTAssertEqualObjects(testObject.testLiveReloadProperty, PropertyValue2);
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
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
    NSArray *URLs = [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    XCTAssertEqual(URLs.count, (NSUInteger)1, @"Unable to locate user documents directory");
    NSURL *URL = URLs.firstObject;
    
    return URL;
}

- (NSURL *)themeURL {
    return [self.themeDirectoryURL URLByAppendingPathComponent:@"Theme.json"];
}


@end

@implementation TestLiveReloadObject

@end
