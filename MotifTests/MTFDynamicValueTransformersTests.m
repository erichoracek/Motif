//
//  MTFDynamicValueTransformersTests.m
//  Motif
//
//  Created by Eric Horacek on 5/14/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Motif/Motif.h>
#import <Motif/MTFObjCTypeValueTransformer.h>
#import <Motif/MTFReverseTransformedValueClass.h>

@interface DynamicValueTransformerTestClass : NSObject

@property (readwrite, nonatomic, copy) NSString *property;

@end

typedef struct DynamicValueTransformerTestStruct {
    NSInteger member;
} DynamicValueTransformerTestStruct;

@interface MTFDynamicValueTransformersTests : XCTestCase

@end

@implementation MTFDynamicValueTransformersTests

- (void)testClassValueTransformerIsCreated {
    Class reverseTransformedValueClass = NSString.class;
    Class transformedValueClass = DynamicValueTransformerTestClass.class;

    BOOL success = [NSValueTransformer
        mtf_registerValueTransformerWithName:NSStringFromSelector(_cmd)
        transformedValueClass:transformedValueClass
        reverseTransformedValueClass:reverseTransformedValueClass
        returningTransformedValueWithBlock:^DynamicValueTransformerTestClass *(NSString *value) {
            DynamicValueTransformerTestClass *class = [[DynamicValueTransformerTestClass alloc] init];
            class.property = @"test";
            return class;
        }];

    XCTAssertTrue(success, @"Must successfully register value transformer");

    NSValueTransformer<MTFReverseTransformedValueClass> *transformer = (id)[NSValueTransformer valueTransformerForName:NSStringFromSelector(_cmd)];

    XCTAssertTrue(
        [transformer conformsToProtocol:@protocol(MTFReverseTransformedValueClass)],
        @"Created value transformer must conform to reverse transformed value "
            "transformer protocol");

    XCTAssertEqual(
        [transformer.class reverseTransformedValueClass],
        reverseTransformedValueClass,
        @"Reverse transformed value class must match registered class");

    id transformedValue = [transformer transformedValue:@"test"];

    XCTAssertNotNil(transformedValue, @"transformed value must be non nil");

    XCTAssertEqual(
        [transformedValue class],
        transformedValueClass,
        @"transformed value must be of correct class");
}

- (void)testObjCTypeValueTransformerIsCreated {
    Class reverseTransformedValueClass = NSString.class;
    const char *transformedValueObjCType = @encode(DynamicValueTransformerTestStruct);
    NSInteger structMemberValue = 1;

    BOOL success = [NSValueTransformer
        mtf_registerValueTransformerWithName:NSStringFromSelector(_cmd)
        transformedValueObjCType:transformedValueObjCType
        reverseTransformedValueClass:reverseTransformedValueClass
        returningTransformedValueWithBlock:^NSValue *(NSString *value) {
            DynamicValueTransformerTestStruct structValue = (DynamicValueTransformerTestStruct){
                .member = structMemberValue
            };

            return [NSValue
                valueWithBytes:&structValue
                objCType:transformedValueObjCType];
        }];

    XCTAssertTrue(success, @"Must successfully register value transformer");

    NSValueTransformer<MTFReverseTransformedValueClass, MTFObjCTypeValueTransformer> *transformer = (id)[NSValueTransformer valueTransformerForName:NSStringFromSelector(_cmd)];

    XCTAssertTrue(
        [transformer conformsToProtocol:@protocol(MTFReverseTransformedValueClass)],
        @"Created value transformer must conform to reverse transformed value "
            "transformer protocol");

    XCTAssertTrue(
        [transformer conformsToProtocol:@protocol(MTFObjCTypeValueTransformer)],
        @"Created value transformer must conform to ObjC type value "
            "transformer protocol");

    XCTAssertEqual(
        [transformer.class reverseTransformedValueClass],
        reverseTransformedValueClass,
        @"Reverse transformed value class must match registered class");

    XCTAssertEqual(
        strcmp([transformer.class transformedValueObjCType], transformedValueObjCType),
        0,
        @"Transformed value ObjC type must match registered ObjC type");

    NSValue *transformedValue = [transformer transformedValue:@"test"];

    XCTAssertNotNil(transformedValue, @"transformed value must be non nil");

    XCTAssertEqual(
        strcmp(transformedValue.objCType, transformedValueObjCType),
        0,
        @"transformed value must be of correct class");

    DynamicValueTransformerTestStruct structValue;
    [transformedValue getValue:&structValue];

    XCTAssertEqual(
        structValue.member,
        structMemberValue,
        @"Struct must have valid member value");
}

- (void)testThrowsWhenValueNotOfReverseTransformedValueClass {
    Class reverseTransformedValueClass = NSString.class;
    Class transformedValueClass = DynamicValueTransformerTestClass.class;

    BOOL success = [NSValueTransformer
        mtf_registerValueTransformerWithName:NSStringFromSelector(_cmd)
        transformedValueClass:transformedValueClass
        reverseTransformedValueClass:reverseTransformedValueClass
        returningTransformedValueWithBlock:^DynamicValueTransformerTestClass *(NSString *value) {
            DynamicValueTransformerTestClass *class = [[DynamicValueTransformerTestClass alloc] init];
            class.property = @"test";
            return class;
        }];

    XCTAssertTrue(success, @"Must successfully register value transformer");

    NSValueTransformer<MTFReverseTransformedValueClass> *transformer = (id)[NSValueTransformer valueTransformerForName:NSStringFromSelector(_cmd)];

    XCTAssertThrows(
        [transformer transformedValue:[[NSNumber alloc] init]],
        @"Must throw when attempting to transform invalid value");
}

@end

@implementation DynamicValueTransformerTestClass

@end
