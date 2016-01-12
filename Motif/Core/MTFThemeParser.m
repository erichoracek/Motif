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

- (instancetype)initWithRawTheme:(NSDictionary<NSString *, id> *)rawTheme inheritingExistingConstants:(NSDictionary<NSString *, MTFThemeConstant *> *)existingConstants existingClasses:(NSDictionary<NSString *, MTFThemeClass *> *)existingClasses error:(NSError **)error {
    NSParameterAssert(rawTheme != nil);
    NSParameterAssert(existingConstants != nil);
    NSParameterAssert(existingClasses != nil);
    
    self = [super init];

    // Filter out the constants and classes from the raw dictionary
    NSDictionary<NSString *, id> *rawConstants = [self rawConstantsFromRawTheme:rawTheme];
    NSDictionary<NSString *, id> *rawClasses = [self rawClassesFromRawTheme:rawTheme];
    
    // Determine the invalid keys from the raw theme
    NSArray<NSString *> *invalidSymbols = [self
        invalidSymbolsFromRawTheme:rawTheme
        rawConstants:rawConstants
        rawClasses:rawClasses];
        
    if (invalidSymbols.count && error) {
        NSString *description = [NSString stringWithFormat:
            @"The following theme symbols are invalid %@",
            invalidSymbols];

        *error = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToParseTheme userInfo:@{
            NSLocalizedDescriptionKey: description
        }];
    }
    
    // Map the constants from the raw theme
    NSDictionary<NSString *, MTFThemeConstant *> *parsedConstants = [self
        constantsParsedFromRawConstants:rawConstants
        error:error];

    NSDictionary<NSString *, MTFThemeClass *> *parsedClasses = [self
        classesParsedFromRawClasses:rawClasses
        error:error];
    
    if (self.class.shouldResolveReferences) {
        NSDictionary<NSString *, MTFThemeConstant *> *mergedConstants = [self
            mergeParsedConstants:parsedConstants
            intoExistingConstants:existingConstants
            error:error];

        NSDictionary<NSString *, MTFThemeClass *> *mergedClasses = [self
            mergeParsedClasses:parsedClasses
            intoExistingClasses:existingClasses
            error:error];
        
        parsedConstants = [self
            resolveReferencesInParsedConstants:parsedConstants
            fromConstants:mergedConstants
            classes:mergedClasses
            error:error];
        
        parsedClasses = [self
            resolveReferencesInParsedClasses:parsedClasses
            fromConstants:mergedConstants
            classes:mergedClasses
            error:error];
    }
    
    _parsedConstants = parsedConstants;
    _parsedClasses = parsedClasses;

    return self;
}

#pragma mark - MTFThemeParser

#pragma mark Raw Theme Parsing

- (NSDictionary<NSString *, id> *)rawConstantsFromRawTheme:(NSDictionary<NSString *, id> *)rawTheme {
    NSMutableDictionary *rawConstants = [NSMutableDictionary new];
    for (NSString *symbol in rawTheme) {
        if (symbol.mtf_isRawSymbolConstantReference) {
            rawConstants[symbol] = rawTheme[symbol];
        }
    }
    return [rawConstants copy];
}

- (NSDictionary<NSString *, id> *)rawClassesFromRawTheme:(NSDictionary<NSString *, id> *)rawTheme {
    NSMutableDictionary *rawClasses = [NSMutableDictionary new];
    for (NSString *symbol in rawTheme) {
        if (symbol.mtf_isRawSymbolClassReference) {
            rawClasses[symbol] = rawTheme[symbol];
        }
    }
    return [rawClasses copy];
}

- (NSArray<NSString *> *)invalidSymbolsFromRawTheme:(NSDictionary<NSString *, id> *)rawTheme rawConstants:(NSDictionary<NSString *, id> *)rawConstants rawClasses:(NSDictionary<NSString *, id> *)rawClasses {
    NSMutableSet<NSString *> *remainingKeys = [NSMutableSet setWithArray:rawTheme.allKeys];
    [remainingKeys minusSet:[NSSet setWithArray:rawConstants.allKeys]];
    [remainingKeys minusSet:[NSSet setWithArray:rawClasses.allKeys]];
    return remainingKeys.allObjects;
}

#pragma mark Constants

