//
//  MTFTheme+SymbolsGenerationObjC.m
//  MTFThemingSymbolsGenerator
//
//  Created by Eric Horacek on 12/28/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <GBCli/GBCli.h>
#import <Motif/MTFTheme_Private.h>

#import "MTFTheme+Symbols.h"
#import "MTFTheme+WarningComment.h"
#import "NSOutputStream+StringWriting.h"
#import "NSOutputStream+TemporaryOutput.h"

#import "MTFTheme+SymbolsGenerationObjC.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FileType) {
    FileTypeHeader,
    FileTypeImplementation
};

@implementation MTFTheme (SymbolsGenerationOBjc)

#pragma mark - Public

- (BOOL)generateObjCSymbolsFilesInDirectory:(NSURL *)directoryURL indentation:(NSString *)indentation prefix:(NSString *)prefix error:(NSError **)error {
    NSParameterAssert(directoryURL);
    NSParameterAssert(indentation);
    NSParameterAssert(prefix);
    
    BOOL success = [self
        generateSymbolsFileOfType:FileTypeHeader
        intoDirectoryWithURL:directoryURL
        indentation:indentation
        prefix:prefix
        error:error];

    if (!success) return NO;

    return [self
        generateSymbolsFileOfType:FileTypeImplementation
        intoDirectoryWithURL:directoryURL
        indentation:indentation
        prefix:prefix
        error:error];
}

+ (BOOL)generateObjCSymbolsUmbrellaHeaderFromThemes:(NSArray *)themes inDirectory:(NSURL *)directoryURL prefix:(NSString *)prefix error:(NSError **)error {
    NSParameterAssert(themes);
    NSAssert(themes.count > 0, @"Must supply at least one theme");
    NSParameterAssert(directoryURL);
    NSParameterAssert(prefix);
    
    // Create an opened stream from the file at the specified directory
    NSString *outputFilename = [self umbrellaHeaderFilenameWithPrefix:prefix];
    NSURL *destinationURL = [directoryURL URLByAppendingPathComponent:outputFilename];

    NSOutputStream *outputStream = [NSOutputStream temporaryOutputStreamWithDestinationURL:destinationURL error:error];
    if (outputStream == nil) return NO;

    [outputStream open];
    
    // Write a warning comment at the top of the file
    [outputStream mtf_writeString:[self.class warningComment]];
    
    // Add an import for each of the themes
    for (MTFTheme *theme in themes) {
        NSString *import = [theme symbolsHeaderImportWithPrefix:prefix];
        [outputStream mtf_writeString:[import stringByAppendingString:@"\n"]];
    }
    
    [outputStream close];
    if (![outputStream copyToDestinationIfNecessaryWithError:error]) {
        return NO;
    }
    
    gbprintln(@"Generated: %@", outputFilename);

    return YES;
}

#pragma mark - Private

- (BOOL)generateSymbolsFileOfType:(FileType)fileType intoDirectoryWithURL:(NSURL *)directoryURL indentation:(NSString *)indentation prefix:(NSString *)prefix error:(NSError **)error {
    NSParameterAssert(directoryURL);
    NSParameterAssert(indentation);
    NSParameterAssert(prefix);

    // Open a stream from the symbols file at the specified directory
    NSString *outputFilename = [self
        symbolsFilenameForFileType:fileType
        prefix:prefix];
    
    NSURL *destinationURL = [directoryURL URLByAppendingPathComponent:outputFilename];
    NSOutputStream *outputStream = [NSOutputStream temporaryOutputStreamWithDestinationURL:destinationURL error:error];
    if (outputStream == nil) return NO;

    [outputStream open];
    
    // Write a warning comment at the top of the file
    [outputStream mtf_writeString:self.warningComment];
    
    // Add the necessary import
    NSString *import = [self symbolsImportForFileType:fileType prefix:prefix];
    
    [outputStream
        mtf_writeString:[NSString stringWithFormat: @"\n%@\n", import]];
    
    // Add the theme name constant
    NSString *nameConstant = [self symbolsThemeNameStringConstForFiletype:fileType prefix:prefix];
    
    [outputStream
        mtf_writeString:[NSString stringWithFormat:@"\n%@\n", nameConstant]];
    
    // Write all types of symbols from the theme
    for (MTFSymbolType symbolType = 0; symbolType < MTFSymbolTypeCount; symbolType++) {
        NSString *symbolsDeclartion = [self
            symbolsDeclartionOfType:symbolType
            withFiletype:fileType
            indentation:indentation
            prefix:prefix];
        
        if (symbolsDeclartion) {
            NSString *symbolsDeclarationOutput = [NSString stringWithFormat:
                @"\n%@\n",
                symbolsDeclartion];
            [outputStream mtf_writeString:symbolsDeclarationOutput];
        }
    }

    [outputStream close];
    if (![outputStream copyToDestinationIfNecessaryWithError:error]) return NO;
    
    gbprintln(@"Generated: %@", outputFilename);

    return YES;
}

- (NSString *)symbolsFilenameForFileType:(FileType)filetype prefix:(NSString *)prefix {
    NSParameterAssert(prefix != nil);
    
    NSString *extension = [self extensionForFiletype:filetype];

    return [NSString stringWithFormat:
        @"%@%@Symbols.%@",
        prefix,
        self.symbolsName,
        extension];
}

