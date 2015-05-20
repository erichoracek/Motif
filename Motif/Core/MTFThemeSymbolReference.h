//
//  MTFThemeSymbolReference.h
//  Motif
//
//  Created by Eric Horacek on 4/2/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Motif/NSString+ThemeSymbols.h>

/**
 Represents a reference to another theme symbol.

 Used during theme parsing, by MTFThemeParser.
 */
@interface MTFThemeSymbolReference : NSObject

/**
 Initializes a theme symbols reference with a raw symbol.
 
 @param rawSymbol The raw symbol that the reference is referencing within the
                  theme, e.g. ".Class" or "$Constant"
 
 @return An initialized symbol refrence.
 */
- (instancetype)initWithRawSymbol:(NSString *)rawSymbol;

/**
 The raw symbol that the reference is referencing within the theme, e.g.
 ".Class" or "$Constant".
 */
@property (nonatomic, readonly) NSString *rawSymbol;

/**
 The name of the symbol that the reference is referencing, with no syntax
 included, e.g. "Class" or "Constant".
 */
@property (nonatomic, readonly) NSString *symbol;

/**
 The type of symbol that the reference is referencing.
 */
@property (nonatomic, readonly) MTFThemeSymbolType type;

@end
