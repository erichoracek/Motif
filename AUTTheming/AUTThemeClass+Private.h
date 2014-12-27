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

@property (nonatomic) NSString *name;
@property (nonatomic) NSDictionary *propertiesConstants;

/**
 The resolved properties across all superclasses
 */
@property (nonatomic, readonly) NSDictionary *resolvedPropertiesConstants;

@end
