//
//  MTFThemeClass.h
//  Motif
//
//  Created by Eric Horacek on 12/22/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

@import Foundation;

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
 
 This dictionary is keyed by property names with values of the properties as
 values.
 */
@property (nonatomic, copy, readonly) NSDictionary<NSString *, id> *properties;

/**
 Applies the receiver to an object.
 
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
    
 If none of the above steps was successful, theme application is considered
 unsuccessful and the pass-by-reference error parameter is populated.
 
 @param applicant The object that this theme class should be applied to.
 
 @param error If an error occurs, upon return contains an NSError object that
        describes the problem.

 @return Whether the application was successful.
 */
- (BOOL)applyTo:(id)applicant error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