- (NSDictionary<NSString *, MTFThemeConstant *> *)constantsParsedFromRawConstants:(NSDictionary *)rawConstants error:(NSError **)error {
    NSMutableDictionary *parsedConstants = [NSMutableDictionary new];
    for (NSString *rawSymbol in rawConstants) {
        id rawValue = rawConstants[rawSymbol];
        MTFThemeConstant *constant = [self
            constantParsedFromRawSymbol:rawSymbol
            rawValue:rawValue
            error:error];
        parsedConstants[constant.name] = constant;
    };
    return [parsedConstants copy];
}

- (MTFThemeConstant *)constantParsedFromRawSymbol:(NSString *)rawSymbol rawValue:(id)rawValue error:(NSError **)error {
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
            mappedValue:nil];
    }
    
    // We now know that this constant's value is a string, so cast it
    NSString *rawValueString = (NSString *)rawValue;
    MTFThemeSymbolReference *reference;
    
    // Determine if this string value is a symbol reference
    if (rawValueString.mtf_isRawSymbolReference) {
        reference = [[MTFThemeSymbolReference alloc]
            initWithRawSymbol:rawValueString];
    }
    
    return [[MTFThemeConstant alloc]
        initWithName:symbol
        rawValue:rawValue
        mappedValue:reference];
}

- (NSDictionary<NSString *, MTFThemeClass *> *)resolveReferencesInParsedClasses:(NSDictionary<NSString *, MTFThemeClass *> *)parsedClasses fromConstants:(NSDictionary<NSString *, MTFThemeConstant *> *)constants classes:(NSDictionary<NSString *, MTFThemeClass *> *)classes error:(NSError **)error {
    NSMutableDictionary *resolvedClasses = [parsedClasses mutableCopy];
    NSArray<MTFThemeClass *> *parsedClassObjects = [parsedClasses objectEnumerator].allObjects;
    
    for (MTFThemeClass *parsedClass in parsedClassObjects) {
        // Resolve the references within this class
        NSDictionary *propertiesConstants = [self
            resolveReferencesInParsedConstants:parsedClass.propertiesConstants
            fromConstants:constants
            classes:classes
            error:error];
        
        parsedClass.propertiesConstants = propertiesConstants;
    }
    
    // Once all references have been resolved, filter invalid references
    for (MTFThemeClass *resolvedClass in [resolvedClasses objectEnumerator].allObjects) {
        NSDictionary *propertiesConstants = resolvedClass.propertiesConstants;
        
        // Filter invalid references from class properties
        NSDictionary *filteredPropertiesConstants = [self
            filterInvalidReferencesInParsedConstants:propertiesConstants
            forClass:resolvedClass
            error:error];
        
        resolvedClass.propertiesConstants = filteredPropertiesConstants;
    }
    
    return [resolvedClasses copy];
}

