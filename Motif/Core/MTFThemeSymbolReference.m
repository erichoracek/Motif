//
//  MTFThemeSymbolReference.m
//  Motif
//
//  Created by Eric Horacek on 4/2/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "MTFThemeSymbolReference.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MTFThemeSymbolReference

#pragma mark - Lifecycle

- (instancetype)initWithRawSymbol:(NSString *)rawSymbol {
    NSParameterAssert(rawSymbol != nil);
    NSParameterAssert(rawSymbol.mtf_isRawSymbolReference);

    self = [super init];

    _rawSymbol = [rawSymbol copy];

    return self;
}

#pragma mark - MTFThemeSymbolReference

- (nullable NSString *)symbol {
    return self.rawSymbol.mtf_symbol;
}

- (MTFThemeSymbolType)type {
    return self.rawSymbol.mtf_symbolType;
}

@end

NS_ASSUME_NONNULL_END
