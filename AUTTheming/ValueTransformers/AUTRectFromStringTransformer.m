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

+ (void)load {
    [self
        setValueTransformer:[self new]
        forName:AUTRectFromStringTransformerName];
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
    
    return [NSValue valueWithCGRect:CGRectFromString(value)];
}

- (NSString *)reverseTransformedValue:(NSValue *)value {
    return NSStringFromCGRect([value CGRectValue]);
}

#pragma mark - AUTEdgeInsetsFromStringTransformer <AUTReverseTransformedValueClass>

+ (Class)reverseTransformedValueClass {
    return NSString.class;
}

#pragma mark - AUTEdgeInsetsFromStringTransformer <AUTObjCTypeValueTransformer>

+ (const char *)transformedValueObjCType {
    return @encode(CGRect);
}

@end
