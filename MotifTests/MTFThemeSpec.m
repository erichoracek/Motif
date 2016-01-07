//
//  MTFThemeSpec.m
//  Motif
//
//  Created by Eric Horacek on 1/4/16.
//  Copyright © 2016 Eric Horacek. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <Motif/Motif.h>
#import <Motif/MTFTheme_Private.h>
#import <Motif/MTFThemeClass_Private.h>
#import <Motif/MTFThemeConstant.h>
#import <Motif/NSString+ThemeSymbols.h>

SpecBegin(MTFTheme)

__block BOOL success;
__block NSError *error;
__block MTFTheme *theme;
__block NSBundle *bundle;

beforeEach(^{
    success = NO;
    error = nil;
    theme = nil;
    bundle = [NSBundle bundleForClass:self.class];
});

describe(@"initialization", ^{
    it(@"should raise when initialized via init", ^{
        expect(^{
            theme = [(id)[MTFTheme alloc] init];
        }).to.raise(NSInternalInconsistencyException);
    });

    describe(@"from a URL", ^{
        it(@"should fail when not referencing a file", ^{
            NSURL *nonFileURL = [NSURL URLWithString:@"http://www.google.com"];
            theme = [[MTFTheme alloc] initWithFile:nonFileURL error:&error];

            expect(theme).to.beNil();
            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFErrorDomain);
            expect(error.code).to.equal(MTFErrorFailedToParseTheme);
        });

        it(@"should fail when referencing a file that doesn't exist", ^{
            NSURL *temporaryURL = [NSURL URLWithString:NSTemporaryDirectory()];
            expect(temporaryURL).notTo.beNil();

            NSURL *fileURL = [temporaryURL URLByAppendingPathComponent:[NSUUID UUID].UUIDString];

            MTFTheme *theme = [[MTFTheme alloc] initWithFile:fileURL error:&error];

            expect(theme).to.beNil();
            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFErrorDomain);
            expect(error.code).to.equal(MTFErrorFailedToParseTheme);
        });

        it(@"should fail when referencing a file with invalid contents", ^{
            NSURL *fileURL = [bundle URLForResource:@"InvalidJSONTheme" withExtension:@"json"];

            MTFTheme *theme = [[MTFTheme alloc] initWithFile:fileURL error:&error];

            expect(theme).to.beNil();
            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFErrorDomain);
            expect(error.code).to.equal(MTFErrorFailedToParseTheme);
        });

        it(@"should succeed when referencing a file with valid contents", ^{
            NSURL *fileURL = [bundle URLForResource:@"BasicTheme" withExtension:@"json"];

            theme = [[MTFTheme alloc] initWithFile:fileURL error:&error];
            
            expect(theme).to.beAnInstanceOf(MTFTheme.class);
            expect(error).to.beNil();
        });
    });

    describe(@"from a name", ^{
        it(@"should fail when referencing an unknown file", ^{
            theme = [MTFTheme themeFromFileNamed:@"unknown" error:&error];

            expect(theme).to.beNil();
            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFErrorDomain);
            expect(error.code).to.equal(MTFErrorFailedToParseTheme);
        });

        it(@"should succeed when referencing a known file", ^{
            theme = [MTFTheme themeFromFilesNamed:@[ @"Basic" ] bundle:bundle error:&error];

            expect(theme).to.beAnInstanceOf(MTFTheme.class);
            expect(error).to.beNil();
        });
    });
});

describe(@"names", ^{
    it(@"should match the filenames", ^{
        NSString *name = @"Basic";
        NSURL *fileURL = [bundle URLForResource:name withExtension:@"json"];

        theme = [[MTFTheme alloc] initWithFile:fileURL error:&error];

        expect(theme).to.beAnInstanceOf(MTFTheme.class);
        expect(theme.names).to.haveACountOf(1);
        expect(theme.names.firstObject).to.equal(name);
        expect(error).to.beNil();
    });

    it(@"should trim a trailing 'theme' string from the filename", ^{
        NSString *name = @"Basic";
        NSString *filename = [NSString stringWithFormat:@"%@Theme", name];
        NSURL *fileURL = [bundle URLForResource:filename withExtension:@"json"];

        theme = [[MTFTheme alloc] initWithFile:fileURL error:&error];

        expect(theme).to.beAnInstanceOf(MTFTheme.class);
        expect(theme.names).to.haveACountOf(1);
        expect(theme.names.firstObject).to.equal(name);
        expect(error).to.beNil();
    });
});

