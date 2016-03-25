//
//  MTFThemeConstantSpec.m
//  Motif
//
//  Created by Eric Horacek on 1/6/16.
//  Copyright © 2016 Eric Horacek. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <Motif/MTFThemeConstant_Private.h>

SpecBegin(MTFThemeConstant)

describe(@"equality", ^{
    NSString *name = @"name";
    NSString *anotherName = @"anotherName";
    NSString *rawValue = @"rawValue";
    NSString *anotherRawValue = @"anotherRawValue";
    NSString *referencedValue = @"referencedValue";
    NSString *anotherReferencedValue = @"anotherReferencedValue";

    it(@"should equal another constant", ^{
        MTFThemeConstant *constant1 = [[MTFThemeConstant alloc]
            initWithName:name
            rawValue:rawValue
            referencedValue:referencedValue];
            
        MTFThemeConstant *constant2 = [[MTFThemeConstant alloc]
            initWithName:name
            rawValue:rawValue
            referencedValue:referencedValue];

        expect(constant1).to.equal(constant2);
    });

    it(@"should not equal another constant with a different name", ^{
        MTFThemeConstant *constant1 = [[MTFThemeConstant alloc]
            initWithName:name
            rawValue:rawValue
            referencedValue:referencedValue];
            
        MTFThemeConstant *constant2 = [[MTFThemeConstant alloc]
            initWithName:anotherName
            rawValue:rawValue
            referencedValue:referencedValue];

        expect(constant1).notTo.equal(constant2);
    });

    it(@"should not equal another constant with a different raw value", ^{
        MTFThemeConstant *constant1 = [[MTFThemeConstant alloc]
            initWithName:name
            rawValue:rawValue
            referencedValue:referencedValue];
            
        MTFThemeConstant *constant2 = [[MTFThemeConstant alloc]
            initWithName:name
            rawValue:anotherRawValue
            referencedValue:referencedValue];

        expect(constant1).notTo.equal(constant2);
    });

    it(@"should not equal another constant with a different referenced value", ^{
        MTFThemeConstant *constant1 = [[MTFThemeConstant alloc]
            initWithName:name
            rawValue:rawValue
            referencedValue:referencedValue];
            
        MTFThemeConstant *constant2 = [[MTFThemeConstant alloc]
            initWithName:name
            rawValue:rawValue
            referencedValue:anotherReferencedValue];

        expect(constant1).notTo.equal(constant2);
    });

    it(@"should not equal another constant with a nil referenced value", ^{
        MTFThemeConstant *constant1 = [[MTFThemeConstant alloc]
            initWithName:name
            rawValue:rawValue
            referencedValue:referencedValue];
            
        MTFThemeConstant *constant2 = [[MTFThemeConstant alloc]
            initWithName:name
            rawValue:rawValue
            referencedValue:nil];

        expect(constant1).notTo.equal(constant2);
    });
});

SpecEnd
