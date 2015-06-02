//
//  MTFObjCTypeValueTransformer.h
//  Motif
//
//  Created by Eric Horacek on 3/9/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Implemented by NSValueTransformers to specify that their transformed value will
 be an NSValue-wrapped type of a certain value, such as UIEdgeInsets or CGPoint.
 */
@protocol MTFObjCTypeValueTransformer <NSObject>

/**
 The Obj-C type of object that this value transformer will return by invoking 
 its transformedValue: method, as contained within an NSValue instance.
 
 This is the same value that's returned when using the encode directive, e.g.
 @encode(UIEdgeInsets).
 */
+ (const char *)transformedValueObjCType;

@end

NS_ASSUME_NONNULL_END
