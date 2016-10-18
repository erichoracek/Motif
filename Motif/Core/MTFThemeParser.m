//
//  MTFThemeParser.m
//  Motif
//
//  Created by Eric Horacek on 2/11/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "NSString+ThemeSymbols.h"
#import "NSDictionary+IntersectingKeys.h"
#import "NSDictionary+DictionaryValueValidation.h"

#import "MTFThemeConstant.h"
#import "MTFThemeConstant_Private.h"
#import "MTFThemeClass.h"
#import "MTFThemeClass_Private.h"
#import "MTFThemeSymbolReference.h"
#import "MTFTheme_Private.h"
#import "MTFErrors.h"

#import "MTFThemeParser.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MTFThemeParser

#pragma mark - Lifecycle

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Use the designated initializer instead" userInfo:nil];
}

- (nullable instancetype)initWithRawTheme:(NSDictionary<NSString *, id> *)rawTheme inheritingExistingConstants:(NSDictionary<NSString *, MTFThemeConstant *> *)existingConstants existingClasses:(NSDictionary<NSString *, MTFThemeClass *> *)existingClasses error:(NSError **)error {
    NSParameterAssert(rawTheme != nil);
    NSParameterAssert(existingConstants != nil);
    NSParameterAssert(existingClasses != nil);
    
    self = [super init];

    // Filter out the constants and classes from the raw dictionary
    NSDictionary<NSString *, id> *rawConstants = [self rawConstantsFromRawTheme:rawTheme];
    NSDictionary<NSString *, id> *rawClasses = [self rawClassesFromRawTheme:rawTheme];

    if ([self rawThemeContainsInvalidSymbols:rawTheme rawConstants:rawConstants rawClasses:rawClasses error:error]) return nil;

    NSDictionary<NSString *, MTFThemeConstant *> *parsedConstants = [self constantsParsedFromRawConstants:rawConstants];

    NSDictionary<NSString *, MTFThemeClass *> *parsedClasses = [self classesParsedFromRawClasses:rawClasses error:error];
    if (parsedClasses == nil) return nil;

    if (self.class.shouldResolveReferences) {
        NSDictionary<NSString *, MTFThemeConstant *> *mergedConstants = [self mergeParsedConstants:parsedConstants intoExistingConstants:existingConstants error:error];
        if (mergedConstants == nil) return nil;

        NSDictionary<NSString *, MTFThemeClass *> *mergedClasses = [self mergeParsedClasses:parsedClasses intoExistingClasses:existingClasses error:error];
        if (mergedClasses == nil) return nil;
        
        parsedConstants = [self resolveReferencesInParsedConstants:parsedConstants fromConstants:mergedConstants classes:mergedClasses error:error];
        if (parsedConstants == nil) return nil;
        
        parsedClasses = [self resolveReferencesInParsedClasses:parsedClasses fromConstants:mergedConstants classes:mergedClasses error:error];
        if (parsedClasses == nil) return nil;
    }
    
    _parsedConstants = parsedConstants;
    _parsedClasses = parsedClasses;

    return self;
}

#pragma mark - MTFThemeParser

#pragma mark Raw Theme Parsing

- (NSDictionary<NSString *, id> *)rawConstantsFromRawTheme:(NSDictionary<NSString *, id> *)rawTheme {
    NSMutableDictionary *rawConstants = [NSMutableDictionary dictionary];

    for (NSString *symbol in rawTheme) {
        if (symbol.mtf_isRawSymbolConstantReference) {
            rawConstants[symbol] = rawTheme[symbol];
        }
    }

    return [rawConstants copy];
}

- (NSDictionary<NSString *, id> *)rawClassesFromRawTheme:(NSDictionary<NSString *, id> *)rawTheme {
    NSMutableDictionary *rawClasses = [NSMutableDictionary dictionary];

    for (NSString *symbol in rawTheme) {
        if (symbol.mtf_isRawSymbolClassReference) {
            rawClasses[symbol] = rawTheme[symbol];
        }
    }

    return [rawClasses copy];
}

- (BOOL)rawThemeContainsInvalidSymbols:(NSDictionary<NSString *, id> *)rawTheme rawConstants:(NSDictionary<NSString *, id> *)rawConstants rawClasses:(NSDictionary<NSString *, id> *)rawClasses error:(NSError **)error {
    NSMutableSet<NSString *> *remainingKeys = [NSMutableSet setWithArray:rawTheme.allKeys];
    [remainingKeys minusSet:[NSSet setWithArray:rawConstants.allKeys]];
    [remainingKeys minusSet:[NSSet setWithArray:rawClasses.allKeys]];

    if (remainingKeys.count > 0) {
        if (error != NULL) {
            NSString *description = [NSString stringWithFormat:
                @"The following theme symbols are invalid %@",
                remainingKeys];

            *error = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToParseTheme userInfo:@{
                NSLocalizedDescriptionKey: description
            }];
        }

        return YES;
    }

    return NO;
}

