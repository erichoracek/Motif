//
//  NSURL+ThemeFilesSpec.m
//  Motif
//
//  Created by Eric Horacek on 5/31/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <Motif/Motif.h>
#import <Motif/NSURL+ThemeFiles.h>

SpecBegin(NSURL_ThemeFiles)

__block NSError *error;

beforeEach(^{
    error = nil;
});

describe(@"name", ^{
    it(@"should accept json files with the json extension", ^{
        NSString *name = @"Name";
        NSString *URLString = [NSString stringWithFormat:@"file:///%@.json", name];
        NSURL *themeName = [NSURL URLWithString:URLString];
        expect(themeName.mtf_themeName).to.equal(name);
    });

    it(@"should accept yaml files with the yaml extension", ^{
        NSString *name = @"Name";
        NSString *URLString = [NSString stringWithFormat:@"file:///%@.yaml", name];
        NSURL *themeName = [NSURL URLWithString:URLString];
        expect(themeName.mtf_themeName).to.equal(name);
    });

    it(@"should accept yaml files with the yml extension", ^{
        NSString *name = @"Name";
        NSString *URLString = [NSString stringWithFormat:@"file:///%@.yml", name];
        NSURL *themeName = [NSURL URLWithString:URLString];
        expect(themeName.mtf_themeName).to.equal(name);
    });

    it(@"should trim 'Theme' from the end of filenames", ^{
        NSString *name = @"Name";
        NSString *URLString = [NSString stringWithFormat:@"file:///%@Theme.yml", name];
        NSURL *themeName = [NSURL URLWithString:URLString];
        expect(themeName.mtf_themeName).to.equal(name);
    });

    it(@"should not trim 'Theme' when it is the entire filename", ^{
        NSString *name = @"Theme";
        NSString *URLString = [NSString stringWithFormat:@"file:///%@.yml", name];
        NSURL *themeName = [NSURL URLWithString:URLString];
        expect(themeName.mtf_themeName).to.equal(name);
    });
});

describe(@"URLs from theme names", ^{
    __block NSBundle *bundle;

    beforeEach(^{
        bundle = [NSBundle bundleForClass:self.class];
    });

    it(@"should default to the main bundle when none is specified", ^{
        NSArray *URLs = [NSURL mtf_fileURLsFromThemeNames:@[] inBundle:nil error:&error];

        expect(URLs).notTo.beNil();
        expect(URLs).to.beEmpty();
    });

    it(@"should locate a bundled theme file", ^{
        NSArray *URLs = [NSURL mtf_fileURLsFromThemeNames:@[ @"Bundled" ] inBundle:bundle error:&error];

        expect(URLs).notTo.beNil();
        expect(URLs).to.haveACountOf(1);
    });

    it(@"should error when trying to locate a nonexistent theme", ^{
        NSArray *URLs = [NSURL mtf_fileURLsFromThemeNames:@[ @"Unknown" ] inBundle:bundle error:&error];

        expect(URLs).to.beNil();
        expect(error).notTo.beNil();
        expect(error.domain).to.equal(MTFErrorDomain);
        expect(error.code).to.equal(MTFErrorFailedToParseTheme);
    });
});


describe(@"dictionaries from theme URLs", ^{
    describe(@"with valid contents", ^{
        __block NSBundle *bundle;
        __block NSURL *URL;

        beforeEach(^{
            URL = nil;
            bundle = [NSBundle bundleForClass:self.class];
        });

        afterEach(^{
            NSError *error;
            NSDictionary *contents = [URL mtf_themeDictionaryWithError:&error];

            expect(error).to.beNil;
            expect(contents).to.beKindOf(NSDictionary.class);
            expect(contents).to.haveACountOf(2);
        });

        it(@"should load a theme dictionary from a URL with a yaml extension", ^{
            URL = [bundle URLForResource:@"BasicTheme" withExtension:@"yaml"];
        });

        it(@"should load a theme dictionary from a URL with a yml extension", ^{
            URL = [bundle URLForResource:@"BasicTheme" withExtension:@"yml"];
        });

        it(@"should load a theme dictionary from a URL with a json extension", ^{
            URL = [bundle URLForResource:@"BasicTheme" withExtension:@"json"];
        });
    });

    describe(@"with invalid contents", ^{
        __block NSURL *URL;

        beforeEach(^{
            URL = nil;
        });

        afterEach(^{
            NSError *error;
            NSDictionary *contents = [URL mtf_themeDictionaryWithError:&error];
            expect(contents).to.beNil();

            expect(error).notTo.beNil();
            expect(error.domain).to.equal(MTFErrorDomain);
            expect(error.code).to.equal(MTFErrorFailedToParseTheme);
        });

        it(@"should produce an error with non-file URL", ^{
            URL = [NSURL URLWithString:@"https://www.google.com"];
        });

        it(@"should produce an error with non-file URL", ^{
            URL = [NSURL URLWithString:@"file:///not/a/valid/theme/path"];
        });

        it(@"should produce an error with no extension", ^{
            NSBundle *bundle = [NSBundle bundleForClass:self.class];
            URL = [bundle URLForResource:@"NoExtensionTheme" withExtension:nil];
        });

        it(@"should produce an error with no contents", ^{
            NSBundle *bundle = [NSBundle bundleForClass:self.class];
            URL = [bundle URLForResource:@"EmptyTheme" withExtension:@"yaml"];
        });
    });
});

SpecEnd
