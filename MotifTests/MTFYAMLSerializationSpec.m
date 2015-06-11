//
//  MTFYAMLSerializationSpec.m
//  Motif
//
//  Created by Eric Horacek on 5/29/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import Motif;
@import Specta;
@import Expecta;

#import "MTFYAMLSerialization.h"

SpecBegin(MTFYAMLSerialization)

describe(@"lifecycle", ^{
    it(@"should raise an exception on direct initalization", ^{
        expect(^{
            __unused MTFYAMLSerialization *serialization = [[MTFYAMLSerialization alloc] init];
        }).to.raise(NSInternalInconsistencyException);
    });
});

describe(@"deserialization from data", ^{
    __block NSError *error;
    __block MTFTheme *theme;

    id(^objectFromYAML)(NSString *) = ^(NSString *YAML) {
        NSData *data = [YAML dataUsingEncoding:NSUTF8StringEncoding];
        return [MTFYAMLSerialization YAMLObjectWithData:data error:&error];
    };

    beforeEach(^{
        error = nil;
        theme = nil;
    });

    it(@"should treat empty data as a nil object", ^{
        id object = [MTFYAMLSerialization YAMLObjectWithData:[NSData data] error:&error];

        expect(object).to.beNil();
        expect(error).to.beNil();
    });

    it(@"should treat garbage data as a nil object and populate the error parameter", ^{
        char byte = 0xFF;
        id object = [MTFYAMLSerialization YAMLObjectWithData:[NSData dataWithBytes:&byte length:1] error:&error];

        expect(object).to.beNil();
        expect(error).notTo.beNil();
        expect(error.domain).to.equal(MTFYAMLSerializationErrorDomain);
    });

    it(@"should treat a mapping as a dictionary", ^{
        NSDictionary *mapping = objectFromYAML(@"key1: value\nkey2: value");

        expect(mapping).notTo.beNil();
        expect(mapping).to.beKindOf(NSDictionary.class);
        expect(mapping.count).to.equal(2);
        expect(mapping[@"key1"]).to.equal(@"value");
        expect(mapping[@"key2"]).to.equal(@"value");
        expect(error).to.beNil();
    });

    it(@"should treat a braced mapping as a dictionary", ^{
        NSDictionary *mapping = objectFromYAML(@"{key1: value, key2: value}");

        expect(mapping).notTo.beNil();
        expect(mapping).to.beKindOf(NSDictionary.class);
        expect(mapping.count).to.equal(2);
        expect(mapping[@"key1"]).to.equal(@"value");
        expect(mapping[@"key2"]).to.equal(@"value");
        expect(error).to.beNil();
    });

    it(@"should treat a sequence as an array", ^{
        NSArray *sequence = objectFromYAML(@"- 1\n- 2");

        expect(sequence).notTo.beNil();
        expect(sequence).to.beKindOf(NSArray.class);
        expect(sequence.count).to.equal(2);
        expect(sequence.firstObject).to.equal(@1);
        expect(sequence.lastObject).to.equal(@2);
        expect(error).to.beNil();
    });

    it(@"should treat a bracketed sequence as an array", ^{
        NSArray *sequence = objectFromYAML(@"[1, true]");

        expect(sequence).notTo.beNil();
        expect(sequence).to.beKindOf(NSArray.class);
        expect(sequence.count).to.equal(2);
        expect(sequence.firstObject).to.equal(@1);
        expect(sequence.lastObject).to.equal(@YES);
        expect(error).to.beNil();
    });

    describe(@"scalars", ^{
        afterEach(^{
            expect(error).to.beNil();
        });

        describe(@"with numeric values", ^{
            it(@"should handle positive floats", ^{
                NSNumber *number = objectFromYAML(@"1.0");

                expect(number).notTo.beNil();
                expect(number).to.beKindOf(NSNumber.class);
                expect(number.floatValue).to.beCloseTo(1.0);
            });

            it(@"should handle negative floats", ^{
                NSNumber *number = objectFromYAML(@"-1.0");

                expect(number).notTo.beNil();
                expect(number).to.beKindOf(NSNumber.class);
                expect(number.floatValue).to.beCloseTo(-1.0);
            });

            it(@"should handle floats beginning with a zero", ^{
                NSNumber *number = objectFromYAML(@"0.5");

                expect(number).notTo.beNil();
                expect(number).to.beKindOf(NSNumber.class);
                expect(number.floatValue).to.beCloseTo(0.5);
            });

            it(@"should handle floats ending with a decimal point", ^{
                NSNumber *number = objectFromYAML(@"1.");

                expect(number).notTo.beNil();
                expect(number).to.beKindOf(NSNumber.class);
                expect(number.floatValue).to.beCloseTo(1.);
            });

            it(@"should handle negative floats beginning with a zero", ^{
                NSNumber *number = objectFromYAML(@"-0.5");

                expect(number).notTo.beNil();
                expect(number).to.beKindOf(NSNumber.class);
                expect(number.floatValue).to.beCloseTo(-0.5);
            });

            it(@"should handle zero as a float", ^{
                NSNumber *number = objectFromYAML(@"0.0");

                expect(number).notTo.beNil();
                expect(number).to.beKindOf(NSNumber.class);
                expect(number.floatValue).to.beCloseTo(0.0);
            });

            it(@"should handle positive integers", ^{
                NSNumber *number = objectFromYAML(@"1");

                expect(number).notTo.beNil();
                expect(number).to.beKindOf(NSNumber.class);
                expect(number.integerValue).to.equal(1);
            });

            it(@"should handle negative integers", ^{
                NSNumber *number = objectFromYAML(@"-1");

                expect(number).notTo.beNil();
                expect(number).to.beKindOf(NSNumber.class);
                expect(number.integerValue).to.equal(-1);
            });

            it(@"should handle zero as an integer", ^{
                NSNumber *number = objectFromYAML(@"0");

                expect(number).notTo.beNil();
                expect(number).to.beKindOf(NSNumber.class);
                expect(number.integerValue).to.equal(0);
            });

            it(@"should handle scientific notation", ^{
                NSNumber *number = objectFromYAML(@"10e2");

                expect(number).notTo.beNil();
                expect(number).to.beKindOf(NSNumber.class);
                expect(number.floatValue).to.beCloseTo(1000.0);
            });

            it(@"should handle scientific notation with an uppercase E", ^{
                NSNumber *number = objectFromYAML(@"10E2");

                expect(number).notTo.beNil();
                expect(number).to.beKindOf(NSNumber.class);
                expect(number.floatValue).to.beCloseTo(1000.0);
            });

            it(@"should handle scientific notation with a positive exponent", ^{
                NSNumber *number = objectFromYAML(@"10e+2");

                expect(number).notTo.beNil();
                expect(number).to.beKindOf(NSNumber.class);
                expect(number.floatValue).to.beCloseTo(1000.0);
            });

            it(@"should handle scientific notation with a negative exponent", ^{
                NSNumber *number = objectFromYAML(@"10e-2");

                expect(number).notTo.beNil();
                expect(number).to.beKindOf(NSNumber.class);
                expect(number.floatValue).to.beCloseTo(0.1);
            });

            it(@"should handle nans", ^{
                NSDecimalNumber *number = objectFromYAML(@".nan");

                expect(number).notTo.beNil();
                expect(number).to.beKindOf(NSDecimalNumber.class);
                expect(number).to.equal([NSDecimalNumber notANumber]);
            });

            it(@"should handle infinity", ^{
                NSNumber *number = objectFromYAML(@".inf");

                expect(number).notTo.beNil();
                expect(number).to.beKindOf(NSNumber.class);
                expect(number.floatValue).to.equal(INFINITY);
            });

            it(@"should handle negative infinity", ^{
                NSNumber *number = objectFromYAML(@"-.inf");

                expect(number).notTo.beNil();
                expect(number).to.beKindOf(NSNumber.class);
                expect(number.floatValue).to.equal(-INFINITY);
            });
        });

        describe(@"with boolean values", ^{
            it(@"should handle 'true' boolean", ^{
                NSNumber *number = objectFromYAML(@"true");

                expect(number).notTo.beNil();
                expect(number).to.beKindOf(NSNumber.class);
                expect(number.boolValue).to.equal(@YES);
            });

            it(@"should handle 'false' boolean", ^{
                NSNumber *number = objectFromYAML(@"false");

                expect(number).notTo.beNil();
                expect(number).to.beKindOf(NSNumber.class);
                expect(number.boolValue).to.equal(@NO);
            });
        });

        describe(@"with null values", ^{
            it(@"should handle nulls", ^{
                NSNull *null = objectFromYAML(@"null");

                expect(null).notTo.beNil();
                expect(null).to.beKindOf(NSNull.class);
            });
        });

        describe(@"with string values", ^{
            it(@"should handle single-quoted strings", ^{
                NSString *string = objectFromYAML(@"'string'");

                expect(string).notTo.beNil();
                expect(string).to.beKindOf(NSString.class);
                expect(string).to.equal(@"string");
            });

            it(@"should handle double-quoted strings", ^{
                NSString *string = objectFromYAML(@"\"string\"");

                expect(string).notTo.beNil();
                expect(string).to.beKindOf(NSString.class);
                expect(string).to.equal(@"string");
            });

            it(@"should handle plain strings", ^{
                NSString *string = objectFromYAML(@"string");

                expect(string).notTo.beNil();
                expect(string).to.beKindOf(NSString.class);
                expect(string).to.equal(@"string");
            });
        });
    });

    describe(@"explicitly tagged values", ^{
        it(@"should the null tag", ^{
            NSNull *null = objectFromYAML(@"!!null null");

            expect(null).notTo.beNil();
            expect(null).to.beKindOf(NSNull.class);
        });

        it(@"should handle the bool tag", ^{
            NSNumber *number = objectFromYAML(@"!!bool false");

            expect(number).notTo.beNil();
            expect(number).to.beKindOf(NSNumber.class);
            expect(number.boolValue).to.equal(@NO);
        });

        it(@"should handle the float tag", ^{
            NSNumber *number = objectFromYAML(@"!!float -1.0");

            expect(number).notTo.beNil();
            expect(number).to.beKindOf(NSNumber.class);
            expect(number.floatValue).to.beCloseTo(-1.0f);
        });

        it(@"should handle the int tag", ^{
            NSNumber *number = objectFromYAML(@"!!int 1");

            expect(number).notTo.beNil();
            expect(number).to.beKindOf(NSNumber.class);
            expect(number.integerValue).to.equal(1);
        });

        it(@"should handle the string tag", ^{
            NSNull *number = objectFromYAML(@"!!str string");

            expect(number).notTo.beNil();
            expect(number).to.beKindOf(NSString.class);
            expect(number).to.equal(@"string");
        });

        it(@"should handle the map tag", ^{
            NSDictionary *map = objectFromYAML(@"!!map {1: 2}");

            expect(map).notTo.beNil();
            expect(map).to.beKindOf(NSDictionary.class);
            expect(map).to.equal(@{@1: @2});
        });

        it(@"should handle the seq tag", ^{
            NSDictionary *seq = objectFromYAML(@"!!seq [1, 2]");

            expect(seq).notTo.beNil();
            expect(seq).to.beKindOf(NSArray.class);
            expect(seq).to.equal(@[@1, @2]);
        });
    });

    describe(@"anchors and aliases", ^{
        it(@"should populate the error parameter on anchors", ^{
            id object = objectFromYAML(@"&anchor");

            expect(object).to.beNil();
            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFYAMLSerializationErrorDomain);
        });

        it(@"should populate the error parameter on aliases", ^{
            id object = objectFromYAML(@"default: &alias\n*default");

            expect(object).to.beNil();
            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFYAMLSerializationErrorDomain);
        });
    });

    describe(@"tags", ^{
        it(@"should populate the error parameter on unhandled tags", ^{
            id object = objectFromYAML(@"!!binary 1234");

            expect(object).to.beNil();
            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFYAMLSerializationErrorDomain);
        });

        it(@"should populate the error parameter on custom tags", ^{
            id object = objectFromYAML(@"!customTag 1234");

            expect(object).to.beNil();
            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFYAMLSerializationErrorDomain);
        });
    });

    it(@"should populate the error parameter on syntax errors", ^{
        id object = objectFromYAML(@"syntax: error\n syntax: error");

        expect(object).to.beNil();
        expect(error).notTo.beNil();
        expect(error.domain).to.equal(MTFYAMLSerializationErrorDomain);
        expect(error.userInfo[MTFYAMLSerializationColumnErrorKey]).to.equal(@7);
        expect(error.userInfo[MTFYAMLSerializationLineErrorKey]).to.equal(@1);
    });
});

SpecEnd
