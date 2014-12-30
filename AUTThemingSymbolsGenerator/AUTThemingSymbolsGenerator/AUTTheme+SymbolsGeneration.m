//
//  AUTTheme+SymbolsGeneration.m
//  AUTThemingSymbolsGenerator
//
//  Created by Eric Horacek on 12/28/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <GBCli/GBCli.h>
#import <AUTTheming/AUTTheming.h>
#import <AUTTheming/AUTTheme+Private.h>
#import "AUTTheme+SymbolsGeneration.h"

typedef NS_ENUM(NSInteger, FileType) {
    FileTypeHeader,
    FileTypeImplementation
};

typedef NS_ENUM(NSInteger, SymbolType) {
    SymbolTypeConstantKeys,
    SymbolTypeClassNames,
    SymbolTypeProperties,
    SymbolTypeCount
};

@implementation AUTTheme (SymbolsGeneration)

- (void)generateSymbolsFilesInDirectory:(NSURL *)directoryURL indentation:(NSString *)indentation prefix:(NSString *)prefix;
{
    NSParameterAssert(directoryURL);
    NSParameterAssert(indentation);
    NSParameterAssert(prefix);
    
    [self generateSymbolsFileOfType:FileTypeHeader toDirectoryWithURL:directoryURL indentation:indentation prefix:prefix];
    [self generateSymbolsFileOfType:FileTypeImplementation toDirectoryWithURL:directoryURL indentation:indentation prefix:prefix];
}

static NSString * const WarningFormat = @"\
// WARNING: Do not modify. This file is machine-generated from '%@'.\n\
// To update these symbols, run the command:\n\
// $ %@\n\
\n\
";

- (void)generateSymbolsFileOfType:(FileType)fileType toDirectoryWithURL:(NSURL *)directoryURL indentation:(NSString *)indentation prefix:(NSString *)prefix
{
    NSParameterAssert(directoryURL);
    NSParameterAssert(indentation);
    NSParameterAssert(prefix);
    
    // Open a stream from the file at the specified directory
    NSString *filename = [self outputFilenameForFileType:fileType prefix:prefix];
    NSURL *fileURL = [directoryURL URLByAppendingPathComponent:filename];
    NSOutputStream *stream = [NSOutputStream outputStreamWithURL:fileURL append:NO];
    [stream open];
    
    NSString *warningString = [NSString stringWithFormat:WarningFormat, [self JSONFileName], [self commandToGenerateSymbols]];
    NSData *warningData = [warningString dataUsingEncoding:NSUTF8StringEncoding];
    [stream write:warningData.bytes maxLength:warningData.length];
    
    NSString *importString = [self importForFileType:fileType prefix:prefix];
    importString = [importString stringByAppendingString:@"\n\n"];
    NSData *importStringData = [importString dataUsingEncoding:NSUTF8StringEncoding];
    [stream write:importStringData.bytes maxLength:importStringData.length];
    
    for (SymbolType symbolType = 0; symbolType < SymbolTypeCount; symbolType++) {
        
        NSString *symbolsDeclartion = [self symbolsDeclartionOfType:symbolType withFiletype:fileType indentation:indentation prefix:prefix];
        NSData *data = [symbolsDeclartion dataUsingEncoding:NSUTF8StringEncoding];
        [stream write:data.bytes maxLength:data.length];
        
        NSData *trailingWhitespaceData = [[self trailingWhitespaceForSymbolType:symbolType] dataUsingEncoding:NSUTF8StringEncoding];
        [stream write:trailingWhitespaceData.bytes maxLength:trailingWhitespaceData.length];
    }
    
    [stream close];
    
    gbprintln(@"Generated: %@", filename);
}

- (NSString *)commandToGenerateSymbols
{
    NSString *procesName = [NSProcessInfo processInfo].processName;
    NSArray *arguments = [NSProcessInfo processInfo].arguments;
    NSArray *argumentsMinusProcessName = [arguments subarrayWithRange:(NSRange){.location = 1, .length = (arguments.count - 1)}];
    NSString *argumentsAtString = [argumentsMinusProcessName componentsJoinedByString:@" "];
    NSString *command = [procesName stringByAppendingString:[NSString stringWithFormat:@" %@", argumentsAtString]];
    return command;
}

- (NSString *)JSONFileName
{
    return [NSString stringWithFormat:@"%@.json", self.names.firstObject];
}

- (NSString *)outputFilenameForFileType:(FileType)filetype prefix:(NSString *)prefix
{
    NSParameterAssert(prefix);
    
    NSString *themeName = self.themeName;
    NSString *extension = [self extensionForFiletype:filetype];
    return [NSString stringWithFormat:@"%@%@Symbols.%@", prefix, themeName, extension];
}

