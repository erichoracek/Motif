//
//  AUTThemeClassInheritanceTests.m
//  Tests
//
//  Created by Eric Horacek on 12/25/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AUTTheming/AUTTheming.h>
#import <AutTheming/AUTTheme+Private.h>

@interface AUTThemeClassInheritanceTests : XCTestCase

@end

@implementation AUTThemeClassInheritanceTests

- (void)testInheritanceBetweenClasses
{
    AUTTheme *theme = [AUTTheme new];
    
    NSString *superclass = @"superclass";
    NSString *subclass = @"subclass";
    NSString *superclassProperty = @"property1";
    NSString *subclassProperty = @"property2";
    NSString *value = @"value";
    
    NSDictionary *themeAttributesDictionary = @{
        AUTThemeClassesKey: @{
            superclass: @{
                superclassProperty: value,
            },
            subclass: @{
                AUTThemeSuperclassKey: superclass,
                subclassProperty: value
            }
        }
    };
    
    NSError *error;
    [theme addConstantsAndClassesFromRawAttributesDictionary:themeAttributesDictionary forThemeWithName:@"" error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    AUTThemeClass *superclassThemeClass = [theme themeClassForName:superclass];
    AUTThemeClass *subclassThemeClass = [theme themeClassForName:subclass];
    XCTAssertNotNil(superclassThemeClass);
    XCTAssertNotNil(subclassThemeClass);
    
    id superclassPropertyValue = superclassThemeClass.properties[superclassProperty];
    id subclassPropertyValue = subclassThemeClass.properties[superclassProperty];
    XCTAssertNotNil(superclassPropertyValue);
    XCTAssertNotNil(subclassPropertyValue);
    
    XCTAssertEqualObjects(superclassPropertyValue, subclassPropertyValue);
}

- (void)testInvalidSuperclassValue
{
    AUTTheme *theme = [AUTTheme new];
    
    NSString *class = @"class";
    NSString *nonexistentClass = @"nonexistentClass";
    NSString *property = @"property";
    NSString *value = @"value";
    
    NSDictionary *themeAttributesDictionary = @{
        AUTThemeClassesKey: @{
            class: @{
                AUTThemeSuperclassKey: nonexistentClass,
                property: value
            }
        }
    };
    
    NSError *error;
    [theme addConstantsAndClassesFromRawAttributesDictionary:themeAttributesDictionary forThemeWithName:@"" error:&error];
    XCTAssertNotNil(error, @"Must have error with invalid superclass value");
    XCTAssertEqual(error.domain, AUTThemingErrorDomain, @"Must have AUTTheming error domain");
}

@end
