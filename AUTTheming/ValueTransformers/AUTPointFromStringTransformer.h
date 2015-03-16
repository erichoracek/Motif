//
//  AUTPointFromStringTransformer.h
//  Pods
//
//  Created by Eric Horacek on 12/25/14.
//
//

#import <Foundation/Foundation.h>
#import "AUTReverseTransformedValueClass.h"
#import "AUTObjCTypeValueTransformer.h"

AUT_NS_ASSUME_NONNULL_BEGIN

/**
 Transforms an NSString to a NSValue wrapping a CGPoint struct.
 
 Allows reverse transformation.
 */
@interface AUTPointFromStringTransformer : NSValueTransformer  <AUTReverseTransformedValueClass, AUTObjCTypeValueTransformer>

@end

extern NSString * const AUTPointFromStringTransformerName;

AUT_NS_ASSUME_NONNULL_END
