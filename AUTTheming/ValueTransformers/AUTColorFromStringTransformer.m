//
//  AUTColorFromStringTransformer.m
//  AUTTheming
//
//  Created by Eric Horacek on 12/23/14.
//
//

#import <UIColor-HTMLColors/UIColor+HTMLColors.h>
#import "AUTColorFromStringTransformer.h"

NSString * const AUTColorFromStringTransformerName = @"AUTColorFromStringTransformer";

@implementation AUTColorFromStringTransformer

#pragma mark - NSObject

+ (void)load
{
    [NSValueTransformer setValueTransformer:[[self class] new] forName:AUTColorFromStringTransformerName];
}

#pragma mark - NSValueTransformer

+ (Class)transformedValueClass
{
    return [UIColor class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (UIColor *)transformedValue:(NSString *)value
{
    NSParameterAssert(value);
    NSAssert([value isKindOfClass:[self inputValueClass]], @"Input value to '%@' must be of type '%@'", NSStringFromClass([self class]), NSStringFromClass([self inputValueClass]));
    UIColor *color = [UIColor colorWithCSS:value];
    NSAssert(color, @"Unable to transform color from input value %@", color);
    return color;
}

#pragma mark - AUTColorFromStringTransformer

- (Class)inputValueClass
{
    return [NSString class];
}

@end
