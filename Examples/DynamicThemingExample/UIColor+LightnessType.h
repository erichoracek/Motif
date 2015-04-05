//
//  UIColor+LightnessType.h
//  DynamicThemesExample
//
//  Created by Eric Horacek on 1/2/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AUTLightnessType) {
    AUTLightnessTypeLight,
    AUTLightnessTypeDark
};

@interface UIColor (lightnessType)

- (AUTLightnessType)aut_lightnessType;

@end
