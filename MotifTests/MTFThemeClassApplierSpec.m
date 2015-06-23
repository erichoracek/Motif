//
//  MTFThemeClassApplierSpec.m
//  Motif
//
//  Created by Eric Horacek on 6/14/15.
//  Copyright © 2015 Eric Horacek. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <Motif/Motif.h>
#import <Motif/MTFThemeClassApplier.h>
#import <Motif/MTFThemeClass_Private.h>

SpecBegin(MTFThemeClassApplier)

describe(@"lifecycle", ^{
    it(@"should initialize", ^{
        MTFThemeClassApplierBlock applierBlock = ^(MTFThemeClass *themeClass, id objectToTheme){};

        MTFThemeClassApplier *applier = [[MTFThemeClassApplier alloc] initWithClassApplierBlock:applierBlock];

        expect(applier).notTo.beNil();
        expect(applier).to.beKindOf(MTFThemeClassApplier.class);

        expect(applier.applierBlock).to.equal(applierBlock);
    });

    it(@"should raise on initialization with init", ^{
        expect(^{
            __unused MTFThemeClassApplier *applier = [[MTFThemeClassApplier alloc] init];
        }).to.raise(NSInternalInconsistencyException);
    });
});

describe(@"application", ^{
    it(@"should occur", ^{
        Class objectClass = NSObject.class;
        id objectToTheme = [[objectClass alloc] init];

        __block MTFThemeClass *appliedClass;
        __block id appliedObject;
        MTFThemeClassApplier *applier = [[MTFThemeClassApplier alloc] initWithClassApplierBlock:^(MTFThemeClass *themeClass, id objectToTheme){
            appliedClass = themeClass;
            appliedObject = objectToTheme;
        }];

        MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:@"" propertiesConstants:@{}];

        BOOL applied = [applier applyClass:class toObject:objectToTheme];
        expect(applied).to.beTruthy();

        expect(appliedClass).notTo.beNil();
        expect(appliedClass).to.beIdenticalTo(class);

        expect(appliedObject).notTo.beNil();
        expect(appliedObject).to.beIdenticalTo(objectToTheme);
    });
});

SpecEnd
