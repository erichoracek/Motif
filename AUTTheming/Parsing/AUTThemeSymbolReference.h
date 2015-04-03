//
//  AUTThemeSymbolReference.h
//  AUTTheming
//
//  Created by Eric Horacek on 4/2/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+ThemeSymbols.h"

@interface AUTThemeSymbolReference : NSObject

- (instancetype)initWithRawSymbol:(NSString *)rawSymbol;

@property (nonatomic, readonly) NSString *rawSymbol;

@property (nonatomic, readonly) NSString *symbol;

@property (nonatomic, readonly) AUTThemeSymbolType type;

@end
