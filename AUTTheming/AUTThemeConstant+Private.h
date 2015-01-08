//
//  AUTThemeConstant+Private.h
//  Pods
//
//  Created by Eric Horacek on 12/24/14.
//
//

#import "AUTThemeConstant.h"

@interface AUTThemeConstant ()

- (instancetype)initWithKey:(NSString *)key rawValue:(id)rawValue mappedValue:(id)mappedValue __attribute__ ((nonnull (1, 2, 3)));

@property (nonatomic, copy) NSString *key;

@property (nonatomic) id rawValue;

@property (nonatomic) id mappedValue;

/**
 A cache to hold transformed mapped values on this constant.
 
 Keyed by the transformer name.
 
 @see NSValueTransformer
 */
@property (nonatomic) NSCache *transformedValueCache;

@end
