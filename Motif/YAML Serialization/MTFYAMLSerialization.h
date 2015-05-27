//
//  MTFYAMLSerialization.h
//  Motif
//
//  Created by Eric Horacek on 5/25/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import Foundation;
#import <Motif/MTFBackwardsCompatableNullability.h>

MTF_NS_ASSUME_NONNULL_BEGIN

@interface MTFYAMLSerialization : NSObject

+ (mtf_nullable id)YAMLObjectWithData:(NSData *)data error:(NSError **)error;

@end

MTF_NS_ASSUME_NONNULL_END
