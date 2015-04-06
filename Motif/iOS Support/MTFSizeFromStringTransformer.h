//
//  MTFSizeFromStringTransformer.h
//  Motif
//
//  Created by Eric Horacek on 12/26/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTFReverseTransformedValueClass.h"
#import "MTFObjCTypeValueTransformer.h"

MTF_NS_ASSUME_NONNULL_BEGIN

/**
 Transforms an NSString to a NSValue wrapping a CGSize struct.
 
 Allows reverse transformation.
 */
@interface MTFSizeFromStringTransformer : NSValueTransformer <MTFReverseTransformedValueClass, MTFObjCTypeValueTransformer>

@end

extern NSString * const MTFSizeFromStringTransformerName;

MTF_NS_ASSUME_NONNULL_END
