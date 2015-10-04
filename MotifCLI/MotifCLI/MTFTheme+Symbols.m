//
//  MTFTheme+Symbols.m
//  MotifCLI
//
//  Created by Eric Horacek on 8/17/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Motif/MTFTheme_Private.h>

#import "MTFTheme+Symbols.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MTFTheme (Symbols)

- (NSArray *)constantNames {
    return self.constants.allKeys;
}

- (NSArray *)classNames {
    return self.classes.allKeys;
}

- (NSArray *)properties {
    NSMutableSet *properties = [NSMutableSet new];

    for (MTFThemeClass *class in self.classes.allValues) {
        [properties addObjectsFromArray:class.properties.allKeys];
    }

    return properties.allObjects;
}

static NSString * const NamePrefix = @"Theme";

- (NSString *)symbolsName {
    NSString *name = self.names.firstObject;

    // Append 'theme' to the end of the name (unless its name is already
    // 'Theme', then just leave it)
    if (![name isEqualToString:NamePrefix]) {
        name = [name stringByAppendingString:NamePrefix];
    }

    return name;
}

- (nullable NSArray *)unsortedSymbolsForType:(MTFSymbolType)symbolType {
    switch (symbolType) {
    case MTFSymbolTypeClassNames:
        return self.classNames;
    case MTFSymbolTypeConstantNames:
        return self.constantNames;
    case MTFSymbolTypeProperties:
        return self.properties;
    default:
        return nil;
    }
}

- (nullable NSArray *)symbolsForType:(MTFSymbolType)symbolType {
    NSArray *symbols = [self unsortedSymbolsForType:symbolType];

    // Sort symbols to ensure they end up in a deterministic order.
    return [symbols sortedArrayUsingSelector:@selector(compare:)];
}

@end

NS_ASSUME_NONNULL_END
