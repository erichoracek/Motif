//
//  AUTRectFromStringTransformer.m
//  Pods
//
//  Created by Eric Horacek on 12/25/14.
//
//

#import "AUTEdgeInsetsFromStringTransformer.h"

NSString * const AUTEdgeInsetsFromStringTransformerName = @"AUTEdgeInsetsFromStringTransformer";

@implementation AUTEdgeInsetsFromStringTransformer

#pragma mark - NSObject

+ (void)load
{
    [NSValueTransformer setValueTransformer:[[self class] new] forName:AUTEdgeInsetsFromStringTransformerName];
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
    return [NSValue valueWithUIEdgeInsets:UIEdgeInsetsFromString(value)];
}

- (NSString *)reverseTransformedValue:(NSValue *)value
{
    return NSStringFromUIEdgeInsets([value UIEdgeInsetsValue]);
}

#pragma mark - AUTEdgeInsetsFromStringTransformer

- (Class)inputValueClass
{
    return [NSString class];
}

@end
