//
//  AUTThemeConstant.h
//  AUTTheming
//
//  Created by Eric Horacek on 12/24/14.
//
//

#import <Foundation/Foundation.h>

@interface AUTThemeConstant : NSObject

- (instancetype)initWithKey:(NSString *)key rawValue:(id)rawValue mappedValue:(id)mappedValue;

/**
 The constant key, as specified in the JSON theme file.
 */
@property (nonatomic, copy, readonly) NSString *key;

/**
 The raw value of the constant, directly serialized from the JSON file.
 */
@property (nonatomic, readonly) id rawValue;

/**
 Defaults as a pass-through accessor to `rawValue`, but is able to be set to and return a different value via `setMappedValue:`.
 */
@property (nonatomic, readonly) id mappedValue;

/**
 Shortcut for accessing a transformed value from registered value transformer.
 
 The trasformed values are cached before being returned, and as such this is the best way to access value-transformed values on the theme constant.
 
 @param name The name of the value transformer that should transform constant value.
 
 @return The transformed value.
 */
- (id)transformedValueFromTransformerWithName:(NSString *)name;

@end
