//
//  AUTThemeSymbolReference.m
//  AUTTheming
//
//  Created by Eric Horacek on 4/2/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import "AUTThemeSymbolReference.h"

@implementation AUTThemeSymbolReference

@dynamic symbol;
@dynamic type;

- (instancetype)initWithRawSymbol:(NSString *)rawSymbol {
    NSParameterAssert(rawSymbol.aut_isRawSymbolReference);
    self = [super init];
    if (self) {
        _rawSymbol = rawSymbol;
    }
    return self;
}

- (NSString *)symbol {
    return self.rawSymbol.aut_symbol;
}

- (AUTThemeSymbolType)type {
    return self.rawSymbol.aut_symbolType;
}

@end
