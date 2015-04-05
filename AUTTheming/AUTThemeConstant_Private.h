//
//  AUTThemeConstant_Private.h
//  Pods
//
//  Created by Eric Horacek on 12/24/14.
//
//

#import "AUTThemeConstant.h"

AUT_NS_ASSUME_NONNULL_BEGIN

@interface AUTThemeConstant ()

/**
 Initializes a new instance of an AUTThemeConstant.
 */
- (instancetype)initWithName:(NSString *)name rawValue:(id)rawValue mappedValue:(aut_nullable id)mappedValue;

/**
 The raw value of the constant, directly deserialized from the JSON file.
 */
@property (nonatomic, readonly) id rawValue;

/**
 If the theme constant is a reference to a class or a constant, the object that
 it is referencing.
 
 Can be either an AUTThemeClass, AUTThemeConstant, or nil if the constant is not
 a reference.
 */
@property (nonatomic, aut_nullable) id mappedValue;

/**
 A cache to hold transformed mapped values on this constant.
 
 Keyed by the transformer name.
 
 @see NSValueTransformer
 */
@property (nonatomic, aut_null_resettable) NSCache *transformedValueCache;

@end

AUT_NS_ASSUME_NONNULL_END
