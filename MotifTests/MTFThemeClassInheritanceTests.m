//
//  MTFThemeClassInheritanceTests.m
//  MotifTests
//
//  Created by Eric Horacek on 12/25/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Motif.h"
#import "MTFTheme_Private.h"
#import "NSString+ThemeSymbols.h"

@interface MTFThemeClassInheritanceTests : XCTestCase

@end

@implementation MTFThemeClassInheritanceTests

- (void)testInheritanceWithinTheme
{
    NSString *superclass = @".Superclass";
    NSString *subclass = @".Subclass";
    NSString *superclassProperty = @"property1";
    NSString *subclassProperty = @"property2";
    NSString *value = @"value";
    
    NSDictionary *rawTheme = @{
        superclass: @{
            superclassProperty: value,
        },
        subclass: @{
            MTFThemeSuperclassKey: superclass,
            subclassProperty: value
        }
    };
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc]
        initWithThemeDictionary:rawTheme
        error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    MTFThemeClass *superclassThemeClass = [theme
        classForName:superclass.mtf_symbol];
    MTFThemeClass *subclassThemeClass = [theme
        classForName:superclass.mtf_symbol];
    XCTAssertNotNil(superclassThemeClass);
    XCTAssertNotNil(subclassThemeClass);
    
    id superclassPropertyValue = superclassThemeClass.properties[superclassProperty];
    id subclassPropertyValue = subclassThemeClass.properties[superclassProperty];
    XCTAssertNotNil(superclassPropertyValue);
    XCTAssertNotNil(subclassPropertyValue);
    
    XCTAssertEqualObjects(superclassPropertyValue, subclassPropertyValue);
}

- (void)testInheritanceBetweenThemes
{
    NSString *superclass = @".Superclass";
    NSString *subclass = @".Subclass";
    NSString *superclassProperty = @"property1";
    NSString *subclassProperty = @"property2";
    NSString *value = @"value";
    
    NSDictionary *rawTheme1 = @{
        superclass: @{
            superclassProperty: value,
        }
    };
    NSDictionary *rawTheme2 = @{
        subclass: @{
            MTFThemeSuperclassKey: superclass,
            subclassProperty: value
        }
    };
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc]
        initWithThemeDictionaries:@[rawTheme1, rawTheme2]
        error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    MTFThemeClass *superclassThemeClass = [theme
        classForName:superclass.mtf_symbol];
    MTFThemeClass *subclassThemeClass = [theme
        classForName:superclass.mtf_symbol];
    
    XCTAssertNotNil(superclassThemeClass);
    XCTAssertNotNil(subclassThemeClass);
    
    id superclassPropertyValue = superclassThemeClass.
        properties[superclassProperty];
    id subclassPropertyValue = subclassThemeClass.
        properties[superclassProperty];
    
    XCTAssertNotNil(superclassPropertyValue);
    XCTAssertNotNil(subclassPropertyValue);
    
    XCTAssertEqualObjects(superclassPropertyValue, subclassPropertyValue);
}

- (void)testInvalidSuperclassConstantValue
{
    NSString *class = @".Class";
    NSString *constant = @"$Constant";
    NSString *property = @"property";
    NSString *value = @"value";
    
    NSDictionary *rawTheme = @{
        constant: value,
        class: @{
            MTFThemeSuperclassKey: constant,
            property: value
        }
    };
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc]
        initWithThemeDictionary:rawTheme
        error:&error];
    
    XCTAssertNotNil(theme);
    XCTAssertNotNil(error, @"Must have error with invalid superclass value");
    XCTAssertEqual(error.domain, MTFThemingErrorDomain, @"Must have MTFTheming error domain");
}

- (void)testInvalidSuperclassClassValue
{
    NSString *class = @".Class";
    NSString *nonexistentClass = @".NonexistentClass";
    NSString *property = @"property";
    NSString *value = @"value";
    
    NSDictionary *rawTheme = @{
        class: @{
            MTFThemeSuperclassKey: nonexistentClass,
            property: value
        }
    };
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc]
        initWithThemeDictionary:rawTheme
        error:&error];
    
    XCTAssertNotNil(theme);
    XCTAssertNotNil(error, @"Must have error with invalid superclass value");
    XCTAssertEqual(error.domain, MTFThemingErrorDomain, @"Must have MTFTheming error domain");
}

@end
