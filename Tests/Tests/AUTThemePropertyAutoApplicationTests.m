//
//  AUTThemePropertyAutoApplicationTests.m
//  Tests
//
//  Created by Eric Horacek on 3/10/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <AUTTheming/AUTTheming.h>
#import <AUTTheming/NSString+ThemeSymbols.h>
#import <UIColor-HTMLColors/UIColor+HTMLColors.h>

@interface AUTThemePropertyAutoApplicationTests : XCTestCase

@end

@interface AUTTestCTypePropertiesObject : NSObject

@property (nonatomic) UIEdgeInsets edgeInsetsValue;
@property (nonatomic) CGRect rectValue;
@property (nonatomic) CGSize sizeValue;
@property (nonatomic) CGPoint pointValue;
@property (nonatomic) CGFloat floatValue;

@end

@interface AUTTestObjCClassPropertiesObject : NSObject

@property (nonatomic) UIColor *colorValue;
@property (nonatomic) NSString *stringValue;
@property (nonatomic) NSNumber *numberValue;

@end

@interface AUTSuperclassPropertyObject : NSObject

@property (nonatomic, readonly) NSNumber *superclassProperty;

@end

@interface AUTSubclassPropertyObject : AUTSuperclassPropertyObject

@end

@implementation AUTThemePropertyAutoApplicationTests

- (void)testStructPropertyAutoApplication
{
    NSString *className = @".Class";
    
    UIEdgeInsets edgeInsetsValue = UIEdgeInsetsMake(1.0, 2.0, 3.0, 4.0);
    CGRect rectValue = CGRectMake(1.0, 2.0, 3.0, 4.0);
    CGSize sizeValue = CGSizeMake(1.0, 2.0);
    CGPoint pointValue = CGPointMake(1.0, 2.0);
    CGFloat floatValue = 1.0;
    
    NSDictionary *themeDictionary = @{
        className: @{
            NSStringFromSelector(@selector(edgeInsetsValue)): NSStringFromUIEdgeInsets(edgeInsetsValue),
            NSStringFromSelector(@selector(rectValue)): NSStringFromCGRect(rectValue),
            NSStringFromSelector(@selector(sizeValue)): NSStringFromCGSize(sizeValue),
            NSStringFromSelector(@selector(pointValue)): NSStringFromCGPoint(pointValue),
            NSStringFromSelector(@selector(floatValue)): @(floatValue)
        }
    };
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc]
        initWithThemeDictionary:themeDictionary
        error:&error];
    XCTAssertNil(error, @"Error must be nil when creating theme");
    
    AUTDynamicThemeApplier *applier = [[AUTDynamicThemeApplier alloc]
        initWithTheme:theme];
    
    AUTTestCTypePropertiesObject *object = [AUTTestCTypePropertiesObject new];
    
    [applier applyClassWithName:className.aut_symbol toObject:object];
    
    XCTAssert(CGRectEqualToRect(rectValue, object.rectValue), @"CGRect struct must be applied to object property");
    XCTAssert(UIEdgeInsetsEqualToEdgeInsets(edgeInsetsValue, object.edgeInsetsValue), @"UIEdgeInsets struct must be applied to object property");
    XCTAssert(CGPointEqualToPoint(pointValue, object.pointValue), @"CGPoint struct must be applied to object property");
    XCTAssert(CGSizeEqualToSize(sizeValue, object.sizeValue), @"CGSize struct must be applied to object property");
    XCTAssertEqual(floatValue, object.floatValue, @"CGFloat value must be applied to object property");
}

- (void)testClassPropertyAutoApplication
{
    NSString *className = @".Class";
    
    UIColor *colorValue = [UIColor colorWithHexString:@"#123456"];
    NSString *stringValue = @"string";
    NSNumber *numberValue = @1.0;
    
    NSDictionary *themeDictionary = @{
        className: @{
            NSStringFromSelector(@selector(colorValue)): colorValue.hexStringValue,
            NSStringFromSelector(@selector(stringValue)): stringValue,
            NSStringFromSelector(@selector(numberValue)): numberValue
        }
    };
    
    NSError *error;
    AUTTheme *theme = [[AUTTheme alloc]
        initWithThemeDictionary:themeDictionary
        error:&error];
    XCTAssertNil(error, @"Error must be nil when creating theme");
    
    AUTDynamicThemeApplier *applier = [[AUTDynamicThemeApplier alloc]
        initWithTheme:theme];
    
    AUTTestObjCClassPropertiesObject *object = [AUTTestObjCClassPropertiesObject new];
    
    [applier applyClassWithName:className.aut_symbol toObject:object];
    
    XCTAssertEqualObjects(colorValue, object.colorValue, @"UIColor string value must be applied to instance property");
    XCTAssertEqualObjects(stringValue, object.stringValue, @"NSString value must be applied to instance property");
    XCTAssertEqualObjects(numberValue, object.numberValue, @"NSNumber value must be applied to instance property");
}

- (void)testSuperclassPropertyAutoApplication
{
    NSString *className = @".Class";
    NSNumber *numberValue = @1.0;
    NSError *error;
    
    NSDictionary *themeDictionary = @{
        className: @{
            NSStringFromSelector(@selector(superclassProperty)) : numberValue
        }
    };
    
    AUTTheme *theme = [[AUTTheme alloc]
        initWithThemeDictionary:themeDictionary
        error:&error];
    XCTAssertNil(error, @"Error must be nil when creating theme");
    
    AUTDynamicThemeApplier *applier = [[AUTDynamicThemeApplier alloc]
        initWithTheme:theme];
    
    AUTSubclassPropertyObject *object = [AUTSubclassPropertyObject new];
    
    [applier applyClassWithName:className.aut_symbol toObject:object];
    
    XCTAssertEqualObjects(object.superclassProperty, numberValue, @"Superclass property should be applied");
}

@end

@implementation AUTTestCTypePropertiesObject

@end

@implementation AUTTestObjCClassPropertiesObject

@end

@implementation AUTSuperclassPropertyObject

@end

@implementation AUTSubclassPropertyObject

@end