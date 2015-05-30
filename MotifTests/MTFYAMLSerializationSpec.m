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
    it(@"should error on direct initalization", ^{
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

    it(@"should treat garbage data as a nil object and populate the error", ^{
        char byte = 0xFF;
        id object = [MTFYAMLSerialization YAMLObjectWithData:[NSData dataWithBytes:&byte length:1] error:&error];

        expect(object).to.beNil();
        expect(error).notTo.beNil();
        expect(error.domain).to.equal(MTFYAMLSerializationErrorDomain);
    });

    it(@"should treat a mapping as a dictionary", ^{
        id object = objectFromYAML(@"hash: value");

        expect(object).notTo.beNil();
        expect(object).to.beKindOf(NSDictionary.class);
        expect(error).to.beNil();
    });

    it(@"should treat a sequence as an array", ^{
        id object = objectFromYAML(@""
        "- 1\n"
        "- 2");

        expect(object).notTo.beNil();
        expect(object).to.beKindOf(NSArray.class);
        expect(error).to.beNil();
    });

    it(@"should treat a float as an number", ^{
        id object = objectFromYAML(@"1.0");

        expect(object).notTo.beNil();
        expect(object).to.beKindOf(NSNumber.class);
        expect([object floatValue]).to.beCloseTo(1.0);
        expect(error).to.beNil();
    });

    it(@"should treat an integer as an number", ^{
        id object = objectFromYAML(@"1");

        expect(object).notTo.beNil();
        expect(object).to.beKindOf(NSNumber.class);
        expect([object integerValue]).to.equal(1);
        expect(error).to.beNil();
    });

    it(@"should populate the error parameter on anchors", ^{
        id object = objectFromYAML(@"&anchor");

        expect(object).to.beNil();
        expect(error).notTo.beNil();
        expect(error.domain).to.equal(MTFYAMLSerializationErrorDomain);
    });

    it(@"should populate the error parameter on aliases", ^{
        id object = objectFromYAML(@"*anchor");

        expect(object).to.beNil();
        expect(error).notTo.beNil();
        expect(error.domain).to.equal(MTFYAMLSerializationErrorDomain);
    });

    it(@"should populate the error parameter on syntax errors", ^{
        id object = objectFromYAML(@""
        "syntax: error\n"
        " syntax: error");

        expect(object).to.beNil();
        expect(error).notTo.beNil();
        expect(error.domain).to.equal(MTFYAMLSerializationErrorDomain);
        expect(error.userInfo[MTFYAMLSerializationColumnErrorKey]).to.equal(@7);
        expect(error.userInfo[MTFYAMLSerializationLineErrorKey]).to.equal(@1);
    });
});

SpecEnd
