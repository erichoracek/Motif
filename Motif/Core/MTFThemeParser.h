//
//  MTFThemeParser.h
//  Motif
//
//  Created by Eric Horacek on 2/11/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTFBackwardsCompatableNullability.h"

MTF_NS_ASSUME_NONNULL_BEGIN

@class MTFTheme;

@interface MTFThemeParser : NSObject

- (instancetype)initWithRawTheme:(NSDictionary *)rawTheme inheritingFromTheme:(mtf_nullable MTFTheme *)theme error:(NSError **)error NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) NSDictionary *rawTheme;

@property (nonatomic, readonly) NSDictionary *parsedConstants;

@property (nonatomic, readonly) NSDictionary *parsedClasses;

/**
 Whether theme parsers should globally resolve their constants, producing errors
 when references are invalid.
 
 @param shouldResolveReferences Whether references should be resolved.
 */
+ (void)setShouldResolveReferences:(BOOL)shouldResolveReferences;

@end

MTF_NS_ASSUME_NONNULL_END
