//
//  MTFThemeConstant.m
//  Motif
//
//  Created by Eric Horacek on 12/24/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "MTFThemeConstant.h"
#import "MTFThemeConstant_Private.h"

@implementation MTFThemeConstant

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:self.class]) {
        return NO;
    }
    return [self isEqualToThemeConstant:object];
}

- (NSUInteger)hash {
    return (self.name.hash ^ [self.rawValue hash] ^ [self.mappedValue hash]);
}

- (NSString *)description {
    return [NSString stringWithFormat:
        @"%@ {%@: %@, %@: %@, %@: %@, %@: %@}",
        NSStringFromClass(self.class),
        NSStringFromSelector(@selector(name)), self.name,
        NSStringFromSelector(@selector(rawValue)), self.rawValue,
        NSStringFromSelector(@selector(mappedValue)), self.mappedValue,
        NSStringFromSelector(@selector(value)), self.value];
}

#pragma mark - MTFThemeConstant

#pragma mark Public

@dynamic value;

- (id)value {
    // If the mapped value is a reference to another constant, return that
    // constant's value
    if ([self.mappedValue isKindOfClass:MTFThemeConstant.class]) {
        MTFThemeConstant *mappedConstant = (MTFThemeConstant *)self.mappedValue;
        return mappedConstant.value;
    }
    // Otherwise, return either the mapped value or the raw value, in that
    // order.
    return (self.mappedValue ?: self.rawValue);
}

#pragma mark Private

- (instancetype)initWithName:(NSString *)name rawValue:(id)rawValue mappedValue:(mtf_nullable id)mappedValue {
    NSParameterAssert(name);
    NSParameterAssert(rawValue);
    self = [super init];
    if (self) {
        _name = name;
        _rawValue = rawValue;
        _mappedValue = mappedValue;
    }
    return self;
}

#pragma mark Value Transformation

- (NSCache *)transformedValueCache {
    if (!_transformedValueCache) {
        self.transformedValueCache = [NSCache new];
    }
    return _transformedValueCache;
}

- (id)transformedValueFromTransformerWithName:(NSString *)name {
    NSParameterAssert(name);
    
    id cachedValue = [self.transformedValueCache objectForKey:name];
    if (cachedValue) {
        return cachedValue;
    }
    
    NSValueTransformer *transformer = [NSValueTransformer
        valueTransformerForName:name];
    
    if (transformer) {
        id transformedValue = [transformer transformedValue:self.value];
        [self.transformedValueCache setObject:transformedValue forKey:name];
        return transformedValue;
    }
    
    return self.value;
}

#pragma mark Equality

- (BOOL)isEqualToThemeConstant:(MTFThemeConstant *)themeConstant {
    if (!themeConstant) {
        return NO;
    }
    BOOL haveEqualNames = (
        (!self.name && !themeConstant.name)
        || [self.name isEqualToString:themeConstant.name]
    );
    BOOL haveEqualRawValues = (
        (!self.rawValue && !themeConstant.rawValue)
        || [self.rawValue isEqual:themeConstant.rawValue]
    );
    BOOL haveEqualMappedValues = (
        (!self.mappedValue && !themeConstant.mappedValue)
        || [self.mappedValue isEqual:themeConstant.mappedValue]
    );
    return (
        haveEqualNames
        && haveEqualRawValues
        && haveEqualMappedValues
    );
}

@end
