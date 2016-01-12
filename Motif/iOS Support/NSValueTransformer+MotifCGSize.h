//
//  NSValueTransformer+MotifCGSize.h
//  Motif
//
//  Created by Eric Horacek on 6/4/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import CoreGraphics;

NS_ASSUME_NONNULL_BEGIN

@interface NSValueTransformer (MotifCGSize)

@end

/// The name of the value transformer responsible for transforming an NSNumber
/// to a NSValue wrapping a CGSize struct.
extern NSString * const MTFSizeFromNumberTransformerName;

/// The name of the value transformer responsible for transforming an NSAray to
/// a NSValue wrapping a CGSize struct.
extern NSString * const MTFSizeFromArrayTransformerName;

/// The name of the value transformer responsible for transforming an
/// NSDictionary to a NSValue wrapping a CGSize struct.
extern NSString * const MTFSizeFromDictionaryTransformerName;

NS_ASSUME_NONNULL_END
