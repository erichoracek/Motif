//
//  AUTThemeConstant+Private.h
//  Pods
//
//  Created by Eric Horacek on 12/24/14.
//
//

#import "AUTThemeConstant.h"

@interface AUTThemeConstant ()

#pragma mark - Public

/**
 Readwrite version of the public property
 */
@property (nonatomic, copy) NSString *key;

#pragma mark - Private

/**
 Initializes a new instance of an AUTThemeConstant.
 */
- (instancetype)initWithKey:(NSString *)key rawValue:(id)rawValue mappedValue:(id)mappedValue __attribute__ ((nonnull (1, 2)));

/**
 The raw value of the constant, directly deserialized from the JSON file.
 */
@property (nonatomic) id rawValue;

/**
 If the theme constant is a reference to a class or a constant, the object that it is referencing.
 
 Can be either an AUTThemeClass, AUTThemeConstant, or nil if the constant is not a reference.
 */
@property (nonatomic) id mappedValue;

/**
 A cache to hold transformed mapped values on this constant.
 
 Keyed by the transformer name.
 
 @see NSValueTransformer
 */
@property (nonatomic) NSCache *transformedValueCache;

@end
