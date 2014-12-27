//
//  AUTSizeFromStringTransformer.m
//  Pods
//
//  Created by Eric Horacek on 12/26/14.
//
//

#import "AUTSizeFromStringTransformer.h"

NSString * const AUTSizeFromStringTransformerName = @"AUTSizeFromStringTransformer";

@implementation AUTSizeFromStringTransformer

#pragma mark - NSObject

+ (void)load
{
    [NSValueTransformer setValueTransformer:[[self class] new] forName:AUTSizeFromStringTransformerName];
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
    return [NSValue valueWithCGSize:CGSizeFromString(value)];
}

- (NSString *)reverseTransformedValue:(NSValue *)value
{
    return NSStringFromCGSize([value CGSizeValue]);
}

#pragma mark - AUTSizeFromStringTransformer

- (Class)inputValueClass
{
    return [NSString class];
}

@end
