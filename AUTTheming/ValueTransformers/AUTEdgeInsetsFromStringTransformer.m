//
//  AUTRectFromStringTransformer.m
//  Pods
//
//  Created by Eric Horacek on 12/25/14.
//
//

#import <UIKit/UIKit.h>
#import "AUTEdgeInsetsFromStringTransformer.h"

NSString * const AUTEdgeInsetsFromStringTransformerName = @"AUTEdgeInsetsFromStringTransformer";

@implementation AUTEdgeInsetsFromStringTransformer

#pragma mark - NSObject

+ (void)load {
    [self
        setValueTransformer:[self new]
        forName:AUTEdgeInsetsFromStringTransformerName];
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

#pragma mark - AUTEdgeInsetsFromStringTransformer <AUTReverseTransformedValueClass>

+ (Class)reverseTransformedValueClass {
    return NSString.class;
}

#pragma mark - AUTEdgeInsetsFromStringTransformer <AUTObjCTypeValueTransformer>

+ (const char *)transformedValueObjCType {
    return @encode(UIEdgeInsets);
}

@end
