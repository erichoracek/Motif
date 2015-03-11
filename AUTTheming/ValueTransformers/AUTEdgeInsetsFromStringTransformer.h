//
//  AUTEdgeInsetsFromStringTransformer.h
//  Pods
//
//  Created by Eric Horacek on 12/25/14.
//
//

#import <Foundation/Foundation.h>
#import "AUTReverseTransformedValueClass.h"
#import "AUTObjCTypeValueTransformer.h"

/**
 Transforms an NSString to a NSValue wrapping a UIEdgeInsets struct.
 
 Allows reverse transformation.
 */
@interface AUTEdgeInsetsFromStringTransformer : NSValueTransformer <AUTReverseTransformedValueClass, AUTObjCTypeValueTransformer>

@end

extern NSString * const AUTEdgeInsetsFromStringTransformerName;