#pragma mark Constants

- (NSDictionary<NSString *, MTFThemeConstant *> *)constantsParsedFromRawConstants:(NSDictionary *)rawConstants {
    NSMutableDictionary *parsedConstants = [NSMutableDictionary dictionary];

    for (NSString *rawSymbol in rawConstants) {
        id rawValue = rawConstants[rawSymbol];

        MTFThemeConstant *constant = [self constantParsedFromRawSymbol:rawSymbol rawValue:rawValue];

        parsedConstants[constant.name] = constant;
    };

    return [parsedConstants copy];
}

- (MTFThemeConstant *)constantParsedFromRawSymbol:(NSString *)rawSymbol rawValue:(id)rawValue {
    // If the symbol is a reference (in the case of a root-level constant), use
    // it. Otherwise it is a reference to in a class' properties, so just keep
    // it as-is
    NSString *symbol = rawSymbol;
    if (symbol.mtf_isRawSymbolConstantReference) {
        symbol = rawSymbol.mtf_symbol;
    }
    
    // If the rawValue is not a string, it is not a reference, so return as-is
    if (![rawValue isKindOfClass:NSString.class]) {
        return [[MTFThemeConstant alloc]
            initWithName:symbol
            rawValue:rawValue
            referencedValue:nil];
    }
    
    // We now know that this constant's value is a string, so cast it
    NSString *rawValueString = (NSString *)rawValue;
    MTFThemeSymbolReference *reference;
    
    // Determine if this string value is a symbol reference
    if (rawValueString.mtf_isRawSymbolReference) {
        reference = [[MTFThemeSymbolReference alloc] initWithRawSymbol:rawValueString];
    }
    
    return [[MTFThemeConstant alloc]
        initWithName:symbol
        rawValue:rawValue
        referencedValue:reference];
}

- (nullable NSDictionary<NSString *, MTFThemeClass *> *)resolveReferencesInParsedClasses:(NSDictionary<NSString *, MTFThemeClass *> *)parsedClasses fromConstants:(NSDictionary<NSString *, MTFThemeConstant *> *)constants classes:(NSDictionary<NSString *, MTFThemeClass *> *)classes error:(NSError **)error {
    NSMutableDictionary *resolvedClasses = [parsedClasses mutableCopy];
    NSArray<MTFThemeClass *> *parsedClassObjects = [parsedClasses objectEnumerator].allObjects;
    
    // Resolve the references within all classes.
    for (MTFThemeClass *parsedClass in parsedClassObjects) {
        NSDictionary *propertiesConstants = [self
            resolveReferencesInParsedConstants:parsedClass.propertiesConstants
            fromConstants:constants
            classes:classes
            error:error];

        if (propertiesConstants == nil) return nil;
        
        parsedClass.propertiesConstants = propertiesConstants;
    }
    
    // Once all references have been resolved, error if there are any circular
    // superclass references. If we don't do this here, we could infinitely
    // recurse during lazy superclass property resolution.
    for (MTFThemeClass *resolvedClass in [resolvedClasses objectEnumerator].allObjects) {
        BOOL noCircularSuperclassReferences = [self
            parsedConstantsContainsNoCircularSuperclassReferences:resolvedClass.propertiesConstants
            forClass:resolvedClass
            error:error];

        if (!noCircularSuperclassReferences) return nil;
    }
    
    return [resolvedClasses copy];
}

- (nullable NSDictionary *)resolveReferencesInParsedConstants:(NSDictionary<NSString *, MTFThemeConstant *> *)parsedConstants fromConstants:(NSDictionary<NSString *, MTFThemeConstant *> *)constants classes:(NSDictionary<NSString *, MTFThemeClass *> *)classes error:(NSError **)error {
    NSMutableDictionary *resolvedConstants = [parsedConstants mutableCopy];
    NSArray<MTFThemeConstant *> *parsedConstantObjects = [parsedConstants objectEnumerator].allObjects;
    
    for (MTFThemeConstant *parsedConstant in parsedConstantObjects) {
        id value = [self
            resolvedValueForThemeConstant:parsedConstant
            referenceHistory:@[ parsedConstant ]
            fromConstants:constants
            classes:classes
            error:error];

        if (value == nil) return nil;

        parsedConstant.referencedValue = value;
    }
    
    return [resolvedConstants copy];
}

