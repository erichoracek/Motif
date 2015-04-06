//
//  MTFColorFromStringTransformer.m
//  Motif
//
//  Created by Eric Horacek on 12/23/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "UIColor+HTMLColors.h"
#import "MTFColorFromStringTransformer.h"

NSString * const MTFColorFromStringTransformerName = @"MTFColorFromStringTransformer";

@implementation MTFColorFromStringTransformer

#pragma mark - NSObject

+ (void)load {
    [self
        setValueTransformer:[self new]
        forName:MTFColorFromStringTransformerName];
}

#pragma mark - NSValueTransformer

+ (Class)transformedValueClass {
    return UIColor.class;
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (UIColor *)transformedValue:(NSString *)value {
    NSParameterAssert(value);
    
    __unused Class reverseTransformedValueClass = [self.class
        reverseTransformedValueClass];
    
    NSAssert(
        [value isKindOfClass:reverseTransformedValueClass],
        @"Input value to '%@' must be of type '%@'",
        NSStringFromClass(self.class),
        NSStringFromClass(reverseTransformedValueClass));
    
    UIColor *color = [UIColor mtf_colorWithCSS:value];
    NSAssert(
        color,
        @"Unable to transform color from input value '%@' (%@)",
        value,
        value.class);
    
    return color;
}

#pragma mark - MTFColorFromStringTransformer <MTFReverseTransformedValueClass>

+ (Class)reverseTransformedValueClass {
    return NSString.class;
}

@end
