//
//  NSValueTransformer_MotifUIOffsetSpec.m
//  Motif
//
//  Created by Eric Horacek on 6/6/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import Specta;
@import Expecta;
@import Motif;
#import <Motif/NSValueTransformer+TypeFiltering.h>

SpecBegin(NSValueTransformer_MotifUIOffsetSpecs)

typedef UIOffset TransformedValueCType;
static const char * const TransformedValueObjCType = @encode(TransformedValueCType);

describe(@"values", ^{
    typeof(TransformedValueCType)(^transformValue)(id) = ^typeof(TransformedValueCType)(id value) {
        NSValueTransformer *valueTransformer = [NSValueTransformer
            mtf_valueTransformerForTransformingObject:value
            toObjCType:TransformedValueObjCType];

        expect(valueTransformer).notTo.beNil();
        NSValue *transformedValue = [valueTransformer transformedValue:value];

        expect(transformedValue).notTo.beNil();
        expect(transformedValue).to.beKindOf(NSValue.class);
        expect(strcmp(transformedValue.objCType, TransformedValueObjCType)).to.equal(0);

        typeof(TransformedValueCType) objCTypeValue;
        [transformedValue getValue:&objCTypeValue];
        return objCTypeValue;
    };

    describe(@"from a number", ^{
        it(@"should transform", ^{
            typeof(TransformedValueCType) value = transformValue(@1);

            expect(value.horizontal).to.beCloseTo(1.0f);
            expect(value.vertical).to.beCloseTo(1.0f);
        });
    });

    describe(@"from an array", ^{
        it(@"should transform with two elements", ^{
            typeof(TransformedValueCType) value = transformValue(@[@1, @2]);

            expect(value.horizontal).to.beCloseTo(1.0f);
            expect(value.vertical).to.beCloseTo(2.0f);
        });

        it(@"should raise an exception with more than two elements", ^{
            expect(^{
                transformValue(@[@1, @2, @3]);
            }).to.raise(NSInternalInconsistencyException);
        });

        it(@"should raise an exception with one element", ^{
            expect(^{
                transformValue(@[@1]);
            }).to.raise(NSInternalInconsistencyException);
        });

        it(@"should raise an exception with an invalid value type", ^{
            expect(^{
                transformValue(@[@"notNumber", @"notNumber"]);
            }).to.raise(NSInternalInconsistencyException);
        });
    });

    describe(@"values from a dictionary", ^{
        it(@"should transform", ^{
            typeof(TransformedValueCType) value = transformValue(@{
                @"horizontal": @1,
                @"vertical": @2,
            });

            expect(value.horizontal).to.beCloseTo(1.0f);
            expect(value.vertical).to.beCloseTo(2.0f);
        });

        it(@"should raise an exception with an invalid key", ^{
            expect(^{
                transformValue(@{
                    @"invalid": @1
                });
            }).to.raise(NSInternalInconsistencyException);
        });

        it(@"should raise an exception with an invalid value", ^{
            expect(^{
                transformValue(@{
                    @"horizontal": @"notANumber"
                });
            }).to.raise(NSInternalInconsistencyException);
        });
    });
});

SpecEnd