- (nullable id)resolvedValueForThemeConstant:(MTFThemeConstant *)constant referenceHistory:(NSArray<MTFThemeConstant *> *)referenceHistory fromConstants:(NSDictionary<NSString *, MTFThemeConstant *> *)constants classes:(NSDictionary<NSString *, MTFThemeClass *> *)classes error:(NSError **)error {
    id referencedValue = constant.referencedValue;

    // If the constant does not have a reference as its value, return its value.
    BOOL isReferencedValueSymbolReference = [referencedValue isKindOfClass:MTFThemeSymbolReference.class];
    if (referencedValue == nil || !isReferencedValueSymbolReference) {
        return constant.value;
    }
    
    // Otherwise, the constant has a symbol reference as its referenced value,
    // so resolve it.
    MTFThemeSymbolReference *reference;
    reference = (MTFThemeSymbolReference *)referencedValue;
    
    switch (reference.type) {
    case MTFThemeSymbolTypeConstant: {
        // Locate the referenced constant in the existing constants dictionary.
        MTFThemeConstant *constantReference = constants[reference.symbol];
        BOOL isSelfReferential = [referenceHistory containsObject:constantReference];

        if (constantReference != nil && !isSelfReferential) {
            return [self
                resolvedValueForThemeConstant:constantReference
                referenceHistory:[referenceHistory arrayByAddingObject:constantReference]
                fromConstants:constants
                classes:classes
                error:error];
        }

        if (error != NULL) {
            NSString *description;

            if (isSelfReferential) {
                description = [NSString stringWithFormat:
                    @"The named constant value for property '%@' ('%@') may "
                        "not reference itself",
                    constant.name,
                    constant.rawValue];
            } else {
                description = [NSString stringWithFormat:
                    @"The named constant value for property '%@' ('%@') was "
                        "not found as a registered constant",
                    constant.name,
                    constant.rawValue];
            }

            *error = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToParseTheme userInfo:@{
                NSLocalizedDescriptionKey: description
            }];
        }

        return nil;
    }
    break;
    case MTFThemeSymbolTypeClass: {
        // Locate the referenced class in the existing constants dictionary
        MTFThemeClass *classReference = classes[reference.symbol];
        if (classReference != nil) {
            return classReference;
        }

        if (error != NULL) {
            NSString *description = [NSString stringWithFormat:
                @"The named constant value for property '%@' ('%@') was "
                    "not found as a registered constant",
                constant.name,
                constant.rawValue];

            *error = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToParseTheme userInfo:@{
                NSLocalizedDescriptionKey: description
            }];
        }

        return nil;
    }
    break;
    default:
        @throw [NSException
            exceptionWithName:NSInternalInconsistencyException
            reason:[NSString stringWithFormat:@"Unhanded symbol type %@", reference]
            userInfo:nil];
    }
}

- (BOOL)parsedConstantsContainsNoCircularSuperclassReferences:(NSDictionary *)parsedConstants forClass:(MTFThemeClass *)class error:(NSError **)error {
    // Don't continue if there's no superclass, as it's the only reason why a
    // reference would be invalid
    MTFThemeClass *classSuperclass = [parsedConstants[MTFThemeSuperclassKey] referencedValue];
    if (classSuperclass == nil) return parsedConstants;
    
    // Ensure that no superclass all the way up the inheritance hierarchy
    // causes a circular reference.
    MTFThemeClass *superclass = classSuperclass;
    do {
        if (superclass == class) {
            if (error != NULL) {
                NSString *description = [NSString stringWithFormat:
                    @"The superclass of '%@' causes it to inherit from itself. "
                        "It is currently '%@'.",
                    class.name,
                    classSuperclass.name];
                
                *error = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToParseTheme userInfo:@{
                    NSLocalizedDescriptionKey: description
                }];
            }
            
            return NO;
        }
        
    } while ((superclass = [superclass.propertiesConstants[MTFThemeSuperclassKey] referencedValue]));
    
    return YES;
}

#pragma mark Classes

- (nullable NSDictionary<NSString *, MTFThemeClass *> *)classesParsedFromRawClasses:(NSDictionary *)rawClasses error:(NSError **)error {
    // Create MTFThemeClass objects from the raw classes
    NSMutableDictionary<NSString *, MTFThemeClass *> *parsedClasses = [NSMutableDictionary dictionary];
    
    for (NSString *rawClassName in rawClasses) {
        // Ensure that the raw properties are a dictionary and not another type
        NSDictionary *rawProperties = [rawClasses mtf_dictionaryValueForKey:rawClassName error:error];
        if (rawProperties == nil) return nil;
        
        // Create a theme class from this properties dictionary
        MTFThemeClass *class = [self classParsedFromRawProperties:rawProperties rawName:rawClassName error:error];
        if (class == nil) return nil;

        parsedClasses[class.name] = class;
    }
    
    return [parsedClasses copy];
}

