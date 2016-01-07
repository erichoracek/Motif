//
//  MTFThemeClassPropertyApplierSpec.m
//  Motif
//
//  Created by Eric Horacek on 6/15/15.
//  Copyright © 2015 Eric Horacek. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <Motif/Motif.h>
#import <Motif/MTFThemeClassPropertyApplier.h>
#import <Motif/MTFThemeClass_Private.h>
#import <Motif/MTFThemeConstant_Private.h>

SpecBegin(MTFThemeClassPropertyApplier)

__block BOOL success;
__block NSError *error;

beforeEach(^{
    success = NO;
    error = nil;
});

describe(@"lifecycle", ^{
    it(@"should initialize", ^{
        NSString *property = @"Property";
        MTFThemePropertyApplierBlock applierBlock = ^(id propertyValue, id objectToTheme, NSError ** error) { return YES; };

        MTFThemeClassPropertyApplier *applier = [[MTFThemeClassPropertyApplier alloc] initWithProperty:property applierBlock:applierBlock];

        expect(applier).notTo.beNil();
        expect(applier).to.beKindOf(MTFThemeClassPropertyApplier.class);

        expect(applier.property).to.equal(property);
        expect(applier.applierBlock).to.equal(applierBlock);
    });

    it(@"should raise when initialized via init", ^{
        expect(^{
            __unused id applier = [(id)[MTFThemeClassPropertyApplier alloc] init];
        }).to.raise(NSInternalInconsistencyException);
    });
});

describe(@"property application", ^{
    it(@"should occur with a class that has the applier's property", ^{
        Class applicantClass = NSObject.class;
        id applicant = [[applicantClass alloc] init];

        NSString *property = @"property";
        NSString *value = @"value";
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            property: [[MTFThemeConstant alloc] initWithName:property rawValue:value mappedValue:nil]
        }];

        __block id appliedValue;
        __block id appliedObject;
        MTFThemeClassPropertyApplier *applier = [[MTFThemeClassPropertyApplier alloc]
            initWithProperty:property
            applierBlock:^(id propertyValue, id objectToTheme, NSError **error){
                appliedValue = propertyValue;
                appliedObject = objectToTheme;

                return YES;
            }];

        NSSet *appliedProperties = [applier applyClass:class to:applicant error:&error];
        expect(appliedProperties).to.haveACountOf(1);
        expect(appliedProperties).to.contain(property);
        expect(error).to.beFalsy();
        expect(appliedValue).to.beIdenticalTo(value);
        expect(appliedObject).to.beIdenticalTo(applicant);
    });

    it(@"should not occur with a class that doesn't have the applier's property", ^{
        Class applicantClass = NSObject.class;
        id applicant = [[applicantClass alloc] init];

        NSString *applierProperty = @"applierProperty";
        NSString *classProperty = @"classProperty";
        NSString *value = @"value";
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            classProperty: [[MTFThemeConstant alloc] initWithName:classProperty rawValue:value mappedValue:nil]
        }];

        MTFThemeClassPropertyApplier *applier = [[MTFThemeClassPropertyApplier alloc]
            initWithProperty:applierProperty
            applierBlock:^(id propertyValue, id objectToTheme, NSError **error){
                return YES;
            }];

        NSSet *appliedProperties = [applier applyClass:class to:applicant error:&error];
        expect(appliedProperties).to.haveACountOf(0);
        expect(error).to.beNil();
    });

    it(@"should fail when an error occurs during application", ^{
        Class applicantClass = NSObject.class;
        id applicant = [[applicantClass alloc] init];

        NSString *property = @"property";
        NSString *value = @"value";
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            property: [[MTFThemeConstant alloc] initWithName:property rawValue:value mappedValue:nil]
        }];

        MTFThemeClassPropertyApplier *applier = [[MTFThemeClassPropertyApplier alloc]
            initWithProperty:property
            applierBlock:^(id propertyValue, id objectToTheme, NSError **error){
                return [NSObject mtf_populateApplierError:error withDescription:@"description"];
            }];

        NSSet *appliedProperties = [applier applyClass:class to:applicant error:&error];
        expect(appliedProperties).to.beNil();
        expect(error).notTo.beNil();
        expect(error.domain).to.equal(MTFErrorDomain);
        expect(error.code).to.equal(MTFErrorFailedToApplyTheme);
    });
});

