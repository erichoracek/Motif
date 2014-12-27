//
//  AUTPointFromStringTransformer.m
//  Pods
//
//  Created by Eric Horacek on 12/25/14.
//
//

#import "AUTPointFromStringTransformer.h"

NSString * const AUTPointFromStringTransformerName = @"AUTPointFromStringTransformer";

@implementation AUTPointFromStringTransformer

#pragma mark - NSObject

+ (void)load
{
    [NSValueTransformer setValueTransformer:[[self class] new] forName:AUTPointFromStringTransformerName];
}

#pragma mark - NSValueTransformer

+ (Class)transformedValueClass
{
    return [NSValue class];
}

- (NSValue *)transformedValue:(NSString *)value
{
    NSParameterAssert(value);
    NSAssert([value isKindOfClass:[self inputValueClass]], @"Input value to '%@' must be of type '%@'", NSStringFromClass([self class]), NSStringFromClass([self inputValueClass]));
    return [NSValue valueWithCGPoint:CGPointFromString(value)];
}

- (NSString *)reverseTransformedValue:(NSValue *)value
{
    return NSStringFromCGPoint([value CGPointValue]);
}

#pragma mark - AUTPointFromStringTransformer

- (Class)inputValueClass
{
    return [NSString class];
}

@end
