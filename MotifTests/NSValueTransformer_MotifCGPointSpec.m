//
//  NSValueTransformer_MotifCGPointSpec.m
//  Motif
//
//  Created by Eric Horacek on 6/6/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <Motif/Motif.h>
#import <Motif/NSValueTransformer+TypeFiltering.h>
#import <Motif/MTFValueTransformerErrorHandling.h>

SpecBegin(NSValueTransformer_MotifCGPointSpecs)

typedef CGPoint StructType;
static const char * const ObjCType = @encode(StructType);

__block NSError *error;
__block BOOL success;
__block typeof(StructType) value;

beforeEach(^{
    error = nil;
    success = NO;
    value = (typeof(StructType)){};
});

describe(@"values", ^{
    BOOL(^transformValue)(id, typeof(StructType) *, NSError **) = ^ (id value, typeof(StructType) *objCTypeValue, NSError **error) {
        NSValueTransformer<MTFValueTransformerErrorHandling> *transformer = (id<MTFValueTransformerErrorHandling>)[NSValueTransformer
            mtf_valueTransformerForTransformingObject:value
            toObjCType:ObjCType];

        expect(transformer).notTo.beNil();
        NSValue *transformedValue = [transformer transformedValue:value error:error];
        if (transformedValue == nil) return NO;

        expect(transformedValue).notTo.beNil();
        expect(transformedValue).to.beKindOf(NSValue.class);
        expect(strcmp(transformedValue.objCType, ObjCType)).to.equal(0);

        [transformedValue getValue:objCTypeValue];
        return YES;
    };

    describe(@"from a number", ^{
        it(@"should transform", ^{
            success = transformValue(@1, &value, &error);
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect(value.x).to.beCloseTo(1.0f);
            expect(value.y).to.beCloseTo(1.0f);
        });
    });

    describe(@"from an array", ^{
        it(@"should transform with two elements", ^{
            success = transformValue(@[ @1, @2 ], &value, &error);
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect(value.x).to.beCloseTo(1.0f);
            expect(value.y).to.beCloseTo(2.0f);
        });

        it(@"should error with more than two elements", ^{
            success = transformValue(@[ @1, @2, @3 ], &value, &error);
            expect(success).to.beFalsy();

            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFErrorDomain);
            expect(error.code).to.equal(MTFErrorFailedToApplyTheme);
        });

        it(@"should error with one element", ^{
            success = transformValue(@[ @1 ], &value, &error);
            expect(success).to.beFalsy();

            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFErrorDomain);
            expect(error.code).to.equal(MTFErrorFailedToApplyTheme);

        });

        it(@"should error with an invalid value type", ^{
            success = transformValue(@[@"notNumber", @"notNumber"], &value, &error);
            expect(success).to.beFalsy();

            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFErrorDomain);
            expect(error.code).to.equal(MTFErrorFailedToApplyTheme);
        });
    });

    describe(@"values from a dictionary", ^{
        it(@"should transform", ^{
            success = transformValue(@{ @"x": @1, @"y": @2 }, &value, &error);
            expect(error).to.beNil();

            expect(value.x).to.beCloseTo(1.0f);
            expect(value.y).to.beCloseTo(2.0f);
        });

        it(@"should error with an invalid key", ^{
            success = transformValue(@{ @"invalid": @1 }, &value, &error);

            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFErrorDomain);
            expect(error.code).to.equal(MTFErrorFailedToApplyTheme);
        });

        it(@"should error with an invalid value", ^{
            success = transformValue(@{ @"x": @"notANumber" }, &value, &error);

            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFErrorDomain);
            expect(error.code).to.equal(MTFErrorFailedToApplyTheme);
        });
    });
});

SpecEnd
