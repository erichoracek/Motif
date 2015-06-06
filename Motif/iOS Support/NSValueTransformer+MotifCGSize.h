//
//  NSValueTransformer+MotifCGSize.h
//  Motif
//
//  Created by Eric Horacek on 6/4/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import UIKit;

@interface NSValueTransformer (MotifCGSize)

@end

/// The name of the value transformer responsible for transforming an NSNumber
/// to a NSValue wrapping a CGSize struct.
extern NSString * const MTFCGSizeFromNumberTransformerName;

/// The name of the value transformer responsible for transforming an NSAray to
/// a NSValue wrapping a CGSize struct.
extern NSString * const MTFCGSizeFromArrayTransformerName;

/// The name of the value transformer responsible for transforming an
/// NSDictionary to a NSValue wrapping a CGSize struct.
extern NSString * const MTFCGSizeFromDictionaryTransformerName;
