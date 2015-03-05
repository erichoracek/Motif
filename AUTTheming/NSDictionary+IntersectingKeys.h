//
//  NSDictionary+IntersectingKeys.h
//  Pods
//
//  Created by Eric Horacek on 3/4/15.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (IntersectingKeys)

/**
 The set of keys that intersect with another dictionary's set of keys.
 
 @param dictionary The dictionary to compare keys to.
 
 @return The set of keys that intersect with the specified dictionary's keys. Nil if no keys are found.
 */
- (NSSet *)aut_intersectingKeysWithDictionary:(NSDictionary *)dictionary;

@end
