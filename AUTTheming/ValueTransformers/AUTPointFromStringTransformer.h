//
//  AUTPointFromStringTransformer.h
//  Pods
//
//  Created by Eric Horacek on 12/25/14.
//
//

#import <Foundation/Foundation.h>

/**
 Transforms an NSString to a NSValue wrapping a CGPoint struct.
 
 Allows reverse transformation.
 */
@interface AUTPointFromStringTransformer : NSValueTransformer

@end

extern NSString * const AUTPointFromStringTransformerName;
