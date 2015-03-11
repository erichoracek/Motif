//
//  AUTColorFromStringTransformer.h
//  AUTTheming
//
//  Created by Eric Horacek on 12/23/14.
//
//

#import <Foundation/Foundation.h>
#import "AUTReverseTransformedValueClass.h"

/**
 Transforms an NSString to a UIColor.
 
 Does not allow reverse transformation.
 */
@interface AUTColorFromStringTransformer : NSValueTransformer <AUTReverseTransformedValueClass>

@end

extern NSString * const AUTColorFromStringTransformerName;
