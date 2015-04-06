//
//  MTFRectFromStringTransformer.m
//  Motif
//
//  Created by Eric Horacek on 12/25/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTFEdgeInsetsFromStringTransformer.h"

NSString * const MTFEdgeInsetsFromStringTransformerName = @"MTFEdgeInsetsFromStringTransformer";

@implementation MTFEdgeInsetsFromStringTransformer

#pragma mark - NSObject

+ (void)load {
    [self
        setValueTransformer:[self new]
        forName:MTFEdgeInsetsFromStringTransformerName];
}

#pragma mark - NSValueTransformer

+ (Class)transformedValueClass {
    return NSValue.class;
}

- (NSValue *)transformedValue:(NSString *)value {
    NSParameterAssert(value);
    
    __unused Class reverseTransformedValueClass = [self.class
        reverseTransformedValueClass];
    NSAssert(
        [value isKindOfClass:reverseTransformedValueClass],
        @"Input value to '%@' must be of type '%@'",
        NSStringFromClass(self.class),
        NSStringFromClass(reverseTransformedValueClass));
    
    return [NSValue valueWithUIEdgeInsets:UIEdgeInsetsFromString(value)];
}

- (NSString *)reverseTransformedValue:(NSValue *)value {
    return NSStringFromUIEdgeInsets([value UIEdgeInsetsValue]);
}

#pragma mark - MTFEdgeInsetsFromStringTransformer <MTFReverseTransformedValueClass>

+ (Class)reverseTransformedValueClass {
    return NSString.class;
}

#pragma mark - MTFEdgeInsetsFromStringTransformer <MTFObjCTypeValueTransformer>

+ (const char *)transformedValueObjCType {
    return @encode(UIEdgeInsets);
}

@end
