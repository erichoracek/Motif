//
//  MTFThemeClass_Private.h
//  Motif
//
//  Created by Eric Horacek on 12/24/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Motif/MTFThemeClass.h>

@class MTFThemeConstant;

NS_ASSUME_NONNULL_BEGIN

@interface MTFThemeClass ()

/**
 Designated initializer for MTFThemeClass
 */
- (instancetype)initWithName:(NSString *)name propertiesConstants:(NSDictionary<NSString *, MTFThemeConstant *> *)propertiesConstants NS_DESIGNATED_INITIALIZER;

/**
 The property constants for this specific theme class, keyed by constants.
 */
@property (nonatomic, copy) NSDictionary<NSString *, MTFThemeConstant *> *propertiesConstants;

/**
 The resolved property constants across all superclasses.
 */
@property (nonatomic, copy, readonly) NSDictionary<NSString *, MTFThemeConstant *> *resolvedPropertiesConstants;

@end

NS_ASSUME_NONNULL_END
