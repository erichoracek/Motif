//
//  NSOutputStream+StringWriting.h
//  MotifCLI
//
//  Created by Eric Horacek on 2/8/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOutputStream (StringWriting)

- (NSInteger)mtf_writeString:(NSString *)string;

@end
