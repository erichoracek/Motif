//
//  MTFDynamicThemeApplier.m
//  Motif
//
//  Created by Eric Horacek on 12/26/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <objc/runtime.h>
#import "MTFThemeClassApplicable.h"
#import "MTFThemeConstant.h"
#import "MTFThemeClass_Private.h"
#import "MTFReverseTransformedValueClass.h"

@implementation MTFThemeClassApplier

#pragma mark - NSObject

- (instancetype)init {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    // Ensure that exception is thrown when just `init` is called.
    self = [self initWithClassApplierBlock:nil];
#pragma clang diagnostic pop
    return self;
}

#pragma mark - MTFThemeClassApplier

- (instancetype)initWithClassApplierBlock:(MTFThemeClassApplierBlock)applierBlock {
    NSParameterAssert(applierBlock);
    self = [super init];
    if (self) {
        _applierBlock = applierBlock;
    }
    return self;
}

#pragma mark - MTFThemeClassApplier <MTFDynamicThemeApplier>

@dynamic properties;

- (NSArray *)properties {
    return @[];
}

- (void)applyClass:(MTFThemeClass *)class toObject:(id)object; {
    NSParameterAssert(class);
    NSParameterAssert(object);
    
    self.applierBlock(class, object);
}

- (BOOL)shouldApplyClass:(MTFThemeClass *)themeClass {
    NSParameterAssert(themeClass);
    
    return YES;
}

@end

@implementation MTFThemeClassPropertyApplier

#pragma mark - NSObject

- (instancetype)init {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    // Ensure that exception is thrown when just `init` is called.
    return [self
        initWithProperty:nil
        valueTransformerName:nil
        requiredClass:Nil
        applierBlock:nil];
#pragma clang diagnostic pop
}

#pragma mark - MTFThemePropertyApplier

- (instancetype)initWithProperty:(NSString *)property valueTransformerName:(NSString *)name requiredClass:(Class)class applierBlock:(MTFThemePropertyApplierBlock)applierBlock {
    NSParameterAssert(property);
    NSParameterAssert(applierBlock);
    
    self = [super init];
    if (self) {
        _property = property;
        _applierBlock = applierBlock;
        _valueTransformerName = name;
        _requiredClass = class;
    }
    return self;
}

+ (id)valueFromConstant:(MTFThemeConstant *)constant forProperty:(NSString *)property onObject:(id <NSObject>)object withRequiredClass:(Class)requiredClass valueTransformerName:(NSString *)valueTransformerName {
    NSAssert(constant, @"Constant must not be nil");
    id<NSObject> value = constant.value;
    
    // Enforce required class if necessary
    if (requiredClass) {
        BOOL isValueOfRequiredClass = [value isKindOfClass:requiredClass];
        if (!isValueOfRequiredClass) {
            __unused NSString *applierClassName = NSStringFromClass(object.class);
            __unused NSString *requiredClassName = NSStringFromClass(requiredClass);
            __unused NSString *valueClassName = NSStringFromClass(value.class);

            NSAssert(
                isValueOfRequiredClass,
                @"The theme applier on '%@' requires that the value for "
                    "property '%@' is of class '%@'. It is instead an instace "
                    "of '%@'.",
                applierClassName,
                property,
                requiredClassName,
                valueClassName);
        }
    }
    
    // Transform value if necessary
    if (valueTransformerName) {
        __unused NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:valueTransformerName];

        NSAssert(
            valueTransformer,
            @"There is no value transfomer registered for the name '%@'. "
                "Before applying a theme, you must first register a value "
                "transformer instance for the specified name.",
            valueTransformerName);

        id transformedValue = [constant transformedValueFromTransformerWithName:valueTransformerName];
        value = transformedValue;
    }
    
    return value;
}

#pragma mark - MTFThemePropertyApplier <MTFDynamicThemeApplier>

@dynamic properties;

- (NSArray *)properties {
    return @[self.property];
}

- (void)applyClass:(MTFThemeClass *)class toObject:(id)object; {
    NSParameterAssert(class);
    NSParameterAssert(object);
    
    MTFThemeConstant *constant = class.resolvedPropertiesConstants[self.property];
    
    id value = [self.class
        valueFromConstant:constant
        forProperty:self.property
        onObject:object
        withRequiredClass:self.requiredClass
        valueTransformerName:self.valueTransformerName];
    
    self.applierBlock(value, object);
}

- (BOOL)shouldApplyClass:(MTFThemeClass *)themeClass {
    NSParameterAssert(themeClass);

    return [self.class
        shouldApplyClass:themeClass
        forProperty:self.property
        requiredClass:self.requiredClass
        withValueTransformerName:self.valueTransformerName];
}

