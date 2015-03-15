//
//  AUTSizeFromStringTransformer.h
//  Pods
//
//  Created by Eric Horacek on 12/26/14.
//
//

#import <Foundation/Foundation.h>
#import "AUTReverseTransformedValueClass.h"
#import "AUTObjCTypeValueTransformer.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Transforms an NSString to a NSValue wrapping a CGSize struct.
 
 Allows reverse transformation.
 */
@interface AUTSizeFromStringTransformer : NSValueTransformer <AUTReverseTransformedValueClass, AUTObjCTypeValueTransformer>

@end

extern NSString * const AUTSizeFromStringTransformerName;

NS_ASSUME_NONNULL_END
