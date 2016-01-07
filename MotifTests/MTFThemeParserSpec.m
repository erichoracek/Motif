//
//  MTFThemeParserSpec.m
//  Motif
//
//  Created by Eric Horacek on 1/4/16.
//  Copyright © 2016 Eric Horacek. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <Motif/MTFThemeParser.h>

SpecBegin(MTFThemeParser)

describe(@"initialization", ^{
    it(@"should raise when initialized via init", ^{
        expect(^{
            __unused id parser = [(id)[MTFThemeParser alloc] init];
        }).to.raise(NSInternalInconsistencyException);
    });
});

SpecEnd
