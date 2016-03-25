//
//  MTFThemeConstant.m
//  Motif
//
//  Created by Eric Horacek on 12/24/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "MTFValueTransformerErrorHandling.h"
#import "MTFErrors.h"

#import "MTFThemeConstant_Private.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MTFThemeConstant

#pragma mark - Lifecycle

- (instancetype)initWithName:(NSString *)name rawValue:(id)rawValue referencedValue:(nullable id)referencedValue {
    NSParameterAssert(name != nil);
    NSParameterAssert(rawValue != nil);

    self = [super init];

    _name = [name copy];
    _rawValue = rawValue;
    _referencedValue = referencedValue;
    _transformedValueCache = [[NSCache alloc] init];
    
    return self;
}

#pragma mark - MTFThemeConstant

#pragma mark Public

- (id)value {
    return self.referencedValue ?: self.rawValue;
}

#pragma mark Private

#pragma mark Value Transformation

- (nullable id)transformedValueFromTransformer:(NSValueTransformer *)valueTransformer error:(NSError **)error {
    NSParameterAssert(valueTransformer != nil);

    NSString *key = NSStringFromClass(valueTransformer.class);

    id cachedValue = [self.transformedValueCache objectForKey:key];
    if (cachedValue != nil) return cachedValue;

    id transformedValue;
    NSError *valueTransformationError;
    if ([valueTransformer conformsToProtocol:@protocol(MTFValueTransformerErrorHandling)]) {
        NSValueTransformer<MTFValueTransformerErrorHandling> *errorHandlingValueTransformer = (id<MTFValueTransformerErrorHandling>)valueTransformer;
        transformedValue = [errorHandlingValueTransformer transformedValue:self.value error:&valueTransformationError];
    } else {
        transformedValue = [valueTransformer transformedValue:self.value];
    }

    if (transformedValue == nil) {
        if (error == NULL) return nil;

        NSString *description = [NSString stringWithFormat:
            @"Failed to transform value from %@: %@ using %@",
            self.name,
            self.value,
            valueTransformer];

        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:@{
            NSLocalizedDescriptionKey: description,
        }];

        userInfo[NSUnderlyingErrorKey] = valueTransformationError;

        *error = [NSError
            errorWithDomain:MTFErrorDomain
            code:MTFErrorFailedToApplyTheme
            userInfo:[userInfo copy]];

        return nil;
    }

    [self.transformedValueCache setObject:transformedValue forKey:key];

    return transformedValue;
}

#pragma mark Equality

- (BOOL)isEqualToThemeConstant:(MTFThemeConstant *)themeConstant {
    NSParameterAssert(themeConstant != nil);

    BOOL haveEqualNames = [self.name isEqualToString:themeConstant.name];
    BOOL haveEqualRawValues = [self.rawValue isEqual:themeConstant.rawValue];

    BOOL haveEqualReferencedValues = (
        (!self.referencedValue && !themeConstant.referencedValue)
        || [self.referencedValue isEqual:themeConstant.referencedValue]
    );

    return (haveEqualNames && haveEqualRawValues && haveEqualReferencedValues);
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;

    if (![object isKindOfClass:self.class]) return NO;

    return [self isEqualToThemeConstant:object];
}

- (NSUInteger)hash {
    return (self.name.hash ^ [self.rawValue hash] ^ [self.referencedValue hash]);
}

- (NSString *)description {
    return [NSString stringWithFormat:
        @"%@ {%@: %@, %@: %@, %@: %@, %@: %@}",
        NSStringFromClass(self.class),
        NSStringFromSelector(@selector(name)), self.name,
        NSStringFromSelector(@selector(rawValue)), self.rawValue,
        NSStringFromSelector(@selector(referencedValue)), self.referencedValue,
        NSStringFromSelector(@selector(value)), self.value];
}

@end

NS_ASSUME_NONNULL_END
