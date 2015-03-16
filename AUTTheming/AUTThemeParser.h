//
//  AUTThemeParser.h
//  Pods
//
//  Created by Eric Horacek on 2/11/15.
//
//

#import <Foundation/Foundation.h>
#import "AUTBackwardsCompatableNullability.h"

AUT_NS_ASSUME_NONNULL_BEGIN

@class AUTTheme;

@interface AUTThemeParser : NSObject

- (instancetype)initWithRawTheme:(NSDictionary *)rawTheme inheritingFromTheme:(aut_nullable AUTTheme *)theme error:(NSError **)error NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) NSDictionary *rawTheme;

@property (nonatomic, readonly) NSDictionary *parsedConstants;

@property (nonatomic, readonly) NSDictionary *parsedClasses;

@end

AUT_NS_ASSUME_NONNULL_END
