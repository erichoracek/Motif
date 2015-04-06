//
//  MTFThemeSymbolReference.m
//  Motif
//
//  Created by Eric Horacek on 4/2/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "MTFThemeSymbolReference.h"

@implementation MTFThemeSymbolReference

@dynamic symbol;
@dynamic type;

- (instancetype)initWithRawSymbol:(NSString *)rawSymbol {
    NSParameterAssert(rawSymbol.mtf_isRawSymbolReference);
    self = [super init];
    if (self) {
        _rawSymbol = rawSymbol;
    }
    return self;
}

- (NSString *)symbol {
    return self.rawSymbol.mtf_symbol;
}

- (MTFThemeSymbolType)type {
    return self.rawSymbol.mtf_symbolType;
}

@end
