//
//  NSValueTransformer+TypeFiltering.m
//  Motif
//
//  Created by Eric Horacek on 3/9/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "NSValueTransformer+TypeFiltering.h"
#import "MTFReverseTransformedValueClass.h"
#import "MTFObjCTypeValueTransformer.h"

@implementation NSValueTransformer (TypeFiltering)

+ (NSValueTransformer *)mtf_valueTransformerForTransformingObject:(id)object toObjCType:(const char *)objCType {
    NSParameterAssert(object);
    
    if (objCType == NULL) {
        return nil;
    }
    
    NSArray<NSString *> *valueTransformerNames = NSValueTransformer.valueTransformerNames;
    
    for (NSString *valueTransformerName in valueTransformerNames) {
        NSValueTransformer *valueTransfomerForName = [NSValueTransformer
            valueTransformerForName:valueTransformerName];
        BOOL isObjCTypeTransformer = [valueTransfomerForName
            conformsToProtocol:@protocol(MTFObjCTypeValueTransformer)];
        BOOL hasKnownInputClass = [valueTransfomerForName
            conformsToProtocol:@protocol(MTFReverseTransformedValueClass)];
        
        if (isObjCTypeTransformer && hasKnownInputClass) {
            NSValueTransformer <MTFObjCTypeValueTransformer, MTFReverseTransformedValueClass> *valueTransformer;
            valueTransformer = (id)valueTransfomerForName;
            Class inputClass = [valueTransformer.class
                reverseTransformedValueClass];
            const char * outputObjCType = [valueTransformer.class
                transformedValueObjCType];
            
            BOOL canTransformObject = [object isKindOfClass:inputClass];
            BOOL isValidTransformation = (strcmp(outputObjCType, objCType) == 0);
            
            if (canTransformObject && isValidTransformation) {
                return valueTransformer;
            }
        }
    }
    return nil;
}

+ (NSValueTransformer *)mtf_valueTransformerForTransformingObject:(id)object toClass:(Class)toClass {
    NSParameterAssert(object);
    
    if (toClass == Nil) {
        return nil;
    }
    
    NSArray<NSString *> *valueTransformerNames = NSValueTransformer.valueTransformerNames;
    
    for (NSString *valueTransformerName in valueTransformerNames) {
        NSValueTransformer *valueTransfomerForName = [NSValueTransformer
            valueTransformerForName:valueTransformerName];
        BOOL hasKnownInputClass = [valueTransfomerForName
            conformsToProtocol:@protocol(MTFReverseTransformedValueClass)];
        
        if (hasKnownInputClass) {
            NSValueTransformer <MTFReverseTransformedValueClass> *valueTransformer;
            valueTransformer = (id)valueTransfomerForName;
            Class reverseTransformedValueClass = [valueTransformer.class
                reverseTransformedValueClass];
            Class transformedValueClass = [valueTransformer.class
                transformedValueClass];
            
            BOOL canTransformObject = [object
                isKindOfClass:reverseTransformedValueClass];
            BOOL isValidTransformation = (toClass == transformedValueClass);
            
            if (canTransformObject && isValidTransformation) {
                return valueTransformer;
            }
        }
    }
    return nil;
}

@end
