//
//  MTFReverseTransformedValueClass.h
//  Motif
//
//  Created by Eric Horacek on 3/9/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTFBackwardsCompatableNullability.h"

MTF_NS_ASSUME_NONNULL_BEGIN

/**
 A protocol implemented by NSValueTransformers specifying that they take a 
 specific type of values.
 */
@protocol MTFReverseTransformedValueClass <NSObject>

/**
 The class of object that should be provided to this value transformer when
 invoking its transformedValue: method.
 */
+ (Class)reverseTransformedValueClass;

@end

MTF_NS_ASSUME_NONNULL_END
