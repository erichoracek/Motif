//
//  NSValueTransformer+MotifCGPoint.h
//  Motif
//
//  Created by Eric Horacek on 6/6/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import UIKit;

@interface NSValueTransformer (MotifCGPoint)

@end

/// The name of the value transformer responsible for transforming an NSNumber
/// to a NSValue wrapping a CGPoint struct.
extern NSString * const MTFPointFromNumberTransformerName;

/// The name of the value transformer responsible for transforming an NSAray to
/// a NSValue wrapping a CGPoint struct.
extern NSString * const MTFPointFromArrayTransformerName;

/// The name of the value transformer responsible for transforming an
/// NSDictionary to a NSValue wrapping a CGPoint struct.
extern NSString * const MTFPointFromDictionaryTransformerName;
