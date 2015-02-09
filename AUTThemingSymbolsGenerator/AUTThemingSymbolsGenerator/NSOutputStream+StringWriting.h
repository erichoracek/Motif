//
//  NSOutputStream+StringWriting.h
//  AUTThemingSymbolsGenerator
//
//  Created by Eric Horacek on 2/8/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOutputStream (StringWriting)

- (NSInteger)aut_writeString:(NSString *)string;

@end
