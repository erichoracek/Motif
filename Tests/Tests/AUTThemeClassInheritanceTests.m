//
//  AUTThemeClassInheritanceTests.m
//  Tests
//
//  Created by Eric Horacek on 12/25/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AUTTheming/AUTTheming.h>
#import <AUTTheming/AUTTheme+Private.h>
#import <AUTTheming/NSString+ThemeSymbols.h>

@interface AUTThemeClassInheritanceTests : XCTestCase

@end

@implementation AUTThemeClassInheritanceTests

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
            AUTThemeSuperclassKey: superclass,
            subclassProperty: value
        }
    };
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithRawTheme:rawTheme error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    AUTThemeClass *superclassThemeClass = [theme themeClassForName:superclass.aut_symbol];
    AUTThemeClass *subclassThemeClass = [theme themeClassForName:superclass.aut_symbol];
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
            AUTThemeSuperclassKey: superclass,
            subclassProperty: value
        }
    };
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithRawThemes:@[rawTheme1, rawTheme2] error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    AUTThemeClass *superclassThemeClass = [theme themeClassForName:superclass.aut_symbol];
    AUTThemeClass *subclassThemeClass = [theme themeClassForName:superclass.aut_symbol];
    XCTAssertNotNil(superclassThemeClass);
    XCTAssertNotNil(subclassThemeClass);
    
    id superclassPropertyValue = superclassThemeClass.properties[superclassProperty];
    id subclassPropertyValue = subclassThemeClass.properties[superclassProperty];
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
            AUTThemeSuperclassKey: constant,
            property: value
        }
    };
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithRawTheme:rawTheme error:&error];
    XCTAssertNotNil(theme);
    XCTAssertNotNil(error, @"Must have error with invalid superclass value");
    XCTAssertEqual(error.domain, AUTThemingErrorDomain, @"Must have AUTTheming error domain");
}

- (void)testInvalidSuperclassClassValue
{
    NSString *class = @".Class";
    NSString *nonexistentClass = @".NonexistentClass";
    NSString *property = @"property";
    NSString *value = @"value";
    
    NSDictionary *rawTheme = @{
        class: @{
            AUTThemeSuperclassKey: nonexistentClass,
            property: value
        }
    };
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithRawTheme:rawTheme error:&error];
    XCTAssertNotNil(theme);
    XCTAssertNotNil(error, @"Must have error with invalid superclass value");
    XCTAssertEqual(error.domain, AUTThemingErrorDomain, @"Must have AUTTheming error domain");
}

@end
