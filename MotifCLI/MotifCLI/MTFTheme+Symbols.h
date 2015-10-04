//
//  MTFTheme+Symbols.h
//  MotifCLI
//
//  Created by Eric Horacek on 8/17/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import Motif;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MTFSymbolType) {
    MTFSymbolTypeConstantNames,
    MTFSymbolTypeClassNames,
    MTFSymbolTypeProperties,
    MTFSymbolTypeCount
};

@interface MTFTheme (Symbols)

@property (nonatomic, readonly, copy) NSArray *constantNames;
@property (nonatomic, readonly, copy) NSArray *classNames;
@property (nonatomic, readonly, copy) NSArray *properties;
@property (nonatomic, readonly, copy) NSString *symbolsName;

/// Symbols are sorted by name.
- (nullable NSArray *)symbolsForType:(MTFSymbolType)symbolType;


@end

NS_ASSUME_NONNULL_END
