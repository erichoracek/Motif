//
//  MTFYAMLSerialization.h
//  Motif
//
//  Created by Eric Horacek on 5/25/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTFYAMLSerialization : NSObject

+ (id)YAMLObjectWithData:(NSData *)data error:(NSError **)error;

@end
