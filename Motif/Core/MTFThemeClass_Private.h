//
//  MTFThemeClass_Private.h
//  Motif
//
//  Created by Eric Horacek on 12/24/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Motif/MTFThemeClass.h>

MTF_NS_ASSUME_NONNULL_BEGIN

@interface MTFThemeClass ()

/**
 Designated initializer for MTFThemeClass
 */
- (instancetype)initWithName:(NSString *)name propertiesConstants:(NSDictionary *)propertiesConstants NS_DESIGNATED_INITIALIZER;

/**
 The property constants for this specific theme class, keyed by constants.
 */
@property (nonatomic) NSDictionary *propertiesConstants;

/**
 The resolved property constants across all superclasses.
 */
@property (nonatomic, readonly) NSDictionary *resolvedPropertiesConstants;

@end

MTF_NS_ASSUME_NONNULL_END
