//
//  NSOutputStream+StringWriting.m
//  MotifCLI
//
//  Created by Eric Horacek on 2/8/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "NSOutputStream+StringWriting.h"

@implementation NSOutputStream (StringWriting)

- (NSInteger)mtf_writeString:(NSString *)string {
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    return [self write:stringData.bytes maxLength:stringData.length];
}

@end
