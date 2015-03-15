//
//  AUTThemeClass_Private.h
//  AUTTheming
//
//  Created by Eric Horacek on 12/24/14.
//
//

#import "AUTThemeClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface AUTThemeClass ()

/**
 Designated initializer for AUTThemeClass
 */
- (instancetype)initWithName:(NSString *)name propertiesConstants:(NSDictionary *)propertiesConstants NS_DESIGNATED_INITIALIZER;

/**
 Readwrite verison of the public name property.
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

NS_ASSUME_NONNULL_END
