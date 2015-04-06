//
//  NSURL+LastPathComponentWithoutExtension.h
//  Motif
//
//  Created by Eric Horacek on 12/23/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTFBackwardsCompatableNullability.h"

MTF_NS_ASSUME_NONNULL_BEGIN

@interface NSURL (LastPathComponentWithoutExtension)

@property (nonatomic, readonly, mtf_nullable) NSString *mtf_lastPathComponentWithoutExtension;

@end

MTF_NS_ASSUME_NONNULL_END
