//
//  NSString+ThemeSymbols.m
//  Motif
//
//  Created by Eric Horacek on 3/3/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "NSString+ThemeSymbols.h"

NSString * const MTFClassPrefixSymbol = @".";

NSString * const MTFConstantPrefixSymbol = @"$";

NSString * const MTFThemeSuperclassKey = @"_superclass";

@implementation NSString (ThemeSymbols)

- (BOOL)mtf_isRawSymbolReference {
    return (
        self.mtf_isRawSymbolClassReference ||
        self.mtf_isRawSymbolConstantReference);
}

- (BOOL)mtf_isRawSymbolConstantReference {
    return (
        [self hasPrefix:MTFConstantPrefixSymbol] &&
        (self.length > MTFConstantPrefixSymbol.length));
}

- (BOOL)mtf_isRawSymbolClassReference {
    return (
        [self hasPrefix:MTFClassPrefixSymbol] &&
        (self.length > MTFClassPrefixSymbol.length));
}

- (nullable NSString *)mtf_symbol {
    switch (self.mtf_symbolType) {
    case MTFThemeSymbolTypeClass:
        return [self substringFromIndex:MTFClassPrefixSymbol.length];
    case MTFThemeSymbolTypeConstant:
        return [self substringFromIndex:MTFConstantPrefixSymbol.length];
    default:
        return nil;
    }
}

- (MTFThemeSymbolType)mtf_symbolType {
    if (self.mtf_isRawSymbolClassReference) {
        return MTFThemeSymbolTypeClass;
    }
    if (self.mtf_isRawSymbolConstantReference) {
        return MTFThemeSymbolTypeConstant;
    }
    return MTFThemeSymbolTypeNone;
}

- (BOOL)mtf_isSuperclassProperty {
    return [self isEqualToString:MTFThemeSuperclassKey];
}

@end