+ (BOOL)shouldApplyClass:(MTFThemeClass *)class forProperty:(NSString *)property requiredClass:(Class)requiredClass withValueTransformerName:(NSString *)valueTransformerName {
    NSParameterAssert(class);
    NSParameterAssert(property);

    id propertyValue = class.properties[property];

    // If there is neither a value transformer nor a required class, this class
    // can be applied our property exists in the required class dictionary
    if (valueTransformerName == nil && requiredClass == Nil) {
        return (propertyValue != nil);
    }
    // Otherwise, if we have a value transformer that implements
    // MTFReverseTransformedValueClass, check if it can transform this value
    else if (valueTransformerName != nil) {
        NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:valueTransformerName];

        NSAssert(
            transformer != nil,
            @"Unable to locate value transformer for with name '%@' for theme "
                "applier with property name '%@'.",
            valueTransformerName,
            property);

        if (![transformer conformsToProtocol:@protocol(MTFReverseTransformedValueClass)] && propertyValue) {
            return YES;
        }

        Class requiredValueClass = [((id<MTFReverseTransformedValueClass>)transformer).class reverseTransformedValueClass];

        return [propertyValue isKindOfClass:requiredValueClass];
    }
    else if (requiredClass != Nil) {
        return [propertyValue isKindOfClass:requiredClass];
    }

    return NO;
}

@end

@implementation MTFThemeClassPropertiesApplier

#pragma mark - NSObject

- (instancetype)init {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    // Ensure that exception is thrown when just `init` is called.
    return [self
        initWithProperties:nil
        valueTransformersOrRequiredClasses:nil
        applierBlock:nil];
#pragma clang diagnostic pop
}

#pragma mark - MTFThemeClassPropertiesApplier

- (instancetype)initWithProperties:(NSArray *)properties valueTransformersOrRequiredClasses:(NSArray *)valueTransformersOrRequiredClasses applierBlock:(MTFThemePropertiesApplierBlock)applierBlock {
    NSParameterAssert(properties);
    NSParameterAssert(applierBlock);
    
    self = [super init];
    if (self) {
        _properties = properties;
        _applierBlock = applierBlock;
        if (valueTransformersOrRequiredClasses) {
            NSAssert(
                properties.count == valueTransformersOrRequiredClasses.count,
                @"The `properties` array and the "
                     "`valueTransformersOrRequiredClasses` array must have the "
                     "same number of elements."
                );
        }
        _valueTransformersOrRequiredClasses = valueTransformersOrRequiredClasses;
    }
    return self;
}

- (Class)requiredClassForPropertyAtIndex:(NSUInteger)index {
    Class class = self.valueTransformersOrRequiredClasses[index];
    // Check for whether the passed object is of type `Class`
    if (class_isMetaClass(object_getClass(class))) {
        return class;
    }
    return nil;
}

- (NSString *)valueTransformerNameForPropertyAtIndex:(NSUInteger)index {
    NSString *name = self.valueTransformersOrRequiredClasses[index];
    if ([name isKindOfClass:NSString.class]) {
        return name;
    }
    return nil;
}

#pragma mark - MTFThemeClassPropertiesApplier <MTFThemeClassApplicable>

@synthesize properties = _properties;

- (void)applyClass:(MTFThemeClass *)class toObject:(id)object {
    NSParameterAssert(class);
    NSParameterAssert(object);
    
    NSMutableDictionary *valuesForProperties = [NSMutableDictionary new];
    
    [self.properties enumerateObjectsUsingBlock:^(
        NSString *property,
        NSUInteger propertyIndex,
        BOOL *_) {
            MTFThemeConstant *constant = class.resolvedPropertiesConstants[property];
        
            Class requiredClass = [self requiredClassForPropertyAtIndex:propertyIndex];

            NSString *valueTransformerName = [self valueTransformerNameForPropertyAtIndex:propertyIndex];
        
            id value = [MTFThemeClassPropertyApplier
                valueFromConstant:constant
                forProperty:property
                onObject:object
                withRequiredClass:requiredClass
                valueTransformerName:valueTransformerName];

            valuesForProperties[property] = value;
        }];
    
    self.applierBlock([valuesForProperties copy], object);
}

- (BOOL)shouldApplyClass:(MTFThemeClass *)themeClass {
    NSParameterAssert(themeClass);

    NSSet *applierProperties = [NSSet setWithArray:self.properties];

    // Build a list of the applier properties that intersects with the class
    // properties that is being queried to apply
    NSMutableSet *propertiesIntersection = [NSMutableSet setWithArray:themeClass.properties.allKeys];
    [propertiesIntersection intersectSet:applierProperties];

    // If the intersection doesn't have the same number of entries as the
    // applier has properties, do not apply, since a
    // MTFThemeClassPropertiesApplier only applies when all its properties
    // are present
    if (propertiesIntersection.count != self.properties.count) {
        return NO;
    }

    for (NSInteger index = 0; index < (NSInteger)self.properties.count; index++) {
        Class requiredClass = [self requiredClassForPropertyAtIndex:index];
        NSString *valueTransformerName = [self valueTransformerNameForPropertyAtIndex:index];

        BOOL shouldApplyClass = [MTFThemeClassPropertyApplier
            shouldApplyClass:themeClass
            forProperty:self.properties[index]
            requiredClass:requiredClass
            withValueTransformerName:valueTransformerName];

        if (!shouldApplyClass) {
            return NO;
        }
    }

    return YES;
}

@end
