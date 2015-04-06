//
//  MTFThemeClassTests.m
//  MotifTests
//
//  Created by Eric Horacek on 12/24/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Motif.h"
#import "MTFTheme_Private.h"
#import "MTFThemeClass_Private.h"
#import "NSString+ThemeSymbols.h"

@interface MTFThemeClassTests : XCTestCase

@end

@implementation MTFThemeClassTests

- (void)testClassMappingInvalidClassObjectClassError
{
    NSDictionary *rawTheme = @{@".Class": @0};
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc]
        initWithThemeDictionary:rawTheme
        error:&error];
    
    XCTAssertNotNil(theme);
    XCTAssert(error, @"Must have error with invalid class object class");
    XCTAssertEqual(error.domain, MTFThemingErrorDomain, @"Must have MTFTheming error domain");
}

- (void)testClassMappingPropertyToValue
{
    NSString *class = @".Class";
    NSString *property = @"property";
    NSString *value = @"value";
    
    NSDictionary *rawTheme = @{
        class: @{
            property: value
        }
    };
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc]
        initWithThemeDictionary:rawTheme
        error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    MTFThemeClass *themeClass = [theme classForName:class.mtf_symbol];
    XCTAssertNotNil(themeClass, @"Class must exist when registered");
    
    id valueForProperty = themeClass.properties[property];
    
    XCTAssertNotNil(valueForProperty, @"The theme class must have '%@' as a property", property);
    XCTAssertEqualObjects(valueForProperty, value, @"The theme class must have '%@' as a value for the '%@' property", value, property);
}

- (void)testClassMappingPropertyToValueFromConstant
{
    NSString *class = @".Class";
    NSString *property = @"property";
    NSString *value = @"value";
    NSString *constant = @"$Constant";
    
    NSDictionary *rawTheme = @{
        constant: value,
        class: @{
            property: constant
        }
    };
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc]
        initWithThemeDictionary:rawTheme
        error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    MTFThemeClass *themeClass = [theme classForName:class.mtf_symbol];
    XCTAssertNotNil(themeClass, @"Class must exist when registered");
    
    id valueForProperty = themeClass.properties[property];
    
    XCTAssertNotNil(valueForProperty, @"The theme class must have '%@' as a property", property);
    XCTAssertEqualObjects(valueForProperty, value, @"The theme class must have '%@' as a value for the '%@' property", value, property);
}

- (void)testClassToClassMappingFromPropertyValueWithinTheme
{
    NSString *class1 = @".Class1";
    NSString *class2 = @".Class2";
    NSString *property = @"property";
    NSString *classProperty = @"class1Property";
    NSString *value = @"value";
    
    NSDictionary *rawTheme = @{
        class1: @{
            property: value
        },
        class2: @{
            classProperty: class1
        }
    };
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc]
        initWithThemeDictionary:rawTheme
        error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    MTFThemeClass *themeClass1 = [theme classForName:class1.mtf_symbol];
    XCTAssertNotNil(themeClass1, @"Class must exist when registered");
    MTFThemeClass *themeClass2 = [theme classForName:class2.mtf_symbol];
    XCTAssertNotNil(themeClass2, @"Class must exist when registered");

    id valueForProperty = themeClass2.properties[classProperty];
    
    XCTAssertNotNil(valueForProperty, @"Theme class must have '%@' as a property", class1);
    XCTAssertTrue([valueForProperty isKindOfClass:MTFThemeClass.class], @"Class %@ must be of theme class", classProperty);
    XCTAssertEqualObjects(valueForProperty, themeClass1, @"The theme class must have '%@' as a value for the '%@' property", value, property);
}

- (void)testClassToClassMappingFromPropertyValueBetweenThemes
{
    NSString *class1 = @".Class1";
    NSString *class2 = @".Class2";
    NSString *property = @"property";
    NSString *classProperty = @"class1Property";
    NSString *value = @"value";
    
    NSDictionary *rawTheme1 = @{
        class1: @{
            property: value
        }
    };
    NSDictionary *rawTheme2 = @{
        class2: @{
            classProperty: class1
        }
    };
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc]
        initWithThemeDictionaries:@[rawTheme1, rawTheme2]
        error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    MTFThemeClass *themeClass1 = [theme classForName:class1.mtf_symbol];
    XCTAssertNotNil(themeClass1, @"Class must exist when registered");
    MTFThemeClass *themeClass2 = [theme classForName:class2.mtf_symbol];
    XCTAssertNotNil(themeClass2, @"Class must exist when registered");

    id valueForProperty = themeClass2.properties[classProperty];
    
    XCTAssertNotNil(valueForProperty, @"Theme class must have '%@' as a property", class1);
    XCTAssertTrue([valueForProperty isKindOfClass:MTFThemeClass.class], @"Class %@ must be of theme class", classProperty);
    XCTAssertEqualObjects(valueForProperty, themeClass1, @"The theme class must have '%@' as a value for the '%@' property", value, property);
}

#pragma mark - Identical Classes

- (void)testRegisteringMultipleClassesWithIdenticalNamesAcrossThemes
{
    NSString *class = @".Class";
    NSString *value1 = @"value1";
    NSString *property1 = @"property1";
    NSString *value2 = @"value2";
    NSString *property2 = @"property2";
    
    NSDictionary *rawTheme1 = @{
        class: @{
            property1: value1
        }
    };
    NSDictionary *rawTheme2 = @{
        class: @{
            property2: value2
        }
    };
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc]
        initWithThemeDictionaries:@[rawTheme1, rawTheme2]
        error:&error];
    XCTAssertNotNil(error, @"Must have error when class with duplicate name is registered");
    
    MTFThemeClass *themeClass = [theme classForName:class.mtf_symbol];
    XCTAssertNotNil(themeClass, @"Class must exist when registered");
    
    id valueForProperty1 = themeClass.properties[property1];
    XCTAssertNil(valueForProperty1, @"Original class property must no longer exist when overwritten");
    
    id valueForProperty2 = themeClass.properties[property2];
    XCTAssertNotNil(valueForProperty2, @"Overwritten class property must exist");
    XCTAssertEqualObjects(value2, valueForProperty2, @"Value must match registered property");
}

@end
