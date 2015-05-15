//
//  NSValueTransformer+ValueTransformerRegistration.m
//  Motif
//
//  Created by Eric Horacek on 5/14/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <objc/runtime.h>

#import "MTFReverseTransformedValueClass.h"
#import "MTFObjCTypeValueTransformer.h"

#import "NSValueTransformer+ValueTransformerRegistration.h"

MTF_NS_ASSUME_NONNULL_BEGIN

@implementation NSValueTransformer (ValueTransformerRegistration)

+ (BOOL)mtf_registerValueTransformerWithName:(NSString *)name transformedValueObjCType:(const char *)transformedValueObjCType reverseTransformedValueClass:(Class)reverseTransformedValueClass returningTransformedValueWithBlock:(id (^)(id value))transformedValueBlock {
    NSParameterAssert(transformedValueObjCType != NULL);

    return [self
        mtf_registerValueTransformerWithName:name
        transformedValueClass:NSValue.class
        reverseTransformedValueClass:reverseTransformedValueClass
        transformedValueObjCType:transformedValueObjCType
        returningTransformedValueWithBlock:transformedValueBlock];
}

+ (BOOL)mtf_registerValueTransformerWithName:(NSString *)name transformedValueClass:(Class)transformedValueClass reverseTransformedValueClass:(Class)reverseTransformedValueClass returningTransformedValueWithBlock:(id (^)(id value))transformedValueBlock {
    return [self
        mtf_registerValueTransformerWithName:name
        transformedValueClass:transformedValueClass
        reverseTransformedValueClass:reverseTransformedValueClass
        transformedValueObjCType:NULL
        returningTransformedValueWithBlock:transformedValueBlock];
}

+ (BOOL)mtf_registerValueTransformerWithName:(NSString *)name transformedValueClass:(Class)transformedValueClass reverseTransformedValueClass:(Class)reverseTransformedValueClass transformedValueObjCType:(mtf_nullable const char *)transformedValueObjCType returningTransformedValueWithBlock:(id (^)(id value))transformedValueBlock {
    NSParameterAssert(name != nil);
    NSParameterAssert(transformedValueClass != nil);
    NSParameterAssert(reverseTransformedValueClass != nil);
    NSParameterAssert(transformedValueBlock != nil);

    // Do not allow names that are identical to an existing Objective-C class
    if (objc_lookUpClass(name.UTF8String) != Nil) return NO;

    // Do not allow repeat registrations
    if ([NSValueTransformer valueTransformerForName:name] != nil) return NO;

    Class class = objc_allocateClassPair(
        NSValueTransformer.class,
        name.UTF8String,
        0);

    if (!class) {
        return NO;
    }

    // Override transformedValue instance method
    SEL transformedValueSelector = @selector(transformedValue:);

    IMP transformedValueImplementation = imp_implementationWithBlock(^id (id __unused _, id value){
        NSAssert(
            [value isKindOfClass:reverseTransformedValueClass],
            @"Input value to '%@' must be of class '%@' for value transformer"
                 "named '%@'",
            NSStringFromClass(self.class),
            NSStringFromClass(reverseTransformedValueClass),
            name);

        id transformedValue = transformedValueBlock(value);

        NSAssert(
            transformedValue != nil,
            @"Unable to transform '%@' from input value '%@' for value "
                "transformer %@",
            transformedValueClass,
            value,
            name);

        return transformedValue;
    });

    Method transformedValueMethod = class_getInstanceMethod(
        class,
        transformedValueSelector);

    class_replaceMethod(
        class,
        transformedValueSelector,
        transformedValueImplementation,
        method_getTypeEncoding(transformedValueMethod));

    objc_registerClassPair(class);

    // The metaclass is only able to be queried after the class pair is
    // registered with the runtime
    Class metaClass = objc_getMetaClass(name.UTF8String);

    // Override transformedValueClass class method
    SEL transformedValueClassSelector = @selector(transformedValueClass);

    IMP transformedValueClassImplementation = imp_implementationWithBlock(^Class {
        return transformedValueClass;
    });

    Method transformedValueClassMethod = class_getClassMethod(
        metaClass,
        transformedValueClassSelector);

    class_replaceMethod(
        metaClass,
        transformedValueClassSelector,
        transformedValueClassImplementation,
        method_getTypeEncoding(transformedValueClassMethod));

    __unused BOOL addReverseTransformedValueClassSuccess = class_addProtocol(
        class,
        @protocol(MTFReverseTransformedValueClass));

    NSAssert(
        addReverseTransformedValueClassSuccess,
        @"Failed to add protocol %@",
        @protocol(MTFReverseTransformedValueClass));

    // Add reverseTransformedValueClass class method from the
    // MTFReverseTransformedValueClass protocol
    SEL reverseTransformedValueClassSelector = @selector(reverseTransformedValueClass);

    IMP reverseTransformedValueClassImplementation = imp_implementationWithBlock(^Class {
        return reverseTransformedValueClass;
    });

    NSString *type = [NSString stringWithFormat:@"%s@:", @encode(Class)];

    __unused BOOL reverseTransformedValueClassSuccess = class_addMethod(
        metaClass,
        reverseTransformedValueClassSelector,
        reverseTransformedValueClassImplementation,
        type.UTF8String);

    NSAssert(
        reverseTransformedValueClassSuccess,
        @"Failed to add method %@",
        NSStringFromSelector(reverseTransformedValueClassSelector));

    // If there is an ObjC type specified, add that it is the output value
    // as per MTFObjCTypeValueTransformer
    if (transformedValueObjCType != NULL) {
        __unused BOOL addObjCTypeValueTransformerSuccess = class_addProtocol(
            class,
            @protocol(MTFObjCTypeValueTransformer));

        NSAssert(
            addObjCTypeValueTransformerSuccess,
            @"Failed to add protocol %@",
            @protocol(MTFObjCTypeValueTransformer));

        SEL transformedValueObjCTypeSelector = @selector(transformedValueObjCType);

        IMP transformedValueObjCTypeImplementation = imp_implementationWithBlock(^const char * {
            return transformedValueObjCType;
        });

        NSString *type = [NSString stringWithFormat:@"%s@:", @encode(const char *)];

        __unused BOOL transformedValueObjCTypeSuccessful = class_addMethod(
            metaClass,
            transformedValueObjCTypeSelector,
            transformedValueObjCTypeImplementation,
            type.UTF8String);

        NSAssert(
            transformedValueObjCTypeSuccessful,
            @"Failed to add method %@",
            NSStringFromSelector(transformedValueObjCTypeSelector));
    }

    NSValueTransformer *valueTransformer = [[class alloc] init];
    [self setValueTransformer:valueTransformer forName:name];

    return YES;
}

@end

MTF_NS_ASSUME_NONNULL_END
