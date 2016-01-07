//
//  MTFLiveReloadThemeApplierSpec.m
//  Motif
//
//  Created by Eric Horacek on 1/10/16.
//  Copyright © 2016 Eric Horacek. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <Motif/Motif.h>
#import <Motif/NSString+ThemeSymbols.h>

#import "MTFTestApplicants.h"

SpecBegin(MTFLiveReloadThemeApplier)

__block BOOL success;
__block NSError *error;
__block NSURL *temporaryDirectoryURL;
__block NSURL *themeFileURL;
__block NSURL *sourceFileURL;

beforeEach(^{
    success = NO;
    error = nil;

    temporaryDirectoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];

    NSString *themeFileName = [[NSUUID UUID].UUIDString stringByAppendingString:@".json"];
    themeFileURL = [temporaryDirectoryURL URLByAppendingPathComponent:themeFileName];

    NSString *sourceFileName = [NSUUID UUID].UUIDString;
    sourceFileURL = [temporaryDirectoryURL URLByAppendingPathComponent:sourceFileName];

    // Ensure that the source file URL is a valid file.
    success = [@"test" writeToURL:sourceFileURL atomically:YES encoding:NSUTF8StringEncoding error:&error];
    expect(success).to.beTruthy();
    expect(error).to.beNil();
});

afterEach(^{
    success = [NSFileManager.defaultManager removeItemAtURL:themeFileURL error:&error];
    expect(success).to.beTruthy();
    expect(error).to.beNil();

    success = [NSFileManager.defaultManager removeItemAtURL:sourceFileURL error:&error];
    expect(success).to.beTruthy();
    expect(error).to.beNil();
});

BOOL (^writeJSONObject)(id, NSURL *, NSError **) = ^(id JSONObject, NSURL *url, NSError **error) {
    NSData *data = [NSJSONSerialization dataWithJSONObject:JSONObject options:0 error:error];
    if (data == nil) return NO;

    return [data writeToURL:url options:0 error:error];
};

NSString *className = @".Class";
NSString *property = NSStringFromSelector(@selector(stringValue));
NSString *value1 = @"string1";
NSString *value2 = @"string2";

it(@"should apply live-reloaded theme files", ^{
    success = writeJSONObject(@{ className : @{ property: value1 } }, themeFileURL, &error);
    expect(success).to.beTruthy();
    expect(error).to.beNil();

    MTFTheme *theme = [[MTFTheme alloc] initWithFile:themeFileURL error:&error];
    expect(theme).to.beAnInstanceOf(MTFTheme.class);
    expect(error).to.beNil();

    MTFLiveReloadThemeApplier *applier = [[MTFLiveReloadThemeApplier alloc]
        initWithTheme:theme
        sourceFile:(char *)sourceFileURL.fileSystemRepresentation];

    MTFTestObjCClassPropertiesApplicant *applicant = [[MTFTestObjCClassPropertiesApplicant alloc] init];
    success = [applier applyClassWithName:className.mtf_symbol to:applicant error:&error];
    expect(success).to.beTruthy();
    expect(error).to.beNil();
    expect(applicant.stringValue).to.equal(value1);

    // Wait for one second to allow for dispatch sources to setup properly
    [NSRunLoop.mainRunLoop runUntilDate:[[NSDate date] dateByAddingTimeInterval:1.0]];

    success = writeJSONObject(@{ className : @{ property: value2 } }, themeFileURL, &error);
    expect(success).to.beTruthy();
    expect(error).to.beNil();

    expect(applicant.stringValue).will.equal(value2);
});

SpecEnd