- (NSDictionary *)resolveReferencesInParsedConstants:(NSDictionary<NSString *, MTFThemeConstant *> *)parsedConstants fromConstants:(NSDictionary<NSString *, MTFThemeConstant *> *)constants classes:(NSDictionary<NSString *, MTFThemeClass *> *)classes error:(NSError **)error {
    NSMutableDictionary *resolvedConstants = [parsedConstants mutableCopy];
    NSArray<MTFThemeConstant *> *parsedConstantObjects = [parsedConstants
        objectEnumerator].allObjects;
    
    for (MTFThemeConstant *parsedConstant in parsedConstantObjects) {
        id mappedValue = parsedConstant.mappedValue;
        
        // If the constant does not have a reference as its value, continue
        BOOL isMappedValueSymbolReference = [mappedValue
            isKindOfClass:MTFThemeSymbolReference.class];
        if (!mappedValue || !isMappedValueSymbolReference) {
            continue;
        }
        
        // Otherwise, the constant has a symbol reference as its mapped value,
        // so resolve it
        MTFThemeSymbolReference *reference;
        reference = (MTFThemeSymbolReference *)mappedValue;
        
        switch (reference.type) {
        case MTFThemeSymbolTypeConstant: {
            // Locate the referenced constant in the existing constants
            // dictionary.
            MTFThemeConstant *constantReference = constants[reference.symbol];
            BOOL isSelfReferential = constantReference == parsedConstant;

            if (constantReference && !isSelfReferential) {
                parsedConstant.mappedValue = constantReference;
                continue;
            }

            // This is an invalid reference, so remove it from the resolved
            // constants.
            [resolvedConstants removeObjectForKey:parsedConstant.name];

            if (error) {
                NSString *description;

                if (isSelfReferential) {
                    description = [NSString stringWithFormat:
                        @"The named constant value for property '%@' ('%@') may "
                            "not reference itself",
                        parsedConstant.name,
                        parsedConstant.rawValue];
                } else {
                    description = [NSString stringWithFormat:
                        @"The named constant value for property '%@' ('%@') was "
                            "not found as a registered constant",
                        parsedConstant.name,
                        parsedConstant.rawValue];
                }

                *error = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToParseTheme userInfo:@{
                    NSLocalizedDescriptionKey: description
                }];
            }
        }
        break;
        case MTFThemeSymbolTypeClass: {
            // Locate the referenced class in the existing constants dictionary
            MTFThemeClass *classReference = classes[reference.symbol];
            if (classReference) {
                parsedConstant.mappedValue = classReference;
                continue;
            }
            // This is an invalid reference, so remove it from the resolved
            // constants
            [resolvedConstants removeObjectForKey:parsedConstant.name];
            if (error) {
                NSString *description = [NSString stringWithFormat:
                    @"The named constant value for property '%@' ('%@') was "
                        "not found as a registered constant",
                    parsedConstant.name,
                    parsedConstant.rawValue];

                *error = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToParseTheme userInfo:@{
                    NSLocalizedDescriptionKey: description
                }];
            }
        }
        break;
        default:
            @throw [NSException
                exceptionWithName:NSInternalInconsistencyException
                reason:[NSString stringWithFormat:@"Unhanded symbol type %@", reference]
                userInfo:nil];
        }
    }
    
    return [resolvedConstants copy];
}

- (NSDictionary *)filterInvalidReferencesInParsedConstants:(NSDictionary *)parsedConstants forClass:(MTFThemeClass *)class error:(NSError **)error {
    // Don't continue if there's no superclass, as it's the only reason why a
    // reference would be invalid
    MTFThemeClass *classSuperclass = [parsedConstants[MTFThemeSuperclassKey] mappedValue];
    if (classSuperclass == nil) {
        return parsedConstants;
    }
    
    NSMutableDictionary *filteredParsedConstants = [parsedConstants mutableCopy];
    
    // Ensure that no superclass all the way up the inheritance hierarchy
    // causes a circular reference.
    MTFThemeClass *superclass = classSuperclass;
    do {
        if (superclass == class) {
            // Filter the superclass from the parsed constants if it
            // transitively references itself
            [filteredParsedConstants removeObjectForKey:MTFThemeSuperclassKey];

            if (error) {
                NSString *description = [NSString stringWithFormat:
                    @"The superclass of '%@' causes it to inherit from itself. "
                        "It is currently '%@'.",
                    class.name,
                    classSuperclass.name];
                
                *error = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToParseTheme userInfo:@{
                    NSLocalizedDescriptionKey: description
                }];
            }
            
            break;
        }
        
    } while ((superclass = [superclass.propertiesConstants[MTFThemeSuperclassKey] mappedValue]));
    
    return [filteredParsedConstants copy];
}

#pragma mark Classes

- (NSDictionary<NSString *, MTFThemeClass *> *)classesParsedFromRawClasses:(NSDictionary *)rawClasses error:(NSError **)error {
    // Create MTFThemeClass objects from the raw classes
    NSMutableDictionary<NSString *, MTFThemeClass *> *parsedClasses = [NSMutableDictionary new];
    
    for (NSString *rawClassName in rawClasses) {
        // Ensure that the raw properties are a dictionary and not another type
        NSDictionary *rawProperties = [rawClasses
            mtf_dictionaryValueForKey:rawClassName
            error:error];
        
        if (!rawProperties) {
            break;
        }
        
        // Create a theme class from this properties dictionary
        MTFThemeClass *class = [self
            classParsedFromRawProperties:rawProperties
            rawName:rawClassName
            error:error];
        
        if (class) {
            parsedClasses[class.name] = class;
        }
    }
    
    return [parsedClasses copy];
}

