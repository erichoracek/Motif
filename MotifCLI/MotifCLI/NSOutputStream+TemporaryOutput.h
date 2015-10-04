//
//  NSOutputStream+TemporaryOutput.h
//  MotifCLI
//
//  Created by Eric Horacek on 8/17/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface NSOutputStream (TemporaryOutput)

/// Returns an output stream that writes its contents to a temporary location,
/// to eventually be moved to the specified destination upon closure.
+ (instancetype)temporaryOutputStreamWithDestinationURL:(NSURL *)destinationURL;

/// Compares the contents of the temporary file that output was written to with
/// that of the final destination URL that the receiver was initialized with (if
/// a file exists at that location). If the files differ, the temporary file is
/// used to replace the file at the final destination. If they do not differ,
/// the temporary file is deleted and no further action is taken.
///
/// Expects to operate on a closed stream.
- (void)copyToDestinationIfNecessary;

/// The URL that temporary output is directed to.
@property (nonatomic, copy) NSURL *temporaryURL;

/// The URL that the temporary output file will be moved to when
/// copyToDestinationIfNecessary is invoked.
@property (nonatomic, copy) NSURL *destinationURL;

@end

NS_ASSUME_NONNULL_END
