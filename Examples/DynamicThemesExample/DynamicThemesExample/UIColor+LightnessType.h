//
//  UIColor+LightnessType.h
//  DynamicThemesExample
//
//  Created by Eric Horacek on 1/2/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LightnessType) {
    LightnessTypeLight,
    LightnessTypeDark
};

@interface UIColor (lightnessType)

- (LightnessType)lightnessType;

@end
