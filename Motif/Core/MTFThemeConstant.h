//
//  MTFThemeConstant.h
//  Motif
//
//  Created by Eric Horacek on 12/24/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A named constant value from an MTFTheme.
 */
@interface MTFThemeConstant : NSObject

/**
 The constant name, as specified in the theme file.
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 The value that the theme constant is referencing.
 */
@property (nonatomic, readonly) id value;

/**
 Shortcut for accessing a transformed value from a registered value transformer.
 
 The trasformed values are cached before being returned, and as such this is the
 best way to access value-transformed values on the theme constant.
 
 @param transformer The value transformer that should transform the constant
                    value.

 @return The transformed value.
 */
- (nullable id)transformedValueFromTransformer:(NSValueTransformer *)transformer;

@end

NS_ASSUME_NONNULL_END
