//
//  NSDictionary+IntersectingKeys.h
//  Motif
//
//  Created by Eric Horacek on 3/4/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (IntersectingKeys)

/**
 The set of keys that intersect with another dictionary's set of keys.
 
 @param dictionary The dictionary to compare keys to.
 
 @return The set of keys that intersect with the specified dictionary's keys.
         Nil if no keys are found.
 */
- (nullable NSSet *)mtf_intersectingKeysWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
