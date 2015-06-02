//
//  NSString+ThemeSymbols.h
//  Motif
//
//  Created by Eric Horacek on 3/3/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The type of a theme symbol.
 */
typedef NS_ENUM(NSInteger, MTFThemeSymbolType){
    /**
     Not a theme symbol.
     */
    MTFThemeSymbolTypeNone,
    /**
     A theme symbol denoting a constant.
     */
    MTFThemeSymbolTypeConstant,
    /**
     A theme symbol denoting a class.
     */
    MTFThemeSymbolTypeClass
};

/**
 The prefix that's used to denote a theme constant: "$".
 */
extern NSString * const MTFConstantPrefixSymbol;

/**
 The prefix that's used to denote a theme class: ".".
 */
extern NSString * const MTFClassPrefixSymbol;

/**
 The property name that's used to denote a theme class' superclass.
 */
extern NSString * const MTFThemeSuperclassKey;

/**
 A collection of helper methods to assist with parsing a raw theme.
 */
@interface NSString (ThemeSymbols)

/**
 Whether the receiving string is a raw symbols reference.
 */
@property (nonatomic, readonly) BOOL mtf_isRawSymbolReference;

/**
 Whether the receiving string is a raw symbol reference to a theme class.
 */
@property (nonatomic, readonly) BOOL mtf_isRawSymbolClassReference;

/**
 Whether the receiving string is a raw symbol reference to a theme symbol.
 */
@property (nonatomic, readonly) BOOL mtf_isRawSymbolConstantReference;

/**
 The symbol without any syntax included, e.g. "Class" from ".Class".
 */
@property (nonatomic, readonly, nullable) NSString *mtf_symbol;

/**
 The type of the symbols, if it is one, or MTFThemeSymbolTypeNone otherwise.
 */
@property (nonatomic, readonly) MTFThemeSymbolType mtf_symbolType;

/**
 Whether the receiving string is a property denoting a class' superclass, e.g.
 "_superclass"
 */
@property (nonatomic, readonly) BOOL mtf_isSuperclassProperty;

@end

NS_ASSUME_NONNULL_END
