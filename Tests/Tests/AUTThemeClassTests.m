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
    NSDictionary *rawAttributesDictionary = @{AUTThemeClassesKey: @0};
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithRawAttributesDictionary:rawAttributesDictionary error:&error];
    
    XCTAssertNotNil(theme);
    XCTAssert(error, @"Must have error with invalid class object");
    XCTAssertEqual(error.domain, AUTThemingErrorDomain, @"Must have AUTTheming error domain");
}

- (void)testClassMappingInvalidClassObjectClassError
{
    NSDictionary *rawAttributesDictionary = @{AUTThemeClassesKey:@{@"class": @0}};
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithRawAttributesDictionary:rawAttributesDictionary error:&error];
    
    XCTAssertNotNil(theme);
    XCTAssert(error, @"Must have error with invalid class object class");
    XCTAssertEqual(error.domain, AUTThemingErrorDomain, @"Must have AUTTheming error domain");
}

- (void)testClassMappingPropertyToValue
{
    NSString *class = @"class";
    NSString *property = @"property";
    NSString *value = @"value";
    
    NSDictionary *rawAttributesDictionary = @{
        AUTThemeClassesKey: @{
            class: @{
                property: value
            }
        }
    };
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithRawAttributesDictionary:rawAttributesDictionary error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    AUTThemeClass *themeClass = [theme themeClassForName:class];
    XCTAssertNotNil(themeClass, @"Class must exist when registered");
    
    id valueForProperty = themeClass.properties[property];
    
    XCTAssertNotNil(valueForProperty, @"The theme class must have '%@' as a property", property);
    XCTAssertEqualObjects(valueForProperty, value, @"The theme class must have '%@' as a value for the '%@' property", value, property);
}

- (void)testClassMappingPropertyToValueFromConstant
{
    NSString *class = @"class";
    NSString *property = @"property";
    NSString *value = @"value";
    NSString *constant = @"constant";
    
    NSDictionary *rawAttributesDictionary = @{
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
    AUTTheme *theme = [[AUTTheme alloc] initWithRawAttributesDictionary:rawAttributesDictionary error:&error];
    XCTAssertNil(error, @"Error must be nil");
    
    AUTThemeClass *themeClass = [theme themeClassForName:class];
    XCTAssertNotNil(themeClass, @"Class must exist when registered");
    
    id valueForProperty = themeClass.properties[property];
    
    XCTAssertNotNil(valueForProperty, @"The theme class must have '%@' as a property", property);
    XCTAssertEqualObjects(valueForProperty, value, @"The theme class must have '%@' as a value for the '%@' property", value, property);
}

- (void)testClassToClassMappingFromPropertyValueWithinTheme
{
    NSString *class1 = @"class1";
    NSString *class2 = @"class2";
    NSString *property = @"property";
    NSString *classProperty = @"class1Property";
    NSString *value = @"value";
    
    NSDictionary *rawAttributesDictionary = @{
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
    AUTTheme *theme = [[AUTTheme alloc] initWithRawAttributesDictionary:rawAttributesDictionary error:&error];
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
    NSString *class1 = @"class1";
    NSString *class2 = @"class2";
    NSString *property = @"property";
    NSString *classProperty = @"class1Property";
    NSString *value = @"value";
    
    NSDictionary *rawAttributesDictionary1 = @{
        AUTThemeClassesKey: @{
            class1: @{
                property: value
            }
        }
    };
    NSDictionary *rawAttributesDictionary2 = @{
        AUTThemeClassesKey: @{
            class2: @{
                classProperty: class1
            }
        }
    };
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithRawAttributesDictionaries:@[rawAttributesDictionary1, rawAttributesDictionary2] error:&error];
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

#pragma mark - Identical Classes

- (void)testRegisteringMultipleClassesWithIdenticalNamesAcrossThemes
{
    NSString *class = @"class";
    NSString *value1 = @"value1";
    NSString *property1 = @"class1";
    NSString *value2 = @"value";
    NSString *property2 = @"property2";
    
    NSDictionary *rawAttributesDictionary1 = @{
        AUTThemeClassesKey: @{
            class: @{
                property1: value1
            }
        }
    };
    NSDictionary *rawAttributesDictionary2 = @{
        AUTThemeClassesKey: @{
            class: @{
                property2: value2
            }
        }
    };
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc] initWithRawAttributesDictionaries:@[rawAttributesDictionary1, rawAttributesDictionary2] error:&error];
    XCTAssertNotNil(error, @"Must have error when class with duplciate name is registered");
    
    AUTThemeClass *themeClass = [theme themeClassForName:class];
    XCTAssertNotNil(themeClass, @"Class must exist when registered");
    
    id valueForProperty1 = themeClass.properties[property1];
    XCTAssertNil(valueForProperty1, @"Original class property must no longer exist when overwritten");
    
    id valueForProperty2 = themeClass.properties[property2];
    XCTAssertNotNil(valueForProperty2, @"Overwritten class property must exist");
    XCTAssertEqualObjects(value2, valueForProperty2, @"Value must match registered property");
}

@end
