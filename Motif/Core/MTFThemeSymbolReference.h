//
//  MTFThemeSymbolReference.h
//  Motif
//
//  Created by Eric Horacek on 4/2/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+ThemeSymbols.h"

@interface MTFThemeSymbolReference : NSObject

- (instancetype)initWithRawSymbol:(NSString *)rawSymbol;

@property (nonatomic, readonly) NSString *rawSymbol;

@property (nonatomic, readonly) NSString *symbol;

@property (nonatomic, readonly) MTFThemeSymbolType type;

@end