+ (NSString *)umbrellaHeaderFilenameWithPrefix:(NSString *)prefix {
    NSParameterAssert(prefix);
    
    return [NSString stringWithFormat:@"%@ThemeSymbols.h", prefix];
}

- (NSString *)extensionForFiletype:(FileType)fileType {
    switch (fileType) {
    case FileTypeHeader:
        return @"h";
    case FileTypeImplementation:
        return @"m";
    }
    return nil;
}

- (NSString *)symbolsImportForFileType:(FileType)fileType prefix:(NSString *)prefix {
    NSParameterAssert(prefix);
    
    switch (fileType) {
    case FileTypeHeader:
        return @"#import <Foundation/Foundation.h>";
    case FileTypeImplementation:
        return [self symbolsHeaderImportWithPrefix:prefix];
    }
    return nil;
}

- (NSString *)symbolsHeaderImportWithPrefix:(NSString *)prefix {
    NSParameterAssert(prefix);
    
    NSString *importFileName = [self
        symbolsFilenameForFileType:FileTypeHeader
        prefix:prefix];
    
    return [NSString stringWithFormat:@"#import \"%@\"", importFileName];
}

- (nullable NSString *)symbolsThemeNameStringConstForFiletype:(FileType)fileType prefix:(NSString *)prefix {
    NSParameterAssert(prefix);
    
    NSString *constantName = [NSString stringWithFormat:
        @"%@%@Name",
        prefix,
        self.symbolsName];

    switch (fileType) {
    case FileTypeHeader:
        return [NSString stringWithFormat:
            @"extern NSString * const %@;",
            constantName];
    case FileTypeImplementation:
        return [NSString stringWithFormat:
            @"NSString * const %@ = @\"%@\";",
            constantName,
            self.symbolsName];
    }
    return nil;
}

- (nullable NSString *)symbolsDeclartionOfType:(MTFSymbolType)symbolType withFiletype:(FileType)fileType indentation:(NSString *)indentation prefix:(NSString *)prefix {
    NSParameterAssert(indentation);
    NSParameterAssert(prefix);
    
    NSArray *symbols = [self symbolsForType:symbolType];
    if (symbols == nil || symbols.count == 0) return nil;

    NSMutableArray *lines = [NSMutableArray new];
 
    NSString *enumName = [self enumNameForSymbolType:symbolType prefix:prefix];
    NSString *openingDeclaration = [self openingDeclarationForFiletype:fileType enumName:enumName];
    [lines addObject:openingDeclaration];
    
    for (NSString *symbol in symbols) {
        NSString *memberDeclaration = [self
            memberDeclarationForSymbol:symbol
            fileType:fileType
            indentation:indentation];

        [lines addObject:memberDeclaration];
    }

    NSString *closingDeclaration = [self closingDeclarationForFiletype:fileType enumName:enumName];
    [lines addObject:closingDeclaration];
    
    return [lines componentsJoinedByString:@"\n"];
}

- (nullable NSString *)openingDeclarationForFiletype:(FileType)filetype enumName:(NSString *)enumName {
    NSParameterAssert(enumName);
    
    switch (filetype) {
    case FileTypeHeader:
        return [NSString stringWithFormat:
            @"extern const struct %@ {",
            enumName];
    case FileTypeImplementation:
        return [NSString stringWithFormat:
            @"const struct %@ %@ = {",
            enumName,
            enumName];
    }
    return nil;
}

- (nullable NSString *)memberDeclarationForSymbol:(NSString *)symbol fileType:(FileType)filetype indentation:(NSString *)indentation {
    NSParameterAssert(symbol);
    NSParameterAssert(indentation);
    
    switch (filetype) {
    case FileTypeHeader:
        return [NSString stringWithFormat:
            @"%@__unsafe_unretained NSString *%@;",
            indentation,
            symbol];
    case FileTypeImplementation:
        return [NSString stringWithFormat:
            @"%@.%@ = @\"%@\",",
            indentation,
            symbol,
            symbol];
    }
    return nil;
}

- (nullable NSString *)closingDeclarationForFiletype:(FileType)filetype enumName:(NSString *)enumName {
    NSParameterAssert(enumName);
    
    switch (filetype) {
    case FileTypeHeader:
        return [NSString stringWithFormat:@"} %@;", enumName];
    case FileTypeImplementation:
        return @"};";
    }
    return nil;
}

- (nullable NSString *)enumNameForSymbolType:(MTFSymbolType)symbolType prefix:(NSString *)prefix {
    NSParameterAssert(prefix);
    
    NSString *enumName = [NSString stringWithFormat:@"%@%@", prefix, self.symbolsName];
    switch (symbolType) {
    case MTFSymbolTypeClassNames:
        return [enumName stringByAppendingString:@"ClassNames"];
    case MTFSymbolTypeConstantNames:
        return [enumName stringByAppendingString:@"ConstantNames"];
    case MTFSymbolTypeProperties:
        return [enumName stringByAppendingString:@"Properties"];
    default:
        return nil;
    }
}

@end

NS_ASSUME_NONNULL_END
