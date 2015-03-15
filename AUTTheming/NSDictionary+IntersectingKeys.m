//
//  NSDictionary+IntersectingKeys.m
//  Pods
//
//  Created by Eric Horacek on 3/4/15.
//
//

#import "NSDictionary+IntersectingKeys.h"

@implementation NSDictionary (IntersectingKeys)

- (NSSet *)aut_intersectingKeysWithDictionary:(NSDictionary *)dictionary
{
    NSParameterAssert(dictionary);
    
    if (!dictionary) {
        return nil;
    }
    
    NSSet *selfKeys = [NSSet setWithArray:self.allKeys];
    NSSet *dictionaryKeys = [NSSet setWithArray:dictionary.allKeys];
    
    if ([selfKeys intersectsSet:dictionaryKeys]) {
        NSMutableSet *intersectingKeys = [selfKeys mutableCopy];
        [intersectingKeys intersectSet:dictionaryKeys];
        return [intersectingKeys copy];
    }
    
    return nil;
}

@end
