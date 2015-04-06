//
//  MTFThemePropertyAutoApplicationTests.m
//  MotifTests
//
//  Created by Eric Horacek on 3/10/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Motif.h"
#import "NSString+ThemeSymbols.h"
#import "UIColor+HTMLColors.h"

@interface MTFThemePropertyAutoApplicationTests : XCTestCase

@end

@interface MTFTestCTypePropertiesObject : NSObject

@property (nonatomic) UIEdgeInsets edgeInsetsValue;
@property (nonatomic) CGRect rectValue;
@property (nonatomic) CGSize sizeValue;
@property (nonatomic) CGPoint pointValue;
@property (nonatomic) CGFloat floatValue;

@end

@interface MTFTestObjCClassPropertiesObject : NSObject

@property (nonatomic) UIColor *colorValue;
@property (nonatomic) NSString *stringValue;
@property (nonatomic) NSNumber *numberValue;

@end

@interface MTFSuperclassPropertyObject : NSObject

@property (nonatomic, readonly) NSNumber *superclassProperty;

@end

@interface MTFSubclassPropertyObject : MTFSuperclassPropertyObject

@end

@implementation MTFThemePropertyAutoApplicationTests

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
    MTFTheme *theme = [[MTFTheme alloc]
        initWithThemeDictionary:themeDictionary
        error:&error];
    XCTAssertNil(error, @"Error must be nil when creating theme");
    
    MTFDynamicThemeApplier *applier = [[MTFDynamicThemeApplier alloc]
        initWithTheme:theme];
    
    MTFTestCTypePropertiesObject *object = [MTFTestCTypePropertiesObject new];
    
    [applier applyClassWithName:className.mtf_symbol toObject:object];
    
    XCTAssert(CGRectEqualToRect(rectValue, object.rectValue), @"CGRect struct must be applied to object property");
    XCTAssert(UIEdgeInsetsEqualToEdgeInsets(edgeInsetsValue, object.edgeInsetsValue), @"UIEdgeInsets struct must be applied to object property");
    XCTAssert(CGPointEqualToPoint(pointValue, object.pointValue), @"CGPoint struct must be applied to object property");
    XCTAssert(CGSizeEqualToSize(sizeValue, object.sizeValue), @"CGSize struct must be applied to object property");
    XCTAssertEqual(floatValue, object.floatValue, @"CGFloat value must be applied to object property");
}

- (void)testClassPropertyAutoApplication
{
    NSString *className = @".Class";
    
    UIColor *colorValue = [UIColor mtf_colorWithHexString:@"#123456"];
    NSString *stringValue = @"string";
    NSNumber *numberValue = @1.0;
    
    NSDictionary *themeDictionary = @{
        className: @{
            NSStringFromSelector(@selector(colorValue)): colorValue.mtf_hexStringValue,
            NSStringFromSelector(@selector(stringValue)): stringValue,
            NSStringFromSelector(@selector(numberValue)): numberValue
        }
    };
    
    NSError *error;
    MTFTheme *theme = [[MTFTheme alloc]
        initWithThemeDictionary:themeDictionary
        error:&error];
    XCTAssertNil(error, @"Error must be nil when creating theme");
    
    MTFDynamicThemeApplier *applier = [[MTFDynamicThemeApplier alloc]
        initWithTheme:theme];
    
    MTFTestObjCClassPropertiesObject *object = [MTFTestObjCClassPropertiesObject new];
    
    [applier applyClassWithName:className.mtf_symbol toObject:object];
    
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
    
    MTFTheme *theme = [[MTFTheme alloc]
        initWithThemeDictionary:themeDictionary
        error:&error];
    XCTAssertNil(error, @"Error must be nil when creating theme");
    
    MTFDynamicThemeApplier *applier = [[MTFDynamicThemeApplier alloc]
        initWithTheme:theme];
    
    MTFSubclassPropertyObject *object = [MTFSubclassPropertyObject new];
    
    [applier applyClassWithName:className.mtf_symbol toObject:object];
    
    XCTAssertEqualObjects(object.superclassProperty, numberValue, @"Superclass property should be applied");
}

@end

@implementation MTFTestCTypePropertiesObject

@end

@implementation MTFTestObjCClassPropertiesObject

@end

@implementation MTFSuperclassPropertyObject

@end

@implementation MTFSubclassPropertyObject

@end