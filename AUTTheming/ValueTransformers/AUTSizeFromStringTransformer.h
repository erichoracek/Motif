//
//  AUTSizeFromStringTransformer.h
//  Pods
//
//  Created by Eric Horacek on 12/26/14.
//
//

#import <Foundation/Foundation.h>

/**
 Transforms an NSString to a NSValue wrapping a CGSize struct.
 
 Allows reverse transformation.
 */
@interface AUTSizeFromStringTransformer : NSValueTransformer

@end

extern NSString * const AUTSizeFromStringTransformerName;
