//
//  AUTObjCTypeValueTransformer.h
//  Pods
//
//  Created by Eric Horacek on 3/9/15.
//
//

#import <Foundation/Foundation.h>

@protocol AUTObjCTypeValueTransformer <NSObject>

+ (const char *)transformedValueObjCType;

@end
