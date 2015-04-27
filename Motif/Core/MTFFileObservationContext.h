//
//  MTFFileObservationContext.h
//  Motif
//
//  Created by Eric Horacek on 4/26/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTFBackwardsCompatableNullability.h"

MTF_NS_ASSUME_NONNULL_BEGIN

@interface MTFFileObservationContext : NSObject

- (instancetype)initWithDispatchSource:(dispatch_source_t)dispatchSource fileDescriptor:(int)fileDescriptor path:(NSString *)path;

@property (nonatomic, readonly) dispatch_source_t dispatchSource;

@property (nonatomic, readonly) int fileDescriptor;

@property (nonatomic, copy, readonly) NSString *path;

@end

MTF_NS_ASSUME_NONNULL_END
