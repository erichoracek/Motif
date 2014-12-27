//
//  AUTThemeClass.h
//  AUTTheming
//
//  Created by Eric Horacek on 12/22/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AUTTheme;

@interface AUTThemeClass : NSObject

/**
 The name of the theme class, as specified in the JSON theme file.
 */
@property (nonatomic, readonly) NSString *name;

@property (nonatomic, readonly) NSDictionary *properties;

@end
