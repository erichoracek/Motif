//
//  AUTRectFromStringTransformer.h
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
 Transforms an NSString to a NSValue wrapping a CGRect struct.
 
 Allows reverse transformation.
 */
@interface AUTRectFromStringTransformer : NSValueTransformer <AUTReverseTransformedValueClass, AUTObjCTypeValueTransformer>

@end

extern NSString * const AUTRectFromStringTransformerName;

AUT_NS_ASSUME_NONNULL_END
