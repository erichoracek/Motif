//
//  AUTThemeConstant.h
//  AUTTheming
//
//  Created by Eric Horacek on 12/24/14.
//
//

#import <Foundation/Foundation.h>

@interface AUTThemeConstant : NSObject

/**
 The constant key, as specified in the JSON theme file.
 */
@property (nonatomic, copy, readonly) NSString *key;

/**
 The value that the theme constant is referencing.
 */
@property (nonatomic, readonly) id value;

/**
 Shortcut for accessing a transformed value from registered value transformer.
 
 The trasformed values are cached before being returned, and as such this is the best way to access value-transformed values on the theme constant.
 
 @param name The name of the value transformer that should transform constant value.
 
 @return The transformed value.
 */
- (id)transformedValueFromTransformerWithName:(NSString *)name;

@end
