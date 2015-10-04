//
//  MTFTheme+SymbolsGenerationSwift.m
//  MotifCLI
//
//  Created by Eric Horacek on 8/17/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <GBCli/GBCli.h>
#import <Motif/MTFTheme_Private.h>

#import "MTFTheme+Symbols.h"
#import "MTFTheme+WarningComment.h"
#import "NSOutputStream+StringWriting.h"
#import "NSOutputStream+TemporaryOutput.h"

#import "MTFTheme+SymbolsGenerationSwift.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MTFTheme (SymbolsGenerationSwift)

- (void)generateSwiftSymbolsFileInDirectory:(NSURL *)directoryURL indentation:(NSString *)indentation {
    NSParameterAssert(directoryURL != nil);
    NSParameterAssert(indentation != nil);

    NSString *outputFilename = [self symbolsFilename];

    NSURL *destinationURL = [directoryURL URLByAppendingPathComponent:outputFilename];
    NSOutputStream *outputStream = [NSOutputStream temporaryOutputStreamWithDestinationURL:destinationURL];
    [outputStream open];

    // Write a warning comment at the top of the file
    [outputStream mtf_writeString:self.warningComment];

    // Write a warning comment at the top of the file
    NSString *nameConstant = [self symbolsThemeNameConstantDeclaration];
    [outputStream mtf_writeString:[NSString stringWithFormat:@"\n%@\n", nameConstant]];

    // Write all types of symbols from the theme
    for (MTFSymbolType symbolType = 0; symbolType < MTFSymbolTypeCount; symbolType++) {
        NSString *symbolsDeclartion = [self symbolsDeclartionOfType:symbolType withIndentation:indentation];
        
        if (symbolsDeclartion != nil) {
            NSString *symbolsDeclarationOutput = [NSString stringWithFormat:@"\n%@\n", symbolsDeclartion];
            [outputStream mtf_writeString:symbolsDeclarationOutput];
        }
    }

    [outputStream close];
    [outputStream copyToDestinationIfNecessary];

    gbprintln(@"Generated: %@", outputFilename);
}

- (NSString *)symbolsFilename {
    return [NSString stringWithFormat:@"%@Symbols.swift", self.symbolsName];
}

- (NSString *)symbolsThemeNameConstantDeclaration {
    NSString *name = self.symbolsName;
    NSString *constantName = [NSString stringWithFormat:@"%@Name", name];
    
    return [NSString stringWithFormat:@"let %@ = \"%@\"", constantName, name];
}

- (nullable NSString *)symbolsDeclartionOfType:(MTFSymbolType)symbolType withIndentation:(NSString *)indentation {
    NSParameterAssert(indentation != nil);

    NSArray *symbols = [self symbolsForType:symbolType];
    if (symbols == nil || symbols.count == 0) return nil;

    NSMutableArray *lines = [NSMutableArray new];

    NSString *openingDeclaration = [self openingDeclarationForSymbolType:symbolType];
    [lines addObject:openingDeclaration];
    
    for (NSString *symbol in symbols) {
        NSString *memberDeclaration = [self memberDeclarationForSymbol:symbol indentation:indentation];
        [lines addObject:memberDeclaration];
    }

    NSString *closingDeclaration = [self closingDeclaration];
    [lines addObject:closingDeclaration];
    
    return [lines componentsJoinedByString:@"\n"];
}

- (nullable NSString *)openingDeclarationForSymbolType:(MTFSymbolType)symbolType {
    NSString *enumName = [self enumNameForSymbolType:symbolType];

    return [NSString stringWithFormat:@"enum %@: String {", enumName];
}

- (nullable NSString *)memberDeclarationForSymbol:(NSString *)symbol indentation:(NSString *)indentation {
    NSParameterAssert(symbol != nil);
    NSParameterAssert(indentation != nil);

    return [NSString stringWithFormat:@"%@case %@", indentation, symbol];
}

- (NSString *)closingDeclaration {
    return @"}";
}

- (nullable NSString *)enumNameForSymbolType:(MTFSymbolType)symbolType {
    NSString *enumName = [NSString stringWithFormat:@"%@", self.symbolsName];
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