- (nullable MTFThemeClass *)classParsedFromRawProperties:(NSDictionary *)rawProperties rawName:(NSString *)rawName error:(NSError **)error {
    NSParameterAssert(rawName != nil);
    NSParameterAssert(rawProperties != nil);
    
    NSString *name = rawName.mtf_symbol;

    NSDictionary *resolvedProperties = [self constantsParsedFromRawConstants:rawProperties];
    
    NSDictionary *filteredProperties = [self filteredPropertiesFromResolvedClassProperties:resolvedProperties className:name error:error];
    if (filteredProperties == nil) return nil;
    
    MTFThemeClass *class = [[MTFThemeClass alloc] initWithName:name propertiesConstants:filteredProperties];
    
    return class;
}

- (nullable NSDictionary *)filteredPropertiesFromResolvedClassProperties:(NSDictionary *)resolvedClassProperties className:(NSString *)className error:(NSError **)error {
    NSMutableDictionary *filteredClassProperties = [resolvedClassProperties mutableCopy];
    
    // If there is a superclass property, filter it out if it doesn't contain a
    // reference and populate the error
    MTFThemeConstant *superclass = filteredClassProperties[MTFThemeSuperclassKey];

    if (superclass != nil) {
        BOOL isSymbolReference = [superclass.referencedValue isKindOfClass:MTFThemeSymbolReference.class];
        BOOL isSuperclassClassReference = NO;
        
        if (isSymbolReference) {
            MTFThemeSymbolReference *reference = superclass.referencedValue;
            isSuperclassClassReference = (reference.type == MTFThemeSymbolTypeClass);
        }
        
        // If superclass property doesn't refer to a class, populate the error
        if (!isSuperclassClassReference || !isSymbolReference) {
            // Populate an error with the failure reason
            if (error != NULL) {
                NSString *description = [NSString stringWithFormat:
                    @"The value for the 'superclass' property in '%@' must "
                        "reference a valid theme class. It is currently '%@'.",
                    className,
                    superclass.rawValue];
                
                *error = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToParseTheme userInfo:@{
                    NSLocalizedDescriptionKey: description
                }];
            }

            return nil;
        }
    }
    
    return [filteredClassProperties copy];
}

#pragma mark Merging

- (nullable NSDictionary<NSString *, MTFThemeConstant *> *)mergeParsedConstants:(NSDictionary<NSString *, MTFThemeConstant *> *)parsedConstants intoExistingConstants:(NSDictionary<NSString *, MTFThemeConstant *> *)existingConstants error:(NSError **)error {
    NSSet<NSString *> *intersectingConstants = [existingConstants mtf_intersectingKeysWithDictionary:parsedConstants];

    if (intersectingConstants.count > 0) {
        if (error != NULL) {
            NSString *description = [NSString stringWithFormat:
                @"Registering new constants with identical names to "
                    "previously-defined constants will overwrite existing "
                    "constants with the following names: %@",
                intersectingConstants];

            *error = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToParseTheme userInfo:@{
                NSLocalizedDescriptionKey : description
            }];
        }

        return nil;
    }

    NSMutableDictionary<NSString *, MTFThemeConstant *> *mergedConstants = [existingConstants mutableCopy];
    [mergedConstants addEntriesFromDictionary:parsedConstants];
    return [mergedConstants copy];
}

- (nullable NSDictionary<NSString *, MTFThemeClass *> *)mergeParsedClasses:(NSDictionary<NSString *, MTFThemeClass *> *)parsedClasses intoExistingClasses:(NSDictionary<NSString *, MTFThemeClass *> *)existingClasses error:(NSError **)error {
    NSSet<NSString *> *intersectingClasses = [existingClasses mtf_intersectingKeysWithDictionary:parsedClasses];

    if (intersectingClasses.count > 0) {
        if (error != NULL) {
            NSString *description = [NSString stringWithFormat:
                @"Registering new classes with identical names to "
                    "previously-defined classes will overwrite existing classes "
                    "with the following names: %@",
                intersectingClasses];
                
            *error = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToParseTheme userInfo:@{
                NSLocalizedDescriptionKey : description
            }];
        }

        return nil;
    }

    NSMutableDictionary<NSString *, MTFThemeClass *> *mergedClasses = [existingClasses mutableCopy];
    [mergedClasses addEntriesFromDictionary:parsedClasses];
    return [mergedClasses copy];
}

static BOOL ShouldResolveReferences = YES;

+ (BOOL)shouldResolveReferences {
    NSAssert(NSThread.isMainThread, @"%@ should only be invoked from the main thread", NSStringFromSelector(_cmd));
    return ShouldResolveReferences;
}

+ (void)setShouldResolveReferences:(BOOL)shouldResolveReferences {
    NSAssert(NSThread.isMainThread, @"%@ should only be invoked from the main thread", NSStringFromSelector(_cmd));
    ShouldResolveReferences = shouldResolveReferences;
}

@end

NS_ASSUME_NONNULL_END
