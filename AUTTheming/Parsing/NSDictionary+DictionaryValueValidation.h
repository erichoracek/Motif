//
//  NSDictionary+DictionaryValueValidation.h
//  AUTTheming
//
//  Created by Eric Horacek on 4/2/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (DictionaryValueValidation)

/**
 Returns an NSDictionary value for the specified key in the callee, otherwise
 populates a pass-by-reference error if there's a type error.
 */
- (NSDictionary *)aut_dictionaryValueForKey:(NSString *)key error:(NSError *__autoreleasing *)error;

@end
