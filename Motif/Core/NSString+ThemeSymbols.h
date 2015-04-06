//
//  NSString+ThemeSymbols.h
//  Motif
//
//  Created by Eric Horacek on 3/3/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTFBackwardsCompatableNullability.h"

MTF_NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MTFThemeSymbolType) {
    MTFThemeSymbolTypeNone,
    MTFThemeSymbolTypeConstant,
    MTFThemeSymbolTypeClass
};

extern NSString * const MTFConstantPrefixSymbol;

extern NSString * const MTFClassPrefixSymbol;

extern NSString * const MTFThemeSuperclassKey;

@interface NSString (ThemeSymbols)

@property (nonatomic, readonly) BOOL mtf_isRawSymbolReference;

@property (nonatomic, readonly) BOOL mtf_isRawSymbolClassReference;

@property (nonatomic, readonly) BOOL mtf_isRawSymbolConstantReference;

@property (nonatomic, readonly, mtf_nullable) NSString *mtf_symbol;

@property (nonatomic, readonly) MTFThemeSymbolType mtf_symbolType;

@property (nonatomic, readonly) BOOL mtf_isSuperclassProperty;

@end

MTF_NS_ASSUME_NONNULL_END
