//
//  AUTSizeFromStringTransformer.m
//  Pods
//
//  Created by Eric Horacek on 12/26/14.
//
//

#import <UIKit/UIKit.h>
#import "AUTSizeFromStringTransformer.h"

NSString * const AUTSizeFromStringTransformerName = @"AUTSizeFromStringTransformer";

@implementation AUTSizeFromStringTransformer

#pragma mark - NSObject

+ (void)load {
    [self
        setValueTransformer:[self new]
        forName:AUTSizeFromStringTransformerName];
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
    
    return [NSValue valueWithCGSize:CGSizeFromString(value)];
}

- (NSString *)reverseTransformedValue:(NSValue *)value {
    return NSStringFromCGSize([value CGSizeValue]);
}

#pragma mark - AUTEdgeInsetsFromStringTransformer <AUTReverseTransformedValueClass>

+ (Class)reverseTransformedValueClass {
    return NSString.class;
}

#pragma mark - AUTEdgeInsetsFromStringTransformer <AUTObjCTypeValueTransformer>

+ (const char *)transformedValueObjCType {
    return @encode(CGSize);
}

@end
