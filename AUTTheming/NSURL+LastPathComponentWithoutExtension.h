//
//  NSURL+LastPathComponentWithoutExtension.h
//  AUTTheming
//
//  Created by Eric Horacek on 12/23/14.
//
//

#import <Foundation/Foundation.h>
#import "AUTBackwardsCompatableNullability.h"

AUT_NS_ASSUME_NONNULL_BEGIN

@interface NSURL (LastPathComponentWithoutExtension)

@property (nonatomic, readonly, aut_nullable) NSString *aut_lastPathComponentWithoutExtension;

@end

AUT_NS_ASSUME_NONNULL_END
