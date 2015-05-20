//
//  MTFThemeConstant.h
//  Motif
//
//  Created by Eric Horacek on 12/24/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Motif/MTFBackwardsCompatableNullability.h>

MTF_NS_ASSUME_NONNULL_BEGIN

/**
 A named constant value from an MTFTheme.
 */
@interface MTFThemeConstant : NSObject

/**
 The constant name, as specified in the JSON theme file.
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 The value that the theme constant is referencing.
 */
@property (nonatomic, readonly) id value;

/**
 Shortcut for accessing a transformed value from registered value transformer.
 
 The trasformed values are cached before being returned, and as such this is the
 best way to access value-transformed values on the theme constant.
 
 @param name The name of the value transformer that should transform constant
             value.
 
 @return The transformed value.
 */
- (mtf_nullable id)transformedValueFromTransformerWithName:(NSString *)name;

@end

MTF_NS_ASSUME_NONNULL_END
