//
//  NSString+ThemeSymbols.m
//  Pods
//
//  Created by Eric Horacek on 3/3/15.
//
//

#import "NSString+ThemeSymbols.h"

NSString * const AUTClassPrefixSymbol = @".";

NSString * const AUTConstantPrefixSymbol = @"$";

NSString * const AUTThemeSuperclassKey = @"_superclass";

@implementation NSString (ThemeSymbols)

- (BOOL)aut_isRawSymbolReference
{
    return (self.aut_isRawSymbolClassReference || self.aut_isRawSymbolConstantReference);
}

- (BOOL)aut_isRawSymbolConstantReference
{
    return ([self hasPrefix:AUTConstantPrefixSymbol] && (self.length > AUTConstantPrefixSymbol.length));
}

- (BOOL)aut_isRawSymbolClassReference
{
    return ([self hasPrefix:AUTClassPrefixSymbol] && (self.length > AUTClassPrefixSymbol.length));
}

- (NSString *)aut_symbol
{
    switch (self.aut_symbolType) {
    case AUTThemeSymbolTypeClass:
        return [self substringFromIndex:AUTClassPrefixSymbol.length];
    case AUTThemeSymbolTypeConstant:
        return [self substringFromIndex:AUTConstantPrefixSymbol.length];
    default:
        return nil;
    }
}

- (AUTThemeSymbolType)aut_symbolType
{
    if (self.aut_isRawSymbolClassReference) {
        return AUTThemeSymbolTypeClass;
    }
    if (self.aut_isRawSymbolConstantReference) {
        return AUTThemeSymbolTypeConstant;
    }
    return AUTThemeSymbolTypeNone;
}

- (BOOL)aut_isSuperclassProperty
{
    return [self isEqualToString:AUTThemeSuperclassKey];
}

@end
