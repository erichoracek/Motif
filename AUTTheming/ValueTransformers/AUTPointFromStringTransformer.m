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
    __unused Class reverseTransformedValueClass = [[self class] reverseTransformedValueClass];
    NSAssert([value isKindOfClass:reverseTransformedValueClass], @"Input value to '%@' must be of type '%@'", NSStringFromClass([self class]), NSStringFromClass(reverseTransformedValueClass));
    return [NSValue valueWithCGPoint:CGPointFromString(value)];
}

- (NSString *)reverseTransformedValue:(NSValue *)value
{
    return NSStringFromCGPoint([value CGPointValue]);
}

#pragma mark - AUTEdgeInsetsFromStringTransformer <AUTReverseTransformedValueClass>

+ (Class)reverseTransformedValueClass
{
    return [NSString class];
}

#pragma mark - AUTEdgeInsetsFromStringTransformer <AUTObjCTypeValueTransformer>

+ (const char *)transformedValueObjCType
{
    return @encode(CGPoint);
}

@end
