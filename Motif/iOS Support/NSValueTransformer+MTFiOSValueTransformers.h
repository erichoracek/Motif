//
//  NSValueTransformer+MTFiOSValueTransformers.h
//  Motif
//
//  Created by Eric Horacek on 5/15/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MTFBackwardsCompatableNullability.h"

MTF_NS_ASSUME_NONNULL_BEGIN

/**
 Registers a set of convenience value transformers in its load method.
 */
@interface NSValueTransformer (MTFiOSValueTransformers)

@end

/**
 The name of the value transformer responsible for transforming an NSString to
 a UIColor.
 */
extern NSString * const MTFColorFromStringTransformerName;

/**
 The name of the value transformer responsible for transforming an NSString to
 an NSValue wrapping a UIEdgeInsets struct.
 */
extern NSString * const MTFEdgeInsetsFromStringTransformerName;

/**
 The name of the value transformer responsible for transforming an NSString to
 an NSValue wrapping a CGPoint struct.
 */
extern NSString * const MTFPointFromStringTransformerName;

/**
 The name of the value transformer responsible for transforming an NSString to
 an NSValue wrapping a CGRect struct.
 */
extern NSString * const MTFRectFromStringTransformerName;

/**
 The name of the value transformer responsible for transforming an NSString to
 an NSValue wrapping a CGSize struct.
 */
extern NSString * const MTFSizeFromStringTransformerName;

MTF_NS_ASSUME_NONNULL_END
