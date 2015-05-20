//
//  MTFFileObservationContext.h
//  Motif
//
//  Created by Eric Horacek on 4/26/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Motif/MTFBackwardsCompatableNullability.h>

MTF_NS_ASSUME_NONNULL_BEGIN

/**
 Represents a file that is being observed. Used in conjunction with an
 MTFThemeSourceObserver.
 */
@interface MTFFileObservationContext : NSObject

/**
 Initializes a file observation context.
 
 @param dispatchSource The dispatch source for the file that is being observed.
 @param fileDescriptor The file descriptor of the file that is being observed,
                       as returned by invoking the open() function.
 @param path           The path of the file that is being observed.
 
 @return An initialized file observation context.
 */
- (instancetype)initWithDispatchSource:(dispatch_source_t)dispatchSource fileDescriptor:(int)fileDescriptor path:(NSString *)path;

/**
 The dispatch source for the file that is being observed.
 */
@property (nonatomic, readonly) dispatch_source_t dispatchSource;

/**
 The file descriptor of the file that is being observed, as returned by invoking
 the open() function.
 */
@property (nonatomic, readonly) int fileDescriptor;

/**
 The path of the file that is being observed.
 */
@property (nonatomic, copy, readonly) NSString *path;

@end

MTF_NS_ASSUME_NONNULL_END
