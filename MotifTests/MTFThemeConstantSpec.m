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
    NSString *mappedValue = @"mappedValue";
    NSString *anotherMappedValue = @"anotherMappedValue";

    it(@"should equal another constant", ^{
        MTFThemeConstant *constant1 = [[MTFThemeConstant alloc]
            initWithName:name
            rawValue:rawValue
            mappedValue:mappedValue];
            
        MTFThemeConstant *constant2 = [[MTFThemeConstant alloc]
            initWithName:name
            rawValue:rawValue
            mappedValue:mappedValue];

        expect(constant1).to.equal(constant2);
    });

    it(@"should not equal another constant with a different name", ^{
        MTFThemeConstant *constant1 = [[MTFThemeConstant alloc]
            initWithName:name
            rawValue:rawValue
            mappedValue:mappedValue];
            
        MTFThemeConstant *constant2 = [[MTFThemeConstant alloc]
            initWithName:anotherName
            rawValue:rawValue
            mappedValue:mappedValue];

        expect(constant1).notTo.equal(constant2);
    });

    it(@"should not equal another constant with a different raw value", ^{
        MTFThemeConstant *constant1 = [[MTFThemeConstant alloc]
            initWithName:name
            rawValue:rawValue
            mappedValue:mappedValue];
            
        MTFThemeConstant *constant2 = [[MTFThemeConstant alloc]
            initWithName:name
            rawValue:anotherRawValue
            mappedValue:mappedValue];

        expect(constant1).notTo.equal(constant2);
    });

    it(@"should not equal another constant with a different mapped value", ^{
        MTFThemeConstant *constant1 = [[MTFThemeConstant alloc]
            initWithName:name
            rawValue:rawValue
            mappedValue:mappedValue];
            
        MTFThemeConstant *constant2 = [[MTFThemeConstant alloc]
            initWithName:name
            rawValue:rawValue
            mappedValue:anotherMappedValue];

        expect(constant1).notTo.equal(constant2);
    });

    it(@"should not equal another constant with a nil mapped value", ^{
        MTFThemeConstant *constant1 = [[MTFThemeConstant alloc]
            initWithName:name
            rawValue:rawValue
            mappedValue:mappedValue];
            
        MTFThemeConstant *constant2 = [[MTFThemeConstant alloc]
            initWithName:name
            rawValue:rawValue
            mappedValue:nil];

        expect(constant1).notTo.equal(constant2);
    });
});

SpecEnd
