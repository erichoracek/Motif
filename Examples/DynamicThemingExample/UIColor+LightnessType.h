//
//  UIColor+LightnessType.h
//  DynamicThemesExample
//
//  Created by Eric Horacek on 1/2/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MTFLightnessType) {
    MTFLightnessTypeLight,
    MTFLightnessTypeDark
};

@interface UIColor (lightnessType)

@property (nonatomic, readonly) MTFLightnessType mtf_lightnessType;

@end
