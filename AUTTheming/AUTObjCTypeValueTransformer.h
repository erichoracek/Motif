//
//  AUTObjCTypeValueTransformer.h
//  Pods
//
//  Created by Eric Horacek on 3/9/15.
//
//

#import <Foundation/Foundation.h>
#import "AUTBackwardsCompatableNullability.h"

AUT_NS_ASSUME_NONNULL_BEGIN

@protocol AUTObjCTypeValueTransformer <NSObject>

+ (const char *)transformedValueObjCType;

@end

AUT_NS_ASSUME_NONNULL_END
