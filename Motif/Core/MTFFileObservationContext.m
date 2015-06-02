//
//  MTFFileObservationContext.m
//  Motif
//
//  Created by Eric Horacek on 4/26/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "MTFFileObservationContext.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MTFFileObservationContext

#pragma mark - NSObject

- (instancetype)init {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    // Ensure that exception is thrown when just `init` is called.
    return [self initWithDispatchSource:NULL fileDescriptor:0 path:nil];
#pragma clang diagnostic pop
}

#pragma mark - MTFFileObservationContext

- (instancetype)initWithDispatchSource:(dispatch_source_t)dispatchSource fileDescriptor:(int)fileDescriptor path:(NSString *)path {
    NSParameterAssert(dispatchSource);
    NSAssert(fileDescriptor != -1, @"File descriptor must not be -1.");
    
    self = [super init];
    if (self == nil) return nil;
    
    _dispatchSource = dispatchSource;
    _fileDescriptor = fileDescriptor;
    _path = [path copy];
    
    return self;
}

@end

NS_ASSUME_NONNULL_END
