//
//  NSValueTransformer+MotifUIColor.h
//  Motif
//
//  Created by Eric Horacek on 6/7/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface NSValueTransformer (MotifUIColor)

/**
 The name of the value transformer responsible for transforming an NSString to
 a UIColor.
 */
extern NSString * const MTFColorFromStringTransformerName;

@end

NS_ASSUME_NONNULL_END
