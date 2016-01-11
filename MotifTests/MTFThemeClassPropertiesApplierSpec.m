//
//  MTFThemeClassPropertiesApplierSpec.m
//  Motif
//
//  Created by Eric Horacek on 6/23/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <Motif/Motif.h>
#import <Motif/MTFThemeClassPropertiesApplier.h>
#import <Motif/MTFThemeClass_Private.h>
#import <Motif/MTFThemeConstant_Private.h>

SpecBegin(MTFThemeClassPropertiesApplier)

__block NSError *error;

beforeEach(^{
    error = nil;
});

describe(@"lifecycle", ^{
    it(@"should initialize", ^{
        NSArray *properties = @[ @"property1", @"property2" ];
        MTFThemePropertiesApplierBlock applierBlock = ^(NSDictionary *valuesForProperties, id objectToTheme, NSError **error){
            return YES;
        };

        MTFThemeClassPropertiesApplier *applier = [[MTFThemeClassPropertiesApplier alloc] initWithProperties:properties applierBlock:applierBlock];

        expect(applier).notTo.beNil();
        expect(applier).to.beKindOf(MTFThemeClassPropertiesApplier.class);

        expect(applier.properties.allObjects).to.equal(properties);
        expect(applier.applierBlock).to.equal(applierBlock);
    });

    it(@"should raise when initialized via init", ^{
        expect(^{
            __unused id applier = [(id)[MTFThemeClassPropertiesApplier alloc] init];
        }).to.raise(NSInternalInconsistencyException);
    });
});

describe(@"property application", ^{
    it(@"should succeed with all properties present in the class being applied", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSArray *properties = @[ @"property1", @"property2" ];
        NSArray *values = @[ @"value1", @"value2" ];
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            properties.firstObject: [[MTFThemeConstant alloc] initWithName:properties.firstObject rawValue:values.firstObject mappedValue:nil],
            properties.lastObject: [[MTFThemeConstant alloc] initWithName:properties.lastObject rawValue:values.lastObject mappedValue:nil]
        }];

        __block NSSet *applierProperties;
        __block NSSet *applierValues;
        MTFThemeClassPropertiesApplier *applier = [[MTFThemeClassPropertiesApplier alloc]
            initWithProperties:properties
            applierBlock:^(NSDictionary *valuesForProperties, id objectToTheme, NSError **error){
                applierProperties = [NSSet setWithArray:valuesForProperties.allKeys];
                applierValues = [NSSet setWithArray:[valuesForProperties objectEnumerator].allObjects];
                return YES;
            }];

        NSSet *propertiesSet = [NSSet setWithArray:properties];
        NSSet *valuesSet = [NSSet setWithArray:values];

        NSSet *appliedProperties = [applier applyClass:class to:objectToTheme error:&error];
        expect(appliedProperties).to.equal(propertiesSet);
        expect(error).to.beNil();

        expect(applierProperties).to.equal(propertiesSet);
        expect(applierValues).to.equal(valuesSet);
    });

    it(@"should apply no properties from a theme class that doesn't have the applier's properties", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSArray *properties = @[ @"property1", @"property2" ];
        NSArray *values = @[ @"value1", @"value2" ];
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            properties.firstObject: [[MTFThemeConstant alloc] initWithName:properties.firstObject rawValue:values.firstObject mappedValue:nil],
            @"anotherProperty": [[MTFThemeConstant alloc] initWithName:@"anotherProperty" rawValue:@"anotherValue" mappedValue:nil]
        }];

        MTFThemeClassPropertiesApplier *applier = [[MTFThemeClassPropertiesApplier alloc]
            initWithProperties:properties
            applierBlock:^(NSDictionary *valuesForProperties, id objectToTheme, NSError **error){
                return YES;
            }];

        NSSet *appliedProperties = [applier applyClass:class to:objectToTheme error:&error];
        expect(appliedProperties).to.haveACountOf(0);
        expect(error).to.beNil();
    });

    it(@"should propagate errors from the applier block", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSArray *properties = @[ @"property1", @"property2" ];
        NSArray *values = @[ @"value1", @"value2" ];
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            properties.firstObject: [[MTFThemeConstant alloc] initWithName:properties.firstObject rawValue:values.firstObject mappedValue:nil],
            properties.lastObject: [[MTFThemeConstant alloc] initWithName:@"anotherProperty" rawValue:@"anotherValue" mappedValue:nil]
        }];

        MTFThemeClassPropertiesApplier *applier = [[MTFThemeClassPropertiesApplier alloc]
            initWithProperties:properties
            applierBlock:^(NSDictionary *valuesForProperties, id objectToTheme, NSError **error){
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

SpecBegin(MTFThemeClassTypedValuesPropertiesApplier)

__block NSError *error;

beforeEach(^{
    error = nil;
});

describe(@"lifecycle", ^{
    it(@"should initialize", ^{
        NSArray *properties = @[@"property1", @"property2"];
        NSArray *valueTypes = @[NSString.class, @(@encode(CGPoint))];
        MTFThemePropertiesApplierBlock applierBlock = ^(NSDictionary *valuesForProperties, id objectToTheme, NSError **error){
            return YES;
        };

        MTFThemeClassTypedValuesPropertiesApplier *applier = [[MTFThemeClassTypedValuesPropertiesApplier alloc] initWithProperties:properties valueTypes:valueTypes applierBlock:applierBlock];

        expect(applier).notTo.beNil();
        expect(applier).to.beKindOf(MTFThemeClassTypedValuesPropertiesApplier.class);

        expect(applier.properties).to.equal([NSSet setWithArray:properties]);
        expect(applier.valueTypes).to.equal(valueTypes);
        expect(applier.applierBlock).to.equal(applierBlock);
    });

    it(@"should raise when initialized via initWithProperties:applierBlock:", ^{
        expect(^{
            NSArray *properties = @[ @"property1", @"property2" ];
            MTFThemePropertiesApplierBlock applierBlock = ^(NSDictionary *valuesForProperties, id objectToTheme, NSError **error){
                return YES;
            };

            __unused id applier = [(id)[MTFThemeClassTypedValuesPropertiesApplier alloc] initWithProperties:properties applierBlock:applierBlock];
        }).to.raise(NSInternalInconsistencyException);
    });
});

describe(@"property application", ^{
    it(@"should succeed with a class that has the applier's properties and value types", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSArray *properties = @[ @"property1", @"property2" ];
        CGPoint objCValue = (CGPoint){.x = 1.0f, .y = 2.0f};
        NSArray *valueTypes = @[ NSString.class, @(@encode(CGPoint)) ];
        NSArray *values = @[ @"value1", [NSValue value:&objCValue withObjCType:@encode(CGPoint)] ];
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            properties.firstObject: [[MTFThemeConstant alloc] initWithName:properties.firstObject rawValue:values.firstObject mappedValue:nil],
            properties.lastObject: [[MTFThemeConstant alloc] initWithName:properties.lastObject rawValue:values.lastObject mappedValue:nil]
        }];

        __block NSSet *applierProperties;
        __block NSSet *applierValues;
        MTFThemeClassTypedValuesPropertiesApplier *applier = [[MTFThemeClassTypedValuesPropertiesApplier alloc]
            initWithProperties:properties
            valueTypes:valueTypes
            applierBlock:^(NSDictionary *valuesForProperties, id objectToTheme, NSError **error){
                applierProperties = [NSSet setWithArray:valuesForProperties.allKeys];
                applierValues = [NSSet setWithArray:[valuesForProperties objectEnumerator].allObjects];
                return YES;
            }];

        NSSet *propertiesSet = [NSSet setWithArray:properties];
        NSSet *valuesSet = [NSSet setWithArray:values];

        NSSet *appliedProperties = [applier applyClass:class to:objectToTheme error:&error];
        expect(appliedProperties).to.equal(propertiesSet);
        expect(error).to.beNil();

        expect(applierProperties).to.equal(propertiesSet);
        expect(applierValues).to.equal(valuesSet);
    });

    it(@"should apply no properties from a theme class that doesn't have the applier's properties", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSArray *properties = @[ @"property1", @"property2" ];
        CGPoint objCValue = (CGPoint){.x = 1.0f, .y = 2.0f};
        NSArray *values = @[ @"value1", [NSValue value:&objCValue withObjCType:@encode(CGPoint)] ];
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            properties.firstObject: [[MTFThemeConstant alloc] initWithName:properties.firstObject rawValue:values.firstObject mappedValue:nil],
            @"anotherProperty": [[MTFThemeConstant alloc] initWithName:properties.lastObject rawValue:values.lastObject mappedValue:nil]
        }];

        NSArray *valueTypes = @[ NSString.class, @(@encode(CGPoint)) ];
        MTFThemeClassTypedValuesPropertiesApplier *applier = [[MTFThemeClassTypedValuesPropertiesApplier alloc]
            initWithProperties:properties
            valueTypes:valueTypes
            applierBlock:^(NSDictionary *valuesForProperties, id objectToTheme, NSError **error){
                return YES;
            }];

        NSSet *appliedProperties = [applier applyClass:class to:objectToTheme error:&error];
        expect(appliedProperties).to.haveACountOf(0);
        expect(error).to.beNil();
    });

