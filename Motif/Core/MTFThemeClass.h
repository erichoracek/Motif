//
//  MTFThemeClass.h
//  Motif
//
//  Created by Eric Horacek on 12/22/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTFBackwardsCompatableNullability.h"

MTF_NS_ASSUME_NONNULL_BEGIN

/**
 A named class from an MTFTheme containing a set of named properties with
 corresponding values.
 */
@interface MTFThemeClass : NSObject

/**
 The name of the theme class, as specified in the JSON theme file.
 */
@property (nonatomic, readonly) NSString *name;

/**
 The properties of the theme class as specified in the JSON theme file.
 
 This dictionary is keyed by property names with values of the properties
 values.
 */
@property (nonatomic, readonly) NSDictionary *properties;

/**
 Applies this theme class to an object.
 
 When a theme class is applied to an object:
 
 1. A list of all of the properties on the class is generated using
    property_getAttributes from objc/runtime.h.
 2. This list of properties is compared to the class properties defined in the
    theme file.
 3. If any of the properties from the theme file have the same type as the
    properties on the class, the value from the JSON theme file is set using
    key-value coding.
 4. If any of the matched properties have different types, an NSValueTransformer
    subclass if located transform the JSON value to the type of the
    property, e.g. NSString → UIEdgeInsets.
 5. The value from the above steps is set on the object using key-value coding.
 6. If there are no properties available for the theme property, its value is
    set on the object via key-value coding, which may throw an exception if the
    keypath is not implemented on the object.
 
 @param object The object that this theme class should be applied to.
 
 @return Whether the application was successful.
 */
- (BOOL)applyToObject:(id)object;

@end

/**
 The exception that is thrown when a property from a theme class is not able
 to be applied to an object.
 */
extern NSString * const MTFThemeClassUnappliedPropertyException;

MTF_NS_ASSUME_NONNULL_END
