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

+ (NSValueTransformer *)aut_valueTransformerForTransformingObject:(id)object toObjCType:(const char *)objCType {
    NSParameterAssert(object);
    
    if (objCType == NULL) {
        return nil;
    }
    
    NSArray *valueTransformerNames = NSValueTransformer.valueTransformerNames;
    
    for (NSString *valueTransformerName in valueTransformerNames) {
        NSValueTransformer *valueTransfomerForName = [NSValueTransformer
            valueTransformerForName:valueTransformerName];
        BOOL isObjCTypeTransformer = [valueTransfomerForName
            conformsToProtocol:@protocol(AUTObjCTypeValueTransformer)];
        BOOL hasKnownInputClass = [valueTransfomerForName
            conformsToProtocol:@protocol(AUTReverseTransformedValueClass)];
        
        if (isObjCTypeTransformer && hasKnownInputClass) {
            NSValueTransformer <AUTObjCTypeValueTransformer, AUTReverseTransformedValueClass> *valueTransformer;
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

+ (NSValueTransformer *)aut_valueTransformerForTransformingObject:(id)object toClass:(Class)class {
    NSParameterAssert(object);
    
    if (class == Nil) {
        return nil;
    }
    
    NSArray *valueTransformerNames = NSValueTransformer.valueTransformerNames;
    
    for (NSString *valueTransformerName in valueTransformerNames) {
        NSValueTransformer *valueTransfomerForName = [NSValueTransformer
            valueTransformerForName:valueTransformerName];
        BOOL hasKnownInputClass = [valueTransfomerForName
            conformsToProtocol:@protocol(AUTReverseTransformedValueClass)];
        
        if (hasKnownInputClass) {
            NSValueTransformer <AUTReverseTransformedValueClass> *valueTransformer;
            valueTransformer = (id)valueTransfomerForName;
            Class reverseTransformedValueClass = [valueTransformer.class
                reverseTransformedValueClass];
            Class transformedValueClass = [valueTransformer.class
                transformedValueClass];
            
            BOOL canTransformObject = [object
                isKindOfClass:reverseTransformedValueClass];
            BOOL isValidTransformation = (class == transformedValueClass);
            
            if (canTransformObject && isValidTransformation) {
                return valueTransformer;
            }
        }
    }
    return nil;
}

@end