- (NSString *)extensionForFiletype:(FileType)fileType
{
    switch (fileType) {
    case FileTypeHeader:
        return @"h";
    case FileTypeImplementation:
        return @"m";
    }
    return nil;
}

- (NSString *)importForFileType:(FileType)fileType prefix:(NSString *)prefix
{
    switch (fileType) {
    case FileTypeHeader:
        return @"#import <Foundation/Foundation.h>";
    case FileTypeImplementation:
        return [NSString stringWithFormat:@"#import \"%@\"", [self outputFilenameForFileType:FileTypeHeader prefix:prefix]];
    }
    return nil;
}

- (NSString *)symbolsDeclartionOfType:(SymbolType)symbolType withFiletype:(FileType)fileType indentation:(NSString *)indendatiaon prefix:(NSString *)prefix
{
    NSParameterAssert(indendatiaon);
    NSParameterAssert(prefix);
    
    NSMutableArray *lines = [NSMutableArray new];
 
    NSString *enumName = [self enumNameForSymbolType:symbolType prefix:prefix];
    
    [lines addObject:[self openingDeclarationForFiletype:fileType enumName:enumName]];
    for (NSString *symbol in [self symbolsForType:symbolType]) {
        [lines addObject:[self memberDeclarationForSymbol:symbol fileType:fileType indentation:indendatiaon]];
    }
    [lines addObject:[self closingDeclarationForFiletype:fileType enumName:enumName]];
    
    return [lines componentsJoinedByString:@"\n"];
}

- (NSString *)openingDeclarationForFiletype:(FileType)filetype enumName:(NSString *)enumName
{
    NSParameterAssert(enumName);
    
    switch (filetype) {
    case FileTypeHeader:
        return [NSString stringWithFormat:@"extern const struct %@ {", enumName];
    case FileTypeImplementation:
        return [NSString stringWithFormat:@"const struct %@ %@ = {", enumName, enumName];
    }
    return nil;
}

- (NSString *)memberDeclarationForSymbol:(NSString *)symbol fileType:(FileType)filetype indentation:(NSString *)indentation
{
    NSParameterAssert(symbol);
    NSParameterAssert(indentation);
    
    switch (filetype) {
    case FileTypeHeader:
        return [NSString stringWithFormat:@"%@__unsafe_unretained NSString *%@;", indentation, symbol];
    case FileTypeImplementation:
        return [NSString stringWithFormat:@"%@.%@ = @\"%@\",", indentation, symbol, symbol];
    }
    return nil;
}

- (NSString *)closingDeclarationForFiletype:(FileType)filetype enumName:(NSString *)enumName
{
    NSParameterAssert(enumName);
    
    switch (filetype) {
        case FileTypeHeader:
            return [NSString stringWithFormat:@"} %@;", enumName];
        case FileTypeImplementation:
            return @"};";
    }
    return nil;
}

- (NSString *)themeName
{
    return self.names.firstObject;
}

- (NSString *)trailingWhitespaceForSymbolType:(SymbolType)symbolType
{
    return (((symbolType + 1) == SymbolTypeCount) ? @"\n" : @"\n\n");
}

- (NSString *)enumNameForSymbolType:(SymbolType)symbolType prefix:(NSString *)prefix
{
    NSParameterAssert(prefix);
    
    NSString *themeName = [self themeName];
    NSString *enumName = [NSString stringWithFormat:@"%@%@", prefix, themeName];
    switch (symbolType) {
    case SymbolTypeClassNames:
        return [enumName stringByAppendingString:@"ClassNames"];
    case SymbolTypeConstantKeys:
        return [enumName stringByAppendingString:@"ConstantKeys"];
    case SymbolTypeProperties:
        return [enumName stringByAppendingString:@"Properties"];
    default:
        return nil;
    }
}

- (NSArray *)symbolsForType:(SymbolType)symbolType
{
    switch (symbolType) {
    case SymbolTypeClassNames:
        return [self classNames];
    case SymbolTypeConstantKeys:
        return [self constantKeys];
    case SymbolTypeProperties:
        return [self properties];
    default:
        return nil;
    }
}

- (NSArray *)constantKeys
{
    return self.mappedConstants.allKeys;
}

- (NSArray *)classNames
{
    return self.mappedClasses.allKeys;
}

- (NSArray *)properties
{
    NSMutableSet *properties = [NSMutableSet new];
    for (AUTThemeClass *class in self.mappedClasses.allValues) {
        [properties addObjectsFromArray:class.properties.allKeys];
    }
    return properties.allObjects;
}

@end
