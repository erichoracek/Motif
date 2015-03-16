//
//  NSString+ThemeSymbols.h
//  Pods
//
//  Created by Eric Horacek on 3/3/15.
//
//

#import <Foundation/Foundation.h>
#import "AUTBackwardsCompatableNullability.h"

AUT_NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AUTThemeSymbolType) {
    AUTThemeSymbolTypeNone,
    AUTThemeSymbolTypeConstant,
    AUTThemeSymbolTypeClass
};

extern NSString * const AUTConstantPrefixSymbol;

extern NSString * const AUTClassPrefixSymbol;

extern NSString * const AUTThemeSuperclassKey;

@interface NSString (ThemeSymbols)

@property (nonatomic, readonly) BOOL aut_isRawSymbolReference;

@property (nonatomic, readonly) BOOL aut_isRawSymbolClassReference;

@property (nonatomic, readonly) BOOL aut_isRawSymbolConstantReference;

@property (nonatomic, readonly, aut_nullable) NSString *aut_symbol;

@property (nonatomic, readonly) AUTThemeSymbolType aut_symbolType;

@property (nonatomic, readonly) BOOL aut_isSuperclassProperty;

@end

AUT_NS_ASSUME_NONNULL_END