SpecEnd

SpecBegin(MTFThemeClassValueClassPropertyApplier)

__block BOOL success;
__block NSError *error;

beforeEach(^{
    success = NO;
    error = nil;
});

describe(@"lifecycle", ^{
    it(@"should initialize", ^{
        NSString *property = @"Property";
        MTFThemePropertyApplierBlock applierBlock = ^(id propertyValue, id objectToTheme, NSError **error) {
            return YES;
        };
        Class valueClass = NSString.class;

        MTFThemeClassValueClassPropertyApplier *applier = [[MTFThemeClassValueClassPropertyApplier alloc]
            initWithProperty:property
            valueClass:valueClass
            applierBlock:applierBlock];

        expect(applier).notTo.beNil();
        expect(applier).to.beKindOf(MTFThemeClassValueClassPropertyApplier.class);

        expect(applier.property).to.equal(property);
        expect(applier.valueClass).to.beIdenticalTo(valueClass);
        expect(applier.applierBlock).to.equal(applierBlock);
    });
});

describe(@"property application", ^{
    it(@"should succeed with a class that has the applier's property and value type", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSString *property = @"property";
        NSString *value = @"value";
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            property: [[MTFThemeConstant alloc] initWithName:property rawValue:value mappedValue:nil]
        }];

        __block id appliedValue;
        __block id appliedObject;
        MTFThemeClassPropertyApplier *applier = [[MTFThemeClassValueClassPropertyApplier alloc]
            initWithProperty:property
            valueClass:NSString.class
            applierBlock:^(id propertyValue, id objectToTheme, NSError **error){
                appliedValue = propertyValue;
                appliedObject = objectToTheme;

                return YES;
            }];

        NSSet *appliedProperties = [applier applyClass:class to:objectToTheme error:&error];
        expect(appliedProperties).to.haveACountOf(1);
        expect(appliedProperties).to.contain(property);
        expect(error).to.beNil();
        expect(appliedValue).to.beIdenticalTo(value);
        expect(appliedObject).to.beIdenticalTo(objectToTheme);
    });

    it(@"should fail with a class that has the applier property but of incorrect type", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSString *property = @"property";
        NSString *value = @"value";
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            property: [[MTFThemeConstant alloc] initWithName:property rawValue:value mappedValue:nil]
        }];

        MTFThemeClassPropertyApplier *applier = [[MTFThemeClassValueClassPropertyApplier alloc]
            initWithProperty:property
            valueClass:NSNumber.class
            applierBlock:^(id propertyValue, id objectToTheme, NSError **error){
                return YES;
            }];

        NSSet *appliedProperties = [applier applyClass:class to:objectToTheme error:&error];
        expect(appliedProperties).to.beNil();
        expect(error).notTo.beNil();
        expect(error.domain).to.equal(MTFErrorDomain);
        expect(error.code).to.equal(MTFErrorFailedToApplyTheme);
    });

    it(@"should not apply any properties with a theme class that doesn't have the applier's property", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSString *applierProperty = @"applierProperty";
        NSString *classProperty = @"classProperty";
        NSString *value = @"value";
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            classProperty: [[MTFThemeConstant alloc] initWithName:classProperty rawValue:value mappedValue:nil]
        }];

        MTFThemeClassPropertyApplier *applier = [[MTFThemeClassValueClassPropertyApplier alloc]
            initWithProperty:applierProperty
            valueClass:NSNumber.class
            applierBlock:^(id propertyValue, id objectToTheme, NSError **error){
                return YES;
            }];

        NSSet *appliedProperties = [applier applyClass:class to:objectToTheme error:&error];
        expect(appliedProperties).to.haveACountOf(0);
        expect(error).to.beNil();
    });

    it(@"should transform an input value to an applier when necessary", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSString *property = @"property";
        NSString *value = @"1";
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            property: [[MTFThemeConstant alloc] initWithName:property rawValue:value mappedValue:nil]
        }];

        NSString *transformerName = @"MTFThemeClassValueClassPropertyApplier Transformation";
        [NSValueTransformer
            mtf_registerValueTransformerWithName:transformerName
            transformedValueClass:NSNumber.class
            reverseTransformedValueClass:NSString.class
            transformationBlock:^(NSString *value, NSError **error) {
                return @(value.integerValue);
            }];

        __block NSNumber *appliedValue;

        MTFThemeClassPropertyApplier *applier = [[MTFThemeClassValueClassPropertyApplier alloc]
            initWithProperty:property
            valueClass:NSNumber.class
            applierBlock:^(NSNumber *propertyValue, id objectToTheme, NSError **error){
                appliedValue = propertyValue;
                return YES;
            }];

        NSSet *appliedProperties = [applier applyClass:class to:objectToTheme error:&error];
        expect(appliedProperties).to.haveACountOf(1);
        expect(appliedProperties).to.contain(property);
        expect(error).to.beNil();
        expect(appliedValue).to.equal(@1);

        [NSValueTransformer setValueTransformer:nil forName:transformerName];
    });

    it(@"should propapgate errors from value transformers when applying", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSString *property = @"property";
        NSString *value = @"1";
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            property: [[MTFThemeConstant alloc] initWithName:property rawValue:value mappedValue:nil]
        }];

        NSString *transformerName = @"MTFThemeClassValueClassPropertyApplier Errors";
        [NSValueTransformer
            mtf_registerValueTransformerWithName:transformerName
            transformedValueClass:NSNumber.class
            reverseTransformedValueClass:NSString.class
            transformationBlock:^ id (NSString *value, NSError **error) {
                return [NSValueTransformer mtf_populateTransformationError:error withDescription:@"description"];
            }];

        MTFThemeClassPropertyApplier *applier = [[MTFThemeClassValueClassPropertyApplier alloc]
            initWithProperty:property
            valueClass:NSNumber.class
            applierBlock:^(NSNumber *propertyValue, id objectToTheme, NSError **error){
                return YES;
            }];

        NSSet *appliedProperties = [applier applyClass:class to:objectToTheme error:&error];
        expect(appliedProperties).to.beNil();
        expect(error).notTo.beNil();
        expect(error.domain).to.equal(MTFErrorDomain);
        expect(error.code).to.equal(MTFErrorFailedToApplyTheme);

        [NSValueTransformer setValueTransformer:nil forName:transformerName];
    });

    it(@"should propagate errors from the applier block", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSString *property = @"property";
        NSString *value = @"value";
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            property: [[MTFThemeConstant alloc] initWithName:property rawValue:value mappedValue:nil]
        }];

        MTFThemeClassPropertyApplier *applier = [[MTFThemeClassValueClassPropertyApplier alloc]
            initWithProperty:property
            valueClass:NSString.class
            applierBlock:^(id propertyValue, id objectToTheme, NSError **error){
                return [NSObject mtf_populateApplierError:error withDescription:@"description"];
            }];

        NSSet *appliedProperties = [applier applyClass:class to:objectToTheme error:&error];
        expect(appliedProperties).to.beNil();
        expect(error).notTo.beNil();
        expect(error.domain).to.equal(MTFErrorDomain);
        expect(error.code).to.equal(MTFErrorFailedToApplyTheme);
    });
});

