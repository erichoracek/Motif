//
//  NSDictionary+DictionaryValueValidation.m
//  Motif
//
//  Created by Eric Horacek on 4/2/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "MTFErrors.h"

#import "NSDictionary+DictionaryValueValidation.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSDictionary (DictionaryValueValidation)

- (nullable NSDictionary *)mtf_dictionaryValueForKey:(NSString *)key error:(NSError **)error {
    NSDictionary *value = self[key];
    // If there is no value for the specified key, is it not an error, just
    // return.
    if (value == nil) return nil;

    // If the value for the specified key is a dictionary but is not a valid
    // type, return with error.
    if (![value isKindOfClass:NSDictionary.class]) {
        if (error != NULL) {
            NSString *localizedDescription = [NSString stringWithFormat:
                @"The value for the key '%@' is not a dictionary",
                key];
            *error = [NSError
                errorWithDomain:MTFErrorDomain
                code:MTFErrorFailedToParseTheme
                userInfo:@{
                    NSLocalizedDescriptionKey : localizedDescription
                }];
        }
        return nil;
    }

    return value;
}

@end

NS_ASSUME_NONNULL_END
