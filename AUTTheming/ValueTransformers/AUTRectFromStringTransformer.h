//
//  AUTRectFromStringTransformer.h
//  Pods
//
//  Created by Eric Horacek on 12/25/14.
//
//

#import <Foundation/Foundation.h>

/**
 Transforms an NSString to a NSValue wrapping a CGRect struct.
 
 Allows reverse transformation.
 */
@interface AUTRectFromStringTransformer : NSValueTransformer

@end

extern NSString * const AUTRectFromStringTransformerName;
