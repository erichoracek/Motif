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

+ (void)load {
    [self
        setValueTransformer:[self new]
        forName:AUTColorFromStringTransformerName];
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
    
    UIColor *color = [UIColor colorWithCSS:value];
    NSAssert(
        color,
        @"Unable to transform color from input value '%@' (%@)",
        value,
        value.class);
    
    return color;
}

#pragma mark - AUTColorFromStringTransformer <AUTReverseTransformedValueClass>

+ (Class)reverseTransformedValueClass {
    return NSString.class;
}

@end