it(@"should propapgate errors from value transformers when applying", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSArray *properties = @[ @"property1", @"property2" ];
        NSArray *values = @[ @"1", @"2" ];
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            properties.firstObject: [[MTFThemeConstant alloc] initWithName:properties.firstObject rawValue:values.firstObject mappedValue:nil],
            properties.lastObject: [[MTFThemeConstant alloc] initWithName:properties.lastObject rawValue:values.lastObject mappedValue:nil]
        }];

        NSString *transformerName = @"MTFThemeClassValueObjCTypePropertyApplier Errors";
        [NSValueTransformer
            mtf_registerValueTransformerWithName:transformerName
            transformedValueClass:NSNumber.class
            reverseTransformedValueClass:NSString.class
            transformationBlock:^ id (NSString *value, NSError **error) {
                return [NSValueTransformer mtf_populateTransformationError:error withDescription:@"description"];
            }];

        NSArray *valueTypes = @[ NSNumber.class, @(@encode(CGPoint)) ];
        MTFThemeClassTypedValuesPropertiesApplier *applier = [[MTFThemeClassTypedValuesPropertiesApplier alloc]
            initWithProperties:properties
            valueTypes:valueTypes
            applierBlock:^(NSDictionary *valuesForProperties, id objectToTheme, NSError **error){
                return YES;
            }];

        NSSet *appliedProperties = [applier applyClass:class to:objectToTheme error:&error];
        expect(appliedProperties).to.beNil();
        expect(error).notTo.beNil();
        expect(error.domain).to.equal(MTFErrorDomain);
        expect(error.code).to.equal(MTFErrorFailedToApplyTheme);

        [NSValueTransformer setValueTransformer:nil forName:transformerName];
    });
});

SpecEnd