describe(@"filenames", ^{
    it(@"should match the filenames", ^{
        NSURL *fileURL = [bundle URLForResource:@"Basic" withExtension:@"json"];

        theme = [[MTFTheme alloc] initWithFile:fileURL error:&error];

        expect(theme).to.beAnInstanceOf(MTFTheme.class);
        expect(theme.names).to.haveACountOf(1);
        expect(theme.filenames.firstObject).to.equal(@"Basic.json");
        expect(error).to.beNil();
    });
});

describe(@"raw theme parsing", ^{
    MTFTheme *(^themeFromDictionary)(NSDictionary *) = ^(NSDictionary *dictionary) {
        return [[MTFTheme alloc] initWithThemeDictionary:dictionary error:&error];
    };

    MTFTheme *(^themeFromDictionaries)(NSArray<NSDictionary *> *) = ^(NSArray<NSDictionary *> *dictionaries) {
        return [[MTFTheme alloc] initWithThemeDictionaries:dictionaries error:&error];
    };

    NSString *class = @".Class";
    NSString *anotherClass = @".AnotherClass";
    NSString *constant = @"$Constant";
    NSString *anotherConstant = @"$AnotherConstant";
    NSString *yetAnotherConstant = @"$AnotherConstant";
    NSString *property = @"property";
    NSString *stringValue = @"value";
    NSNumber *numberValue = @0;

    describe(@"syntax", ^{
        it(@"should fail with an invalid symbol", ^{
            theme = themeFromDictionary(@{ @"InvalidSymbol": stringValue });

            expect(theme).to.beNil();
            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFErrorDomain);
            expect(error.code).to.equal(MTFErrorFailedToParseTheme);
        });
    });

    describe(@"constants", ^{
        it(@"should succeed with a string value", ^{
            theme = themeFromDictionary(@{ constant: stringValue });

            expect(theme).to.beAnInstanceOf(MTFTheme.class);
            expect(error).to.beNil();

            MTFThemeConstant *themeConstant = theme.constants[constant.mtf_symbol];
            expect(themeConstant).to.beAnInstanceOf(MTFThemeConstant.class);
            expect(themeConstant.name).to.equal(constant.mtf_symbol);
            expect(themeConstant.value).to.equal(stringValue);
        });

        it(@"should succeed with a numeric value", ^{
            theme = themeFromDictionary(@{ constant: numberValue });

            expect(theme).to.beAnInstanceOf(MTFTheme.class);
            expect(error).to.beNil();

            MTFThemeConstant *themeConstant = theme.constants[constant.mtf_symbol];
            expect(themeConstant).to.beAnInstanceOf(MTFThemeConstant.class);
            expect(themeConstant.name).to.equal(constant.mtf_symbol);
            expect(themeConstant.value).to.equal(numberValue);
        });

        it(@"should succeed with referencing another constant", ^{
            theme = themeFromDictionary(@{
                constant: stringValue,
                anotherConstant: constant
            });

            expect(theme).to.beAnInstanceOf(MTFTheme.class);
            expect(error).to.beNil();

            MTFThemeConstant *themeConstant = theme.constants[constant.mtf_symbol];
            expect(themeConstant).to.beAnInstanceOf(MTFThemeConstant.class);
            expect(themeConstant.name).to.equal(constant.mtf_symbol);
            expect(themeConstant.value).to.equal(stringValue);

            MTFThemeConstant *anotherThemeConstant = theme.constants[anotherConstant.mtf_symbol];
            expect(anotherThemeConstant).to.beAnInstanceOf(MTFThemeConstant.class);
            expect(anotherThemeConstant.name).to.equal(anotherConstant.mtf_symbol);
            expect(anotherThemeConstant.value).to.equal(stringValue);
        });

        it(@"should fail when referencing another unrecognized constant", ^{
            theme = themeFromDictionary(@{
                constant: anotherConstant,
            });

            expect(theme).to.beNil();
            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFErrorDomain);
            expect(error.code).to.equal(MTFErrorFailedToParseTheme);
        });

        it(@"should fail when referencing itself", ^{
            theme = themeFromDictionary(@{
                constant: constant,
            });

            expect(theme).to.beNil();
            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFErrorDomain);
            expect(error.code).to.equal(MTFErrorFailedToParseTheme);
        });


        it(@"should succeed with referencing another constant that references yet another constant", ^{
            theme = themeFromDictionary(@{
                constant: stringValue,
                anotherConstant: constant,
                yetAnotherConstant: anotherConstant,
            });

            expect(theme).to.beAnInstanceOf(MTFTheme.class);
            expect(error).to.beNil();

            MTFThemeConstant *themeConstant = theme.constants[constant.mtf_symbol];
            expect(themeConstant).to.beAnInstanceOf(MTFThemeConstant.class);
            expect(themeConstant.name).to.equal(constant.mtf_symbol);
            expect(themeConstant.value).to.equal(stringValue);

            MTFThemeConstant *anotherThemeConstant = theme.constants[anotherConstant.mtf_symbol];
            expect(anotherThemeConstant).to.beAnInstanceOf(MTFThemeConstant.class);
            expect(anotherThemeConstant.name).to.equal(anotherConstant.mtf_symbol);
            expect(anotherThemeConstant.value).to.equal(stringValue);

            MTFThemeConstant *yetAnotherThemeConstant = theme.constants[yetAnotherConstant.mtf_symbol];
            expect(yetAnotherThemeConstant).to.beAnInstanceOf(MTFThemeConstant.class);
            expect(yetAnotherThemeConstant.name).to.equal(yetAnotherConstant.mtf_symbol);
            expect(yetAnotherThemeConstant.value).to.equal(stringValue);
        });

        it(@"should succeed when referencing a class", ^{
            theme = themeFromDictionary(@{
                class: @{ property: stringValue },
                constant: class,
            });

            expect(theme).to.beAnInstanceOf(MTFTheme.class);
            expect(error).to.beNil();

            MTFThemeConstant *themeConstant = theme.constants[constant.mtf_symbol];
            expect(themeConstant).to.beAnInstanceOf(MTFThemeConstant.class);
            expect(themeConstant.name).to.equal(constant.mtf_symbol);

            MTFThemeClass *themeClass = themeConstant.value;
            expect(themeClass).to.beAnInstanceOf(MTFThemeClass.class);
            expect(themeClass.properties.allKeys).to.haveACountOf(1);
            expect(themeClass.properties[property]).to.equal(stringValue);
        });
    });

    describe(@"classes", ^{
        it(@"should fail when mapped to a non-dictionary object", ^{
            theme = themeFromDictionary(@{ class: @0 });

            expect(theme).to.beNil();
            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFErrorDomain);
            expect(error.code).to.equal(MTFErrorFailedToParseTheme);
        });

        it(@"should succeed with a valid property and value pair", ^{
            theme = themeFromDictionary(@{
                class: @{ property: stringValue },
            });

            expect(theme).to.beAnInstanceOf(MTFTheme.class);
            expect(error).to.beNil();

            MTFThemeClass *themeClass = theme.classes[class.mtf_symbol];
            expect(themeClass).to.beAnInstanceOf(MTFThemeClass.class);
            expect(themeClass.name).to.equal(class.mtf_symbol);
            expect(themeClass.properties.allKeys).to.haveACountOf(1);
            expect(themeClass.properties[property]).to.equal(stringValue);
        });

        it(@"should succeed when a property references a constant", ^{
            theme = themeFromDictionary(@{
                constant: stringValue,
                class: @{ property: constant },
            });

            expect(theme).to.beAnInstanceOf(MTFTheme.class);
            expect(error).to.beNil();

            MTFThemeClass *themeClass = theme.classes[class.mtf_symbol];
            expect(themeClass).to.beAnInstanceOf(MTFThemeClass.class);
            expect(themeClass.name).to.equal(class.mtf_symbol);
            expect(themeClass.properties.allKeys).to.haveACountOf(1);
            expect(themeClass.properties[property]).to.equal(stringValue);
        });

        it(@"should succeed when a property references a class", ^{
            theme = themeFromDictionary(@{
                class: @{ property: stringValue },
                anotherClass: @{ property: class },
            });

            expect(theme).to.beAnInstanceOf(MTFTheme.class);
            expect(error).to.beNil();

            MTFThemeClass *themeClass = theme.classes[class.mtf_symbol];
            expect(themeClass).to.beAnInstanceOf(MTFThemeClass.class);
            expect(themeClass.name).to.equal(class.mtf_symbol);
            expect(themeClass.properties.allKeys).to.haveACountOf(1);
            expect(themeClass.properties[property]).to.equal(stringValue);

            MTFThemeClass *anotherThemeClass = theme.classes[anotherClass.mtf_symbol];
            expect(anotherThemeClass).to.beAnInstanceOf(MTFThemeClass.class);
            expect(anotherThemeClass.name).to.equal(anotherClass.mtf_symbol);
            expect(anotherThemeClass.properties.allKeys).to.haveACountOf(1);
            expect(anotherThemeClass.properties[property]).to.beIdenticalTo(themeClass);
        });

        it(@"should fail when a property references an unrecognized class", ^{
            theme = themeFromDictionary(@{
                class: @{ property: anotherClass },
            });

            expect(theme).to.beNil();
            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFErrorDomain);
            expect(error.code).to.equal(MTFErrorFailedToParseTheme);
        });
    });

    describe(@"multiple dictionaries", ^{
        describe(@"constants", ^{
            it(@"should fail when named identically to a constant from an earlier dictionary", ^{
                theme = themeFromDictionaries(@[
                    @{ constant: stringValue },
                    @{ constant: stringValue },
                ]);

                expect(theme).to.beNil();
                expect(error).notTo.beNil();
                expect(error.domain).to.equal(MTFErrorDomain);
                expect(error.code).to.equal(MTFErrorFailedToParseTheme);
            });

            it(@"should succeed with referencing another constant from an earlier dictionary", ^{
                theme = themeFromDictionaries(@[
                    @{ constant: stringValue },
                    @{ anotherConstant: constant },
                ]);

                expect(theme).to.beAnInstanceOf(MTFTheme.class);
                expect(error).to.beNil();

                MTFThemeConstant *themeConstant = theme.constants[constant.mtf_symbol];
                expect(themeConstant).to.beAnInstanceOf(MTFThemeConstant.class);
                expect(themeConstant.name).to.equal(constant.mtf_symbol);
                expect(themeConstant.value).to.equal(stringValue);

                MTFThemeConstant *anotherThemeConstant = theme.constants[anotherConstant.mtf_symbol];
                expect(anotherThemeConstant).to.beAnInstanceOf(MTFThemeConstant.class);
                expect(anotherThemeConstant.name).to.equal(anotherConstant.mtf_symbol);
                expect(anotherThemeConstant.value).to.equal(stringValue);
            });

            it(@"should succeed when referencing a class from an earlier dictionary", ^{
                theme = themeFromDictionaries(@[
                    @{ class: @{ property: stringValue } },
                    @{ constant: class },
                ]);

                expect(theme).to.beAnInstanceOf(MTFTheme.class);
                expect(error).to.beNil();

                MTFThemeConstant *themeConstant = theme.constants[constant.mtf_symbol];
                expect(themeConstant).to.beAnInstanceOf(MTFThemeConstant.class);
                expect(themeConstant.name).to.equal(constant.mtf_symbol);

                MTFThemeClass *themeClass = themeConstant.value;
                expect(themeClass).to.beAnInstanceOf(MTFThemeClass.class);
                expect(themeClass.properties.allKeys).to.haveACountOf(1);
                expect(themeClass.properties[property]).to.equal(stringValue);
            });
        });

        describe(@"classes", ^{
            it(@"should fail when named identically to a class from an earlier dictionary", ^{
                theme = themeFromDictionaries(@[
                    @{ class: @{ property: stringValue } },
                    @{ class: @{ property: stringValue } },
                ]);

                expect(theme).to.beNil();
                expect(error).notTo.beNil();
                expect(error.domain).to.equal(MTFErrorDomain);
                expect(error.code).to.equal(MTFErrorFailedToParseTheme);
            });

            it(@"should succeed when a property references a constant from an earlier dictionary", ^{
                theme = themeFromDictionaries(@[
                    @{ constant: stringValue },
                    @{ class: @{ property: constant } },
                ]);

                expect(theme).to.beAnInstanceOf(MTFTheme.class);
                expect(error).to.beNil();

                MTFThemeClass *themeClass = theme.classes[class.mtf_symbol];
                expect(themeClass).to.beAnInstanceOf(MTFThemeClass.class);
                expect(themeClass.name).to.equal(class.mtf_symbol);
                expect(themeClass.properties.allKeys).to.haveACountOf(1);
                expect(themeClass.properties[property]).to.equal(stringValue);
            });

            it(@"should succeed when a property references a class from an earlier dictionary", ^{
                theme = themeFromDictionaries(@[
                    @{ class: @{ property: stringValue } },
                    @{ anotherClass: @{ property: class } },
                ]);

                expect(theme).to.beAnInstanceOf(MTFTheme.class);
                expect(error).to.beNil();

                MTFThemeClass *themeClass = theme.classes[class.mtf_symbol];
                expect(themeClass).to.beAnInstanceOf(MTFThemeClass.class);
                expect(themeClass.name).to.equal(class.mtf_symbol);
                expect(themeClass.properties.allKeys).to.haveACountOf(1);
                expect(themeClass.properties[property]).to.equal(stringValue);

                MTFThemeClass *anotherThemeClass = theme.classes[anotherClass.mtf_symbol];
                expect(anotherThemeClass).to.beAnInstanceOf(MTFThemeClass.class);
                expect(anotherThemeClass.name).to.equal(anotherClass.mtf_symbol);
                expect(anotherThemeClass.properties.allKeys).to.haveACountOf(1);
                expect(anotherThemeClass.properties[property]).to.beIdenticalTo(themeClass);
            });
        });
    });

    describe(@"class inheritance", ^{
        NSString *superclass = @".Superclass";
        NSString *subclass = @".Subclass";

        it(@"should succeed when inheriting a property from a superclass", ^{
            theme = themeFromDictionary(@{
                superclass: @{ property: stringValue },
                subclass: @{ MTFThemeSuperclassKey: superclass },
            });

            expect(theme).to.beAnInstanceOf(MTFTheme.class);
            expect(error).to.beNil();

            MTFThemeClass *superclassThemeClass = [theme classForName:superclass.mtf_symbol];
            expect(superclassThemeClass).to.beAnInstanceOf(MTFThemeClass.class);
            expect(superclassThemeClass.properties[property]).to.equal(stringValue);

            MTFThemeClass *subclassThemeClass = [theme classForName:superclass.mtf_symbol];
            expect(subclassThemeClass).to.beAnInstanceOf(MTFThemeClass.class);
            expect(subclassThemeClass.properties[property]).to.equal(stringValue);
        });

        it(@"should succeed when inheriting a property from a superclass in an earlier dictionary", ^{
            theme = themeFromDictionaries(@[
                @{ superclass: @{ property: stringValue } },
                @{ subclass: @{ MTFThemeSuperclassKey: superclass } },
            ]);

            expect(theme).to.beAnInstanceOf(MTFTheme.class);
            expect(error).to.beNil();

            MTFThemeClass *superclassThemeClass = [theme classForName:superclass.mtf_symbol];
            expect(superclassThemeClass).to.beAnInstanceOf(MTFThemeClass.class);
            expect(superclassThemeClass.properties[property]).to.equal(stringValue);

            MTFThemeClass *subclassThemeClass = [theme classForName:superclass.mtf_symbol];
            expect(subclassThemeClass).to.beAnInstanceOf(MTFThemeClass.class);
            expect(subclassThemeClass.properties[property]).to.equal(stringValue);
        });

        it(@"should fail when inheriting from a constant", ^{
            theme = themeFromDictionaries(@[
                @{ constant: stringValue },
                @{ subclass: @{ MTFThemeSuperclassKey: constant } },
            ]);

            expect(theme).to.beNil();
            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFErrorDomain);
            expect(error.code).to.equal(MTFErrorFailedToParseTheme);
        });

        it(@"should fail when inheriting from an unrecognized class", ^{
            theme = themeFromDictionaries(@[
                @{ subclass: @{ MTFThemeSuperclassKey: superclass } },
            ]);

            expect(theme).to.beNil();
            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFErrorDomain);
            expect(error.code).to.equal(MTFErrorFailedToParseTheme);
        });

        it(@"should fail when inheriting from an invalid symbol", ^{
            theme = themeFromDictionaries(@[
                @{ constant: stringValue },
                @{ subclass: @{ MTFThemeSuperclassKey: @"InvalidSymbol" } },
            ]);

            expect(theme).to.beNil();
            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFErrorDomain);
            expect(error.code).to.equal(MTFErrorFailedToParseTheme);
        });

        it(@"should fail when inheriting from itself", ^{
            theme = themeFromDictionaries(@[
                @{ subclass: @{ MTFThemeSuperclassKey: subclass } },
            ]);

            expect(theme).to.beNil();
            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFErrorDomain);
            expect(error.code).to.equal(MTFErrorFailedToParseTheme);
        });

        it(@"should fail when transitively inheriting from itself", ^{
            theme = themeFromDictionaries(@[
                @{ class: @{ MTFThemeSuperclassKey: subclass } },
                @{ superclass: @{ MTFThemeSuperclassKey: class } },
                @{ subclass: @{ MTFThemeSuperclassKey: superclass } },
            ]);

            expect(theme).to.beNil();
            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFErrorDomain);
            expect(error.code).to.equal(MTFErrorFailedToParseTheme);
        });
    });
});

