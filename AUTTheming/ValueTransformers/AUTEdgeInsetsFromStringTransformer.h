//
//  AUTEdgeInsetsFromStringTransformer.h
//  Pods
//
//  Created by Eric Horacek on 12/25/14.
//
//

#import <Foundation/Foundation.h>

/**
 Transforms an NSString to a NSValue wrapping a UIEdgeInsets struct.
 
 Allows reverse transformation.
 */
@interface AUTEdgeInsetsFromStringTransformer : NSValueTransformer

@end

extern NSString * const AUTEdgeInsetsFromStringTransformerName;
