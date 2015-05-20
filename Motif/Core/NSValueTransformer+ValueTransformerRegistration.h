//
//  NSValueTransformer+ValueTransformerRegistration.h
//  Motif
//
//  Created by Eric Horacek on 5/14/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Motif/MTFBackwardsCompatableNullability.h>

MTF_NS_ASSUME_NONNULL_BEGIN

/**
 Shorthand for quickly registering value transformer instances.
 */
@interface NSValueTransformer (ValueTransformerRegistration)

/**
 Creates and registers a value transformer class and instance for transforming
 a class to an NSValue-wrapped ObjC type.

 @param name                         The name of the value transformer instance,
                                     used to query for this instance via
                                     valueTransformerForName:.
 @param transformedValueObjCType     The ObjC type that the value transformer
                                     is responsible for transforming its values
                                     to, as wrapped within an NSValue. Should
                                     be the value returned by the @encode
                                     directive.
 @param reverseTransformedValueClass The class that the value transformer is
                                     expecting as its input to transformValue:
 @param transformedValueBlock        The block that is used as the
                                     implementation of the transformValue:
                                     method.

 @return Whether the value transformer was successfully registered.
 */
+ (BOOL)mtf_registerValueTransformerWithName:(NSString *)name transformedValueObjCType:(const char *)transformedValueObjCType reverseTransformedValueClass:(Class)reverseTransformedValueClass returningTransformedValueWithBlock:(id (^)(id value))transformedValueBlock;

/**
 Creates and registers a value transformer class and instance for transforming
 a class to another class.

 @param name                         The name of the value transformer instance,
                                     used to query for this instance via
                                     valueTransformerForName:.
 @param transformedValueClass        The class that the value transformer will
                                     produce an instance of when transformValue:
                                     is invoked.
 @param reverseTransformedValueClass The class that the value transformer is
                                     expecting as its input to transformValue:
 @param transformedValueBlock        The block that is used as the
                                     implementation of the transformValue:
                                     method.

 @return Whether the value transformer was successfully registered.
 */
+ (BOOL)mtf_registerValueTransformerWithName:(NSString *)name transformedValueClass:(Class)transformedValueClass reverseTransformedValueClass:(Class)reverseTransformedValueClass returningTransformedValueWithBlock:(id (^)(id value))transformedValueBlock;

@end

MTF_NS_ASSUME_NONNULL_END
