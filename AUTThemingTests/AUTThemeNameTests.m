//
//  AUTThemeNameTests.m
//  Tests
//
//  Created by Eric Horacek on 3/7/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "NSURL+ThemeNaming.h"

@interface AUTThemeNameTests : XCTestCase

@end

@implementation AUTThemeNameTests

- (void)testThemeName
{
    NSString *name = @"Name";
    NSString *URLString = [NSString stringWithFormat:@"file:///%@.json", name];
    NSURL *themeName = [NSURL URLWithString:URLString];
    XCTAssertEqualObjects(themeName.aut_themeName, name);
}

- (void)testThemeNamedThemeIsNotTrimmed
{
    NSString *name = @"Theme";
    NSString *URLString = [NSString stringWithFormat:@"file:///%@.json", name];
    NSURL *themeName = [NSURL URLWithString:URLString];
    XCTAssertEqualObjects(themeName.aut_themeName, name);
}

- (void)testThemeNameWithOptionalSuffixIsTrimmed
{
    NSString *optionalSuffix = @"Theme";
    NSString *name = @"Name";
    NSString *URLString = [NSString stringWithFormat:
        @"file:///%@%@.json",
        name,
        optionalSuffix];
    NSURL *themeName = [NSURL URLWithString:URLString];
    XCTAssertEqualObjects(themeName.aut_themeName, name);
}

@end
