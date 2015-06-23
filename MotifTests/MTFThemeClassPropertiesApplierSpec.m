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

describe(@"lifecycle", ^{
    it(@"should initialize", ^{
        NSArray *properties = @[@"property1", @"property2"];
        MTFThemePropertiesApplierBlock applierBlock = ^(NSDictionary *valuesForProperties, id objectToTheme){};

        MTFThemeClassPropertiesApplier *applier = [[MTFThemeClassPropertiesApplier alloc] initWithProperties:properties applierBlock:applierBlock];

        expect(applier).notTo.beNil();
        expect(applier).to.beKindOf(MTFThemeClassPropertiesApplier.class);

        expect(applier.properties).to.equal(properties);
        expect(applier.applierBlock).to.equal(applierBlock);
    });

    it(@"should raise on initialization with init", ^{
        expect(^{
            __unused id applier = [[MTFThemeClassPropertiesApplier alloc] init];
        }).to.raise(NSInternalInconsistencyException);
    });
});

describe(@"application", ^{
    it(@"should succeed with all properties present in the class being applied", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSArray *properties = @[@"property1", @"property2"];
        NSArray *values = @[@"value1", @"value2"];
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            properties.firstObject: [[MTFThemeConstant alloc] initWithName:properties.firstObject rawValue:values.firstObject mappedValue:nil],
            properties.lastObject: [[MTFThemeConstant alloc] initWithName:properties.lastObject rawValue:values.lastObject mappedValue:nil]
        }];

        __block NSSet *appliedProperties;
        __block NSSet *appliedValues;
        MTFThemeClassPropertiesApplier *applier = [[MTFThemeClassPropertiesApplier alloc] initWithProperties:properties applierBlock:^(NSDictionary *valuesForProperties, id objectToTheme){
            appliedProperties = [NSSet setWithArray:valuesForProperties.allKeys];
            appliedValues = [NSSet setWithArray:[valuesForProperties objectEnumerator].allObjects];
        }];

        BOOL applied = [applier applyClass:class toObject:objectToTheme];
        expect(applied).to.beTruthy();

        NSSet *propertiesSet = [NSSet setWithArray:properties];
        NSSet *valuesSet = [NSSet setWithArray:values];
        expect(appliedProperties).to.equal(propertiesSet);
        expect(appliedValues).to.equal(valuesSet);
    });

    it(@"should fail with not all properties present in the class being applied", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSArray *properties = @[@"property1", @"property2"];
        NSArray *values = @[@"value1", @"value2"];
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            properties.firstObject: [[MTFThemeConstant alloc] initWithName:properties.firstObject rawValue:values.firstObject mappedValue:nil],
            @"anotherProperty": [[MTFThemeConstant alloc] initWithName:@"anotherProperty" rawValue:@"anotherValue" mappedValue:nil]
        }];

        MTFThemeClassPropertiesApplier *applier = [[MTFThemeClassPropertiesApplier alloc]
            initWithProperties:properties
            applierBlock:^(NSDictionary *valuesForProperties, id objectToTheme){}];

        BOOL applied = [applier applyClass:class toObject:objectToTheme];
        expect(applied).to.beFalsy();
    });
});

SpecEnd

SpecBegin(MTFThemeClassTypedValuesPropertiesApplier)

describe(@"lifecycle", ^{
    it(@"should initialize", ^{
        NSArray *properties = @[@"property1", @"property2"];
        NSArray *valueTypes = @[NSString.class, @(@encode(CGPoint))];
        MTFThemePropertiesApplierBlock applierBlock = ^(NSDictionary *valuesForProperties, id objectToTheme){};

        MTFThemeClassTypedValuesPropertiesApplier *applier = [[MTFThemeClassTypedValuesPropertiesApplier alloc] initWithProperties:properties valueTypes:valueTypes applierBlock:applierBlock];

        expect(applier).notTo.beNil();
        expect(applier).to.beKindOf(MTFThemeClassTypedValuesPropertiesApplier.class);

        expect(applier.properties).to.equal(properties);
        expect(applier.valueTypes).to.equal(valueTypes);
        expect(applier.applierBlock).to.equal(applierBlock);
    });

    it(@"should raise on initialization with initWithProperties:applierBlock:", ^{
        expect(^{
            __unused id applier = [[MTFThemeClassTypedValuesPropertiesApplier alloc]
                initWithProperties:@[@"property"]
                applierBlock:^(NSDictionary *valuesForProperties, id objectToTheme){}];
        }).to.raise(NSInternalInconsistencyException);
    });
});

describe(@"application", ^{
    it(@"should succeed with all properties present in the class being applied", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSArray *properties = @[@"property1", @"property2"];
        CGPoint objCValue = (CGPoint){.x = 1.0f, .y = 2.0f};
        NSArray *valueTypes = @[NSString.class, @(@encode(CGPoint))];
        NSArray *values = @[@"value1", [NSValue value:&objCValue withObjCType:@encode(CGPoint)]];
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            properties.firstObject: [[MTFThemeConstant alloc] initWithName:properties.firstObject rawValue:values.firstObject mappedValue:nil],
            properties.lastObject: [[MTFThemeConstant alloc] initWithName:properties.lastObject rawValue:values.lastObject mappedValue:nil]
        }];

        __block NSSet *appliedProperties;
        __block NSSet *appliedValues;
        MTFThemeClassTypedValuesPropertiesApplier *applier = [[MTFThemeClassTypedValuesPropertiesApplier alloc] initWithProperties:properties valueTypes:valueTypes applierBlock:^(NSDictionary *valuesForProperties, id objectToTheme){
            appliedProperties = [NSSet setWithArray:valuesForProperties.allKeys];
            appliedValues = [NSSet setWithArray:[valuesForProperties objectEnumerator].allObjects];
        }];

        BOOL applied = [applier applyClass:class toObject:objectToTheme];
        expect(applied).to.beTruthy();

        NSSet *propertiesSet = [NSSet setWithArray:properties];
        NSSet *valuesSet = [NSSet setWithArray:values];
        expect(appliedProperties).to.equal(propertiesSet);
        expect(appliedValues).to.equal(valuesSet);
    });

    it(@"should fail with not all properties present in the class being applied", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSArray *properties = @[@"property1", @"property2"];
        NSArray *values = @[@"value1", @"value2"];
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            properties.firstObject: [[MTFThemeConstant alloc] initWithName:properties.firstObject rawValue:values.firstObject mappedValue:nil],
            properties.lastObject: [[MTFThemeConstant alloc] initWithName:properties.lastObject rawValue:values.lastObject mappedValue:nil]
        }];

        NSArray *valueTypes = @[NSString.class, @(@encode(CGPoint))];
        MTFThemeClassPropertiesApplier *applier = [[MTFThemeClassTypedValuesPropertiesApplier alloc]
            initWithProperties:properties
            valueTypes:valueTypes
            applierBlock:^(NSDictionary *valuesForProperties, id objectToTheme){}];

        BOOL applied = [applier applyClass:class toObject:objectToTheme];
        expect(applied).to.beFalsy();
    });
});

SpecEnd
