//
//  AUTReverseTransformedValueClass.h
//  Pods
//
//  Created by Eric Horacek on 3/9/15.
//
//

#import <Foundation/Foundation.h>
#import "AUTBackwardsCompatableNullability.h"

AUT_NS_ASSUME_NONNULL_BEGIN

@protocol AUTReverseTransformedValueClass <NSObject>

+ (Class)reverseTransformedValueClass;

@end

AUT_NS_ASSUME_NONNULL_END
