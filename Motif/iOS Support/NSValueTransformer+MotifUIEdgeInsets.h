//
//  NSValueTransformer+MotifUIEdgeInsets.h
//  Motif
//
//  Created by Eric Horacek on 6/2/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import UIKit;

@interface NSValueTransformer (MotifUIEdgeInsets)

@end

/**
 The name of the value transformer responsible for transforming an NSNumber to
 a NSValue wrapping a UIEdgeInsets struct.
 */
extern NSString * const MTFUIEdgeInsetsFromNumberTransformerName;

/**
 The name of the value transformer responsible for transforming an NSArray to a
 NSValue wrapping a UIEdgeInsets struct.
 */
extern NSString * const MTFUIEdgeInsetsFromArrayTransformerName;

/**
 The name of the value transformer responsible for transforming an NSDictionary
 to a NSValue wrapping a UIEdgeInsets struct.
 */
extern NSString * const MTFUIEdgeInsetsFromDictionaryTransformerName;
