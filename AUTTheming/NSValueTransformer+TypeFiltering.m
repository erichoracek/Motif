//
//  NSValueTransformer+TypeFiltering.m
//  Pods
//
//  Created by Eric Horacek on 3/9/15.
//
//

#import "NSValueTransformer+TypeFiltering.h"
#import "AUTReverseTransformedValueClass.h"
#import "AUTObjCTypeValueTransformer.h"

@implementation NSValueTransformer (TypeFiltering)

+ (NSValueTransformer *)aut_valueTransformerForTransformingObject:(id)object toObjCType:(const char *)objCType
{
    NSParameterAssert(object);
    
    if (objCType == NULL) {
        return nil;
    }
    
    for (NSString *valueTransformerName in [NSValueTransformer valueTransformerNames]) {
        NSValueTransformer *valueTransfomerForName = [NSValueTransformer valueTransformerForName:valueTransformerName];
        if ([valueTransfomerForName conformsToProtocol:@protocol(AUTObjCTypeValueTransformer)]
            && [valueTransfomerForName conformsToProtocol:@protocol(AUTReverseTransformedValueClass)]
        ) {
            NSValueTransformer <AUTObjCTypeValueTransformer, AUTReverseTransformedValueClass> *valueTransformer = (id)valueTransfomerForName;
            Class reverseTransformedValueClass = [[valueTransformer class] reverseTransformedValueClass];
            const char * transformedValueObjCType = [[valueTransformer class] transformedValueObjCType];
            if ([object isKindOfClass:reverseTransformedValueClass]
                && (strcmp(transformedValueObjCType, objCType) == 0)
            ) {
                return valueTransformer;
            }
        }
    }
    return nil;
}

+ (NSValueTransformer *)aut_valueTransformerForTransformingObject:(id)object toClass:(Class)class
{
    NSParameterAssert(object);
    
    if (class == Nil) {
        return nil;
    }
    
    for (NSString *valueTransformerName in [NSValueTransformer valueTransformerNames]) {
        NSValueTransformer *valueTransfomerForName = [NSValueTransformer valueTransformerForName:valueTransformerName];
        if ([valueTransfomerForName conformsToProtocol:@protocol(AUTReverseTransformedValueClass)]) {
            NSValueTransformer <AUTReverseTransformedValueClass> *valueTransformer = (id)valueTransfomerForName;
            Class reverseTransformedValueClass = [[valueTransformer class] reverseTransformedValueClass];
            Class transformedValueClass = [[valueTransformer class] transformedValueClass];
            if ([object isKindOfClass:reverseTransformedValueClass]
                && class == transformedValueClass
            ) {
                return valueTransformer;
            }
        }
    }
    return nil;
}

@end
