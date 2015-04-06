//
//  MTFPointFromStringTransformer.m
//  Motif
//
//  Created by Eric Horacek on 12/25/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTFPointFromStringTransformer.h"

NSString * const MTFPointFromStringTransformerName = @"MTFPointFromStringTransformer";

@implementation MTFPointFromStringTransformer

#pragma mark - NSObject

+ (void)load {
    [self
        setValueTransformer:[self new]
        forName:MTFPointFromStringTransformerName];
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
    
    return [NSValue valueWithCGPoint:CGPointFromString(value)];
}

- (NSString *)reverseTransformedValue:(NSValue *)value {
    return NSStringFromCGPoint([value CGPointValue]);
}

#pragma mark - MTFEdgeInsetsFromStringTransformer <MTFReverseTransformedValueClass>

+ (Class)reverseTransformedValueClass {
    return NSString.class;
}

#pragma mark - MTFEdgeInsetsFromStringTransformer <MTFObjCTypeValueTransformer>

+ (const char *)transformedValueObjCType {
    return @encode(CGPoint);
}

@end
