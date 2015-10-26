//
//  NSDictionary+DictionaryValueValidation.h
//  Motif
//
//  Created by Eric Horacek on 4/2/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary<__covariant KeyType, __covariant ObjectType> (DictionaryValueValidation)

/**
 Returns an NSDictionary value for the specified key in the receiver, otherwise
 populates a pass-by-reference error if there's a type error.
 */
- (nullable NSDictionary *)mtf_dictionaryValueForKey:(KeyType)key error:(NSError *__autoreleasing *)error;

@end
