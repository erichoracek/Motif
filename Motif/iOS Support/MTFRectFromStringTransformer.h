//
//  MTFRectFromStringTransformer.h
//  Motif
//
//  Created by Eric Horacek on 12/25/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTFReverseTransformedValueClass.h"
#import "MTFObjCTypeValueTransformer.h"

MTF_NS_ASSUME_NONNULL_BEGIN

/**
 Transforms an NSString to an NSValue wrapping a CGRect struct.
 
 Allows reverse transformation.
 */
@interface MTFRectFromStringTransformer : NSValueTransformer <MTFReverseTransformedValueClass, MTFObjCTypeValueTransformer>

@end

/**
 The name of the value transformer responsible for transforming an NSString to
 an NSValue wrapping a CGRect struct.
 */
extern NSString * const MTFRectFromStringTransformerName;

MTF_NS_ASSUME_NONNULL_END
