//
//  MTFThemeConstant_Private.h
//  Motif
//
//  Created by Eric Horacek on 12/24/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Motif/MTFThemeConstant.h>

MTF_NS_ASSUME_NONNULL_BEGIN

@interface MTFThemeConstant ()

/**
 Initializes a new instance of an MTFThemeConstant.
 */
- (instancetype)initWithName:(NSString *)name rawValue:(id)rawValue mappedValue:(mtf_nullable id)mappedValue;

/**
 The raw value of the constant, directly deserialized from the JSON file.
 */
@property (nonatomic, readonly) id rawValue;

/**
 If the theme constant is a reference to a class or a constant, the object that
 it is referencing.
 
 Can be either an MTFThemeClass, MTFThemeConstant, or nil if the constant is not
 a reference.
 */
@property (nonatomic, mtf_nullable) id mappedValue;

/**
 A cache to hold transformed mapped values on this constant.
 
 Keyed by the transformer name.
 
 @see NSValueTransformer
 */
@property (nonatomic, mtf_null_resettable) NSCache *transformedValueCache;

@end

MTF_NS_ASSUME_NONNULL_END