- (MTFThemeClass *)classParsedFromRawProperties:(NSDictionary *)rawProperties rawName:(NSString *)rawName error:(NSError **)error {
    NSParameterAssert(rawName);
    NSParameterAssert(rawProperties);
    
    NSString *name = rawName.mtf_symbol;
    
    NSDictionary *mappedProperties = [self
        constantsParsedFromRawConstants:rawProperties
        error:error];
    
    NSDictionary *filteredProperties = [self
        filteredPropertiesFromMappedClassProperties:mappedProperties
        className:name
        error:error];
    
    MTFThemeClass *class = [[MTFThemeClass alloc]
        initWithName:name
        propertiesConstants:filteredProperties];
    
    return class;
}

- (NSDictionary *)filteredPropertiesFromMappedClassProperties:(NSDictionary *)mappedClassProperties className:(NSString *)className error:(NSError **)error {
    NSMutableDictionary *filteredClassProperties = [mappedClassProperties mutableCopy];
    
    // If there is a superclass property, filter it out if it doesn't contain a
    // reference and populate the error
    MTFThemeConstant *superclass = filteredClassProperties[MTFThemeSuperclassKey];
    if (superclass) {
        BOOL isSymbolReference = [superclass.mappedValue isKindOfClass:MTFThemeSymbolReference.class];
        BOOL isSuperclassClassReference = NO;
        
        if (isSymbolReference) {
            MTFThemeSymbolReference *reference = superclass.mappedValue;
            isSuperclassClassReference = (reference.type == MTFThemeSymbolTypeClass);
        }
        
        // If superclass property doesn't refer to a class, populate the error
        if (!isSuperclassClassReference || !isSymbolReference) {
            // Filter this property out from this class' properties
            [filteredClassProperties removeObjectForKey:MTFThemeSuperclassKey];
            
            // Populate an error with the failure reason
            if (error) {
                NSString *description = [NSString stringWithFormat:
                    @"The value for the 'superclass' property in '%@' must "
                        "reference a valid theme class. It is currently '%@'.",
                    className,
                    superclass.rawValue];
                
                *error = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToParseTheme userInfo:@{
                    NSLocalizedDescriptionKey: description
                }];
            }
        }
    }
    
    return [filteredClassProperties copy];
}

#pragma mark Merging

- (NSDictionary<NSString *, MTFThemeConstant *> *)mergeParsedConstants:(NSDictionary<NSString *, MTFThemeConstant *> *)parsedConstants intoExistingConstants:(NSDictionary<NSString *, MTFThemeConstant *> *)existingConstants error:(NSError **)error {
    NSSet<NSString *> *intersectingConstants = [existingConstants
        mtf_intersectingKeysWithDictionary:parsedConstants];
    if (intersectingConstants.count && error) {
        NSString *description = [NSString stringWithFormat:
            @"Registering new constants with identical names to "
                "previously-defined constants will overwrite existing "
                "constants with the following names: %@",
            intersectingConstants];

        *error = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToParseTheme userInfo:@{
            NSLocalizedDescriptionKey : description
        }];
    }
    NSMutableDictionary<NSString *, MTFThemeConstant *> *mergedConstants = [existingConstants mutableCopy];
    [mergedConstants addEntriesFromDictionary:parsedConstants];
    return [mergedConstants copy];
}

- (NSDictionary<NSString *, MTFThemeClass *> *)mergeParsedClasses:(NSDictionary<NSString *, MTFThemeClass *> *)parsedClasses intoExistingClasses:(NSDictionary<NSString *, MTFThemeClass *> *)existingClasses error:(NSError **)error {
    NSSet<NSString *> *intersectingClasses = [existingClasses
        mtf_intersectingKeysWithDictionary:parsedClasses];
    if (intersectingClasses.count && error) {
        NSString *description = [NSString stringWithFormat:
            @"Registering new classes with identical names to "
                "previously-defined classes will overwrite existing classes "
                "with the following names: %@",
            intersectingClasses];
            
        *error = [NSError errorWithDomain:MTFErrorDomain code:MTFErrorFailedToParseTheme userInfo:@{
            NSLocalizedDescriptionKey : description
        }];
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
