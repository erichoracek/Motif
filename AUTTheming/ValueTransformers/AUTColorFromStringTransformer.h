//
//  AUTColorFromStringTransformer.h
//  AUTTheming
//
//  Created by Eric Horacek on 12/23/14.
//
//

#import <Foundation/Foundation.h>

/**
 Transforms an NSString to a UIColor.
 
 Does not allow reverse transformation.
 */
@interface AUTColorFromStringTransformer : NSValueTransformer

@end

extern NSString * const AUTColorFromStringTransformerName;
