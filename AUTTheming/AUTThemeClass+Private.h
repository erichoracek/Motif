//
//  AUTThemeClass+Private.h
//  AUTTheming
//
//  Created by Eric Horacek on 12/24/14.
//
//

#import "AUTThemeClass.h"

@interface AUTThemeClass ()

- (instancetype)initWithName:(NSString *)name propertiesConstants:(NSDictionary *)propertiesConstants;

/**
 Readwrite verison of public name property.
 */
@property (nonatomic) NSString *name;

/**
 The property constants for this specific theme class, keyed by constants.
 */
@property (nonatomic) NSDictionary *propertiesConstants;

/**
 The resolved property constants across all superclasses.
 */
@property (nonatomic, readonly) NSDictionary *resolvedPropertiesConstants;

@end
