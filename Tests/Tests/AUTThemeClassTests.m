//
//  AUTThemeClassTests.m
//  Tests
//
//  Created by Eric Horacek on 12/24/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <AUTTheming/AUTTheming.h>
#import <AUTTheming/AUTTheme+Private.h>
#import <AUTTheming/AUTThemeClass+Private.h>

@interface AUTThemeClassTests : XCTestCase

@end

@implementation AUTThemeClassTests

- (void)testClassMappingInvalidClassObjectError
{
    AUTTheme *theme = [AUTTheme new];
    
    NSDictionary *themeAttributesDictionary = @{AUTThemeClassesKey: @0};
    
    NSError *error;
    [theme addConstantsAndClassesFromRawAttributesDictionary:themeAttributesDictionary forThemeWithName:@"" error:&error];
    
    XCTAssert(error, @"Must have error with invalid class object");
    XCTAssertEqual(error.domain, AUTThemingErrorDomain, @"Must have AUTTheming error domain");
}

- (void)testClassMappingInvalidClassObjectClassError
{
    AUTTheme *theme = [AUTTheme new];
    
    NSDictionary *themeAttributesDictionary = @{AUTThemeClassesKey:@{@"class": @0}};
    
    NSError *error;
    [theme addConstantsAndClassesFromRawAttributesDictionary:themeAttributesDictionary forThemeWithName:@"" error:&error];
    
    XCTAssert(error, @"Must have error with invalid class object class");
    XCTAssertEqual(error.domain, AUTThemingErrorDomain, @"Must have AUTTheming error domain");
}

- (void)testClassMappingPropertyToValue
{
    AUTTheme *theme = [AUTTheme new];
    
    NSString *class = @"class";
    NSString *property = @"property";
    NSString *value = @"value";
    
    NSDictionary *themeAttributesDictionary = @{
        AUTThemeClassesKey: @{
            class: @{
                property: value
            }
        }
    };
    
    NSError *error;
    [theme addConstantsAndClassesFromRawAttributesDictionary:themeAttributesDictionary forThemeWithName:@"" error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    AUTThemeClass *themeClass = [theme themeClassForName:class];
    XCTAssertNotNil(themeClass, @"Class must exist when registered");
    
    id valueForProperty = themeClass.properties[property];
    
    XCTAssertNotNil(valueForProperty, @"The theme class must have '%@' as a property", property);
    XCTAssertEqualObjects(valueForProperty, value, @"The theme class must have '%@' as a value for the '%@' property", value, property);
}

- (void)testClassMappingPropertyToValueFromConstant
{
    AUTTheme *theme = [AUTTheme new];
    
    NSString *class = @"class";
    NSString *property = @"property";
    NSString *value = @"value";
    NSString *constant = @"constant";
    
    NSDictionary *themeAttributesDictionary = @{
        AUTThemeConstantsKey: @{
            constant: value
        },
        AUTThemeClassesKey: @{
            class: @{
                property: constant
            }
        }
    };
    
    NSError *error;
    [theme addConstantsAndClassesFromRawAttributesDictionary:themeAttributesDictionary forThemeWithName:@"" error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    AUTThemeClass *themeClass = [theme themeClassForName:class];
    XCTAssertNotNil(themeClass, @"Class must exist when registered");
    
    id valueForProperty = themeClass.properties[property];
    
    XCTAssertNotNil(valueForProperty, @"The theme class must have '%@' as a property", property);
    XCTAssertEqualObjects(valueForProperty, value, @"The theme class must have '%@' as a value for the '%@' property", value, property);
}

- (void)testClassToClassMappingFromPropertyValueWithinTheme
{
    AUTTheme *theme = [AUTTheme new];
    
    NSString *class1 = @"class1";
    NSString *class2 = @"class2";
    NSString *property = @"property";
    NSString *classProperty = @"class1Property";
    NSString *value = @"value";
    
    NSDictionary *themeAttributesDictionary = @{
        AUTThemeClassesKey: @{
            class1: @{
                property: value
            },
            class2: @{
                classProperty: class1
            }
        }
    };
    
    NSError *error;
    [theme addConstantsAndClassesFromRawAttributesDictionary:themeAttributesDictionary forThemeWithName:@"" error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    AUTThemeClass *themeClass1 = [theme themeClassForName:class1];
    XCTAssertNotNil(themeClass1, @"Class must exist when registered");
    AUTThemeClass *themeClass2 = [theme themeClassForName:class2];
    XCTAssertNotNil(themeClass2, @"Class must exist when registered");

    id valueForProperty = themeClass2.properties[classProperty];
    
    XCTAssertNotNil(valueForProperty, @"Theme class must have '%@' as a property", class1);
    XCTAssertTrue([valueForProperty isKindOfClass:[AUTThemeClass class]], @"Class %@ must be of theme class", classProperty);
    XCTAssertEqualObjects(valueForProperty, themeClass1, @"The theme class must have '%@' as a value for the '%@' property", value, property);
}

- (void)testClassToClassMappingFromPropertyValueBetweenThemes
{
    AUTTheme *theme = [AUTTheme new];
    
    NSString *class1 = @"class1";
    NSString *class2 = @"class2";
    NSString *property = @"property";
    NSString *classProperty = @"class1Property";
    NSString *value = @"value";
    
    NSDictionary *theme1AttributesDictionary = @{
        AUTThemeClassesKey: @{
            class1: @{
                property: value
            }
        }
    };
    NSDictionary *theme2AttributesDictionary = @{
        AUTThemeClassesKey: @{
            class2: @{
                classProperty: class1
            }
        }
    };
    
    NSError *error;
    [theme addConstantsAndClassesFromRawAttributesDictionary:theme1AttributesDictionary forThemeWithName:@"" error:&error];
    [theme addConstantsAndClassesFromRawAttributesDictionary:theme2AttributesDictionary forThemeWithName:@"" error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    AUTThemeClass *themeClass1 = [theme themeClassForName:class1];
    XCTAssertNotNil(themeClass1, @"Class must exist when registered");
    AUTThemeClass *themeClass2 = [theme themeClassForName:class2];
    XCTAssertNotNil(themeClass2, @"Class must exist when registered");

    id valueForProperty = themeClass2.properties[classProperty];
    
    XCTAssertNotNil(valueForProperty, @"Theme class must have '%@' as a property", class1);
    XCTAssertTrue([valueForProperty isKindOfClass:[AUTThemeClass class]], @"Class %@ must be of theme class", classProperty);
    XCTAssertEqualObjects(valueForProperty, themeClass1, @"The theme class must have '%@' as a value for the '%@' property", value, property);
}

@end
