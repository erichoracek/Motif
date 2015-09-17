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

describe(@"lifecycle", ^{
    it(@"should initialize", ^{
        NSString *property = @"Property";
        MTFThemePropertyApplierBlock applierBlock = ^(id propertyValue, id objectToTheme) {};

        MTFThemeClassPropertyApplier *applier = [[MTFThemeClassPropertyApplier alloc] initWithProperty:property applierBlock:applierBlock];

        expect(applier).notTo.beNil();
        expect(applier).to.beKindOf(MTFThemeClassPropertyApplier.class);

        expect(applier.property).to.equal(property);
        expect(applier.applierBlock).to.equal(applierBlock);
    });
});

describe(@"property application", ^{
    it(@"should occur with a class that has the applier's property", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSString *property = @"property";
        NSString *value = @"value";
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            property: [[MTFThemeConstant alloc] initWithName:property rawValue:value mappedValue:nil]
        }];

        __block id appliedValue;
        __block id appliedObject;
        MTFThemeClassPropertyApplier *applier = [[MTFThemeClassPropertyApplier alloc] initWithProperty:property applierBlock:^(id propertyValue, id objectToTheme){
            appliedValue = propertyValue;
            appliedObject = objectToTheme;
        }];

        BOOL applied = [applier applyClass:class toObject:objectToTheme];
        expect(applied).to.beTruthy();
        expect(appliedValue).to.beIdenticalTo(value);
        expect(appliedObject).to.beIdenticalTo(objectToTheme);
    });

    it(@"should not occur with a class that doesn't have the applier's property", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSString *applierProperty = @"applierProperty";
        NSString *classProperty = @"classProperty";
        NSString *value = @"value";
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            classProperty: [[MTFThemeConstant alloc] initWithName:classProperty rawValue:value mappedValue:nil]
        }];

        MTFThemeClassPropertyApplier *applier = [[MTFThemeClassPropertyApplier alloc]
            initWithProperty:applierProperty
            applierBlock:^(id propertyValue, id objectToTheme){}];

        BOOL applied = [applier applyClass:class toObject:objectToTheme];
        expect(applied).to.beFalsy();
    });
});

SpecEnd

SpecBegin(MTFThemeClassValueClassPropertyApplier)

describe(@"lifecycle", ^{
    it(@"should initialize", ^{
        NSString *property = @"Property";
        MTFThemePropertyApplierBlock applierBlock = ^(id propertyValue, id objectToTheme) {};
        Class valueClass = NSString.class;

        MTFThemeClassValueClassPropertyApplier *applier = [[MTFThemeClassValueClassPropertyApplier alloc] initWithProperty:property valueClass:valueClass applierBlock:applierBlock];

        expect(applier).notTo.beNil();
        expect(applier).to.beKindOf(MTFThemeClassValueClassPropertyApplier.class);

        expect(applier.property).to.equal(property);
        expect(applier.valueClass).to.beIdenticalTo(valueClass);
        expect(applier.applierBlock).to.equal(applierBlock);
    });
});

describe(@"property application", ^{
    it(@"should occur with a class that has the applier's property and value class", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        NSString *property = @"property";
        NSString *value = @"value";
        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"class" propertiesConstants:@{
            property: [[MTFThemeConstant alloc] initWithName:property rawValue:value mappedValue:nil]
        }];

        __block id appliedValue;
        __block id appliedObject;
        MTFThemeClassPropertyApplier *applier = [[MTFThemeClassValueClassPropertyApplier alloc] initWithProperty:property valueClass:NSString.class applierBlock:^(id propertyValue, id objectToTheme){
            appliedValue = propertyValue;
            appliedObject = objectToTheme;
        }];

        BOOL applied = [applier applyClass:class toObject:objectToTheme];
        expect(applied).to.beTruthy();
        expect(appliedValue).to.beIdenticalTo(value);
        expect(appliedObject).to.beIdenticalTo(objectToTheme);
    });

    it(@"should not occur with a class that has the applier property but of incorrect type", ^{
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
            applierBlock:^(id propertyValue, id objectToTheme){}];

        BOOL applied = [applier applyClass:class toObject:objectToTheme];
        expect(applied).to.beFalsy();
    });
});

SpecEnd

SpecBegin(MTFThemeClassValueObjCTypePropertyApplier)

describe(@"lifecycle", ^{
    it(@"should initialize", ^{
        NSString *property = @"Property";
        MTFThemePropertyApplierBlock applierBlock = ^(id propertyValue, id objectToTheme) {};
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
    it(@"should occur with a class that has the applier's property and value obj-c type", ^{
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
        MTFThemeClassPropertyApplier *applier = [[MTFThemeClassValueObjCTypePropertyApplier alloc] initWithProperty:property valueObjCType:@encode(CGPoint) applierBlock:^(id propertyValue, id objectToTheme){
            appliedValue = propertyValue;
            appliedObject = objectToTheme;
        }];

        BOOL applied = [applier applyClass:class toObject:objectToTheme];
        expect(applied).to.beTruthy();
        expect(appliedValue).to.beIdenticalTo(wrappedValue);
        expect(appliedObject).to.beIdenticalTo(objectToTheme);
    });

    it(@"should not occur with a class that has the applier property but of incorrect obj-c type", ^{
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
            applierBlock:^(id propertyValue, id objectToTheme){}];

        BOOL applied = [applier applyClass:class toObject:objectToTheme];
        expect(applied).to.beFalsy();
    });
});

SpecEnd