describe(@"-constantValueForName:", ^{
    it(@"should return a constant value for the specified name", ^{
        MTFTheme *theme = [[MTFTheme alloc] initWithThemeDictionary:@{
            @"$Constant": @"value",
        } error:&error];

        expect(theme).to.beAnInstanceOf(MTFTheme.class);
        expect(error).to.beNil();
        expect([theme constantValueForName:@"Constant"]).to.equal(@"value");
    });

    it(@"should return a nil value for an unknown constant", ^{
        MTFTheme *theme = [[MTFTheme alloc] initWithThemeDictionary:@{} error:&error];

        expect(theme).to.beAnInstanceOf(MTFTheme.class);
        expect(error).to.beNil();
        expect([theme constantValueForName:@"Constant"]).to.beNil();
    });
});

describe(@"-applyClassWithName:to:error:", ^{
    

    it(@"should fail when no class is found", ^{
        id applicant = [[NSObject alloc] init];

        MTFTheme *theme = [[MTFTheme alloc] initWithThemeDictionary:@{} error:&error];

        success = [theme applyClassWithName:@"Cass" to:applicant error:&error];

        expect(success).to.beFalsy();
        expect(error).notTo.beNil();
        expect(error.domain).to.equal(MTFErrorDomain);
        expect(error.code).to.equal(MTFErrorFailedToApplyTheme);
    });
});

SpecEnd
