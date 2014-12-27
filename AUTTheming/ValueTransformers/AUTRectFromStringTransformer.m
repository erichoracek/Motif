//
//  AUTRectFromStringTransformer.m
//  Pods
//
//  Created by Eric Horacek on 12/25/14.
//
//

#import "AUTRectFromStringTransformer.h"

NSString * const AUTRectFromStringTransformerName = @"AUTRectFromStringTransformer";

@implementation AUTRectFromStringTransformer

#pragma mark - NSObject

+ (void)load
{
    [NSValueTransformer setValueTransformer:[[self class] new] forName:AUTRectFromStringTransformerName];
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
    return [NSValue valueWithCGRect:CGRectFromString(value)];
}

- (NSString *)reverseTransformedValue:(NSValue *)value
{
    return NSStringFromCGRect([value CGRectValue]);
}

#pragma mark - AUTRectFromStringTransformer

- (Class)inputValueClass
{
    return [NSString class];
}

@end
