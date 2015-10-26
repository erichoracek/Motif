//
//  MTFThemeClass.h
//  Motif
//
//  Created by Eric Horacek on 12/22/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A named class from an MTFTheme containing a set of named properties with
 corresponding values.
 */
@interface MTFThemeClass : NSObject

- (instancetype)init NS_UNAVAILABLE;

/**
 The name of the theme class, as specified in the theme file.
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 The properties of the theme class as specified in the theme file.
 
 This dictionary is keyed by property names with values of the properties
 values.
 */
@property (nonatomic, copy, readonly) NSDictionary<NSString *, id> *properties;

/**
 Applies this theme class to an object.
 
 When a theme class is applied to an object:
 
 1. A list of all of the properties on the class is generated using
    property_getAttributes from objc/runtime.h.
 2. This list of properties is compared to the class properties defined in the
    theme file.
 3. If any of the properties from the theme file have the same type as the
    properties on the class, the value from the theme file is set using
    key-value coding.
 4. If any of the matched properties have different types, an NSValueTransformer
    subclass if located transform the raw value to the type of the property,
    e.g. NSString → UIEdgeInsets.
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

/**
 The user info key identifying the property name for which the class application
 failed, as contained within the info of an 
 MTFThemeClassUnappliedPropertyException
 */
extern NSString * const MTFThemeClassExceptionUserInfoKeyUnappliedPropertyName;

NS_ASSUME_NONNULL_END