SpecEnd

SpecBegin(MTFThemeClassValueObjCTypePropertyApplier)

__block BOOL success;
__block NSError *error;

beforeEach(^{
    success = NO;
    error = nil;
});

describe(@"lifecycle", ^{
    it(@"should initialize", ^{
        NSString *property = @"Property";
        MTFThemePropertyApplierBlock applierBlock = ^(id propertyValue, id objectToTheme, NSError **error) {
            return YES;
        };
        const char *valueObjCType = @encode(CGPoint);

        MTFThemeClassValueObjCTypePropertyApplier *applier = [[MTFThemeClassValueObjCTypePropertyApplier alloc] initWithProperty:property valueObjCType:valueObjCType applierBlock:applierBlock];

        expect(applier).notTo.beNil();
        expect(applier).to.beKindOf(MTFThemeClassValueObjCTypePropertyApplier.class);

        expect(applier.property).to.equal(property);
        expect(@(applier.valueObjCType)).to.equal(@(valueObjCType));
        expect(applier.applierBlock).to.equal(applierBlock);
    });
});

describe(@"property application", ^{
    it(@"should succeed with a class that has the applier's property and value type", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSString *property = @"property";
        CGPoint value = (CGPoint){.x = 1.0f, .y = 2.0f};
        NSValue *wrappedValue = [NSValue value:&value withObjCType:@encode(CGPoint)];
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            property: [[MTFThemeConstant alloc] initWithName:property rawValue:wrappedValue mappedValue:nil]
        }];

        __block id appliedValue;
        __block id appliedObject;
        MTFThemeClassPropertyApplier *applier = [[MTFThemeClassValueObjCTypePropertyApplier alloc] initWithProperty:property valueObjCType:@encode(CGPoint) applierBlock:^(id propertyValue, id objectToTheme, NSError **error){
            appliedValue = propertyValue;
            appliedObject = objectToTheme;

            return YES;
        }];

        NSSet *appliedProperties = [applier applyClass:class to:objectToTheme error:&error];
        expect(appliedProperties).to.haveACountOf(1);
        expect(appliedProperties).to.contain(property);
        expect(error).to.beNil();
        expect(appliedValue).to.beIdenticalTo(wrappedValue);
        expect(appliedObject).to.beIdenticalTo(objectToTheme);
    });

    it(@"should fail with a class that has the applier property but of incorrect type", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSString *property = @"property";
        NSString *value = @"value";
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            property: [[MTFThemeConstant alloc] initWithName:property rawValue:value mappedValue:nil]
        }];

        MTFThemeClassPropertyApplier *applier = [[MTFThemeClassValueObjCTypePropertyApplier alloc]
            initWithProperty:property
            valueObjCType:@encode(CGPoint)
            applierBlock:^(id propertyValue, id objectToTheme, NSError **error){
                return YES;
            }];

        NSSet *appliedProperties = [applier applyClass:class to:objectToTheme error:&error];
        expect(appliedProperties).to.beNil();
        expect(error).notTo.beNil();
        expect(error.domain).to.equal(MTFErrorDomain);
        expect(error.code).to.equal(MTFErrorFailedToApplyTheme);
    });

    it(@"should apply no properties with a theme class that doesn't have the applier's property", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSString *applierProperty = @"applierProperty";
        NSString *classProperty = @"classProperty";
        NSString *value = @"value";
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            classProperty: [[MTFThemeConstant alloc] initWithName:classProperty rawValue:value mappedValue:nil]
        }];

        MTFThemeClassPropertyApplier *applier = [[MTFThemeClassValueObjCTypePropertyApplier alloc]
            initWithProperty:applierProperty
            valueObjCType:@encode(CGPoint)
            applierBlock:^(id propertyValue, id objectToTheme, NSError **error){
                return YES;
            }];

        NSSet *appliedProperties = [applier applyClass:class to:objectToTheme error:&error];
        expect(appliedProperties).to.haveACountOf(0);
        expect(error).to.beNil();
    });

    it(@"should transform an input value to an applier when necessary", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSString *property = @"property";
        NSString *value = @"1";
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            property: [[MTFThemeConstant alloc] initWithName:property rawValue:value mappedValue:nil]
        }];

        NSString *transformerName = @"MTFThemeClassValueObjCTypePropertyApplierTransformation";
        [NSValueTransformer
            mtf_registerValueTransformerWithName:transformerName
            transformedValueObjCType:@encode(CGSize)
            reverseTransformedValueClass:NSString.class
            transformationBlock:^(NSString *value, NSError **error) {
                CGSize size = { value.integerValue, value.integerValue };
                return [NSValue valueWithBytes:&size objCType:@encode(CGSize)];
            }];

        __block NSValue *appliedValue;

        MTFThemeClassPropertyApplier *applier = [[MTFThemeClassValueObjCTypePropertyApplier alloc]
            initWithProperty:property
            valueObjCType:@encode(CGSize)
            applierBlock:^(NSNumber *propertyValue, id objectToTheme, NSError **error){
                appliedValue = propertyValue;
                return YES;
            }];

        NSSet *appliedProperties = [applier applyClass:class to:objectToTheme error:&error];
        expect(appliedProperties).to.haveACountOf(1);
        expect(appliedProperties).to.contain(property);
        expect(error).to.beNil();
        expect(appliedValue).to.beKindOf(NSValue.class);

        CGSize size;
        [appliedValue getValue:&size];
        expect(size).to.equal((CGSize){ value.integerValue, value.integerValue });

        [NSValueTransformer setValueTransformer:nil forName:transformerName];
    });

    it(@"should propapgate errors from value transformers when applying", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSString *property = @"property";
        NSString *value = @"1";
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            property: [[MTFThemeConstant alloc] initWithName:property rawValue:value mappedValue:nil]
        }];

        NSString *transformerName = @"MTFThemeClassValueObjCTypePropertyApplierErrors";
        [NSValueTransformer
            mtf_registerValueTransformerWithName:transformerName
            transformedValueObjCType:@encode(CGSize)
            reverseTransformedValueClass:NSString.class
            transformationBlock:^ id (NSString *value, NSError **error) {
                return [NSValueTransformer mtf_populateTransformationError:error withDescription:@"description"];
            }];

        MTFThemeClassValueObjCTypePropertyApplier *applier = [[MTFThemeClassValueObjCTypePropertyApplier alloc]
            initWithProperty:property
            valueObjCType:@encode(CGSize)
            applierBlock:^(NSValue *propertyValue, id objectToTheme, NSError **error){
                return YES;
            }];

        NSSet *appliedProperties = [applier applyClass:class to:objectToTheme error:&error];
        expect(appliedProperties).to.beNil();
        expect(error).notTo.beNil();
        expect(error.domain).to.equal(MTFErrorDomain);
        expect(error.code).to.equal(MTFErrorFailedToApplyTheme);

        [NSValueTransformer setValueTransformer:nil forName:transformerName];
    });

    it(@"should propagate errors from the applier block", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSString *property = @"property";
        NSString *value = @"value";
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            property: [[MTFThemeConstant alloc] initWithName:property rawValue:value mappedValue:nil]
        }];

        MTFThemeClassPropertyApplier *applier = [[MTFThemeClassValueObjCTypePropertyApplier alloc]
            initWithProperty:property
            valueObjCType:@encode(CGSize)
            applierBlock:^(id propertyValue, id objectToTheme, NSError **error){
                return [NSObject mtf_populateApplierError:error withDescription:@"description"];
            }];

        NSSet *appliedProperties = [applier applyClass:class to:objectToTheme error:&error];
        expect(appliedProperties).to.beNil();
        expect(error).notTo.beNil();
        expect(error.domain).to.equal(MTFErrorDomain);
        expect(error.code).to.equal(MTFErrorFailedToApplyTheme);
    });
});

SpecEnd
