//
//  AUTThemeParser.m
//  Pods
//
//  Created by Eric Horacek on 2/11/15.
//
//

#import "AUTThemeParser.h"
#import "AUTThemeConstant.h"
#import "AUTThemeConstant_Private.h"
#import "AUTThemeClass.h"
#import "AUTThemeClass_Private.h"
#import "AUTTheme.h"
#import "AUTTheme_Private.h"
#import "NSString+ThemeSymbols.h"
#import "NSDictionary+IntersectingKeys.h"

@interface AUTThemeSymbolReference : NSObject

- (instancetype)initWithRawSymbol:(NSString *)rawSymbol;

@property (nonatomic, readonly) NSString *rawSymbol;
@property (nonatomic, readonly) NSString *symbol;
@property (nonatomic, readonly) AUTThemeSymbolType type;

@end

@interface NSDictionary (DictionaryValueValidation)

- (NSDictionary *)aut_dictionaryValueForKey:(NSString *)key error:(NSError **)error;

@end

@interface AUTThemeParser ()

@property (nonatomic) NSDictionary *parsedConstants;
@property (nonatomic) NSDictionary *parsedClasses;

@end

@implementation AUTThemeParser

#pragma mark - Public

- (instancetype)initWithRawTheme:(NSDictionary *)rawTheme inheritingFromTheme:(AUTTheme *)theme error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(rawTheme);
    
    self = [super init];
    if (self) {
        _rawTheme = rawTheme;
        
        // Filter out the constants and classes from the raw dictionary
        NSDictionary *rawConstants = [self rawConstantsFromRawTheme:rawTheme];
        NSDictionary *rawClasses = [self rawClassesFromRawTheme:rawTheme];
        
        // Determine the invalid keys from the raw theme
        NSArray *invalidSymbols = [self invalidSymbolsFromRawTheme:rawTheme rawConstants:rawConstants rawClasses:rawClasses];
        if (invalidSymbols.count && error) {
            *error = [NSError errorWithDomain:AUTThemingErrorDomain code:0 userInfo:@{
                NSLocalizedDescriptionKey: [NSString stringWithFormat:@"The following symbols in the theme are invalid %@", invalidSymbols]
            }];
        }
        
        // Map the constants from the raw theme
        NSDictionary *parsedConstants = [self constantsParsedFromRawConstants:rawConstants error:error];
        NSDictionary *parsedClasses = [self classesParsedFromRawClasses:rawClasses error:error];
        
// For the theming symbols generator CLI, allow for parsing raw themes without resolving their symbols (since each
// passed theme is parsed separately)
#if !defined(AUTTHEMING_DISABLE_SYMBOL_RESOLUTION)
        
        NSDictionary *mergedConstants = [self mergeParsedConstants:parsedConstants intoExistingConstants:theme.constants error:error];
        NSDictionary *mergedClasses = [self mergeParsedConstants:parsedClasses intoExistingConstants:theme.classes error:error];
        
        parsedConstants = [self resolveReferenceInParsedConstants:parsedConstants fromConstants:mergedConstants classes:mergedClasses error:error];
        parsedClasses = [self resolveReferencesInParsedClasses:parsedClasses fromConstants:mergedConstants classes:mergedClasses error:error];
        
#endif
        
        _parsedConstants = parsedConstants;
        _parsedClasses = parsedClasses;
    }
    return self;
}

#pragma mark - Private

#pragma mark Raw Theme Parsing

- (NSDictionary *)rawConstantsFromRawTheme:(NSDictionary *)rawTheme
{
    NSMutableDictionary *rawConstants = [NSMutableDictionary new];
    for (NSString *symbol in rawTheme) {
        if (symbol.aut_isRawSymbolConstantReference) {
            rawConstants[symbol] = rawTheme[symbol];
        }
    }
    return [rawConstants copy];
}

- (NSDictionary *)rawClassesFromRawTheme:(NSDictionary *)rawTheme
{
    NSMutableDictionary *rawClasses = [NSMutableDictionary new];
    for (NSString *symbol in rawTheme) {
        if (symbol.aut_isRawSymbolClassReference) {
            rawClasses[symbol] = rawTheme[symbol];
        }
    }
    return [rawClasses copy];
}

- (NSArray *)invalidSymbolsFromRawTheme:(NSDictionary *)rawThemeDictionary rawConstants:(NSDictionary *)rawConstants rawClasses:(NSDictionary *)rawClasses
{
    NSMutableSet *remainingKeys = [NSMutableSet setWithArray:rawThemeDictionary.allKeys];
    [remainingKeys minusSet:[NSSet setWithArray:rawConstants.allKeys]];
    [remainingKeys minusSet:[NSSet setWithArray:rawClasses.allKeys]];
    return remainingKeys.allObjects;
}

#pragma mark Constants

- (NSDictionary *)constantsParsedFromRawConstants:(NSDictionary *)rawConstants error:(NSError *__autoreleasing *)error
{
    NSMutableDictionary *parsedConstants = [NSMutableDictionary new];
    for (NSString *rawSymbol in rawConstants) {
        id rawValue = rawConstants[rawSymbol];
        AUTThemeConstant *constant = [self constantParsedFromRawSymbol:rawSymbol rawValue:rawValue error:error];
        parsedConstants[constant.key] = constant;
    };
    return [parsedConstants copy];
}

- (AUTThemeConstant *)constantParsedFromRawSymbol:(NSString *)rawSymbol rawValue:(id)rawValue error:(NSError *__autoreleasing *)error
{
    // If the symbol is a reference (in the case of a root-level constant), use it. Otherwise it is a reference to
    // in a class' properties, so just keep it as-is
    NSString *symbol = rawSymbol;
    if (symbol.aut_isRawSymbolConstantReference) {
        symbol = rawSymbol.aut_symbol;
    }
    
    // If the rawValue is not a string, it is not a reference, so return as-is
    if (![rawValue isKindOfClass:[NSString class]]) {
        return [[AUTThemeConstant alloc] initWithKey:symbol rawValue:rawValue mappedValue:nil];
    }
    
    // We now know that this constant's value is a string, so cast it
    NSString *rawValueString = (NSString *)rawValue;
    AUTThemeSymbolReference *reference;
    
    // Determine if this string value is a symbol reference
    if (rawValueString.aut_isRawSymbolReference) {
        reference = [[AUTThemeSymbolReference alloc] initWithRawSymbol:rawValueString];
    }
    
    return [[AUTThemeConstant alloc] initWithKey:symbol rawValue:rawValue mappedValue:reference];
}

- (NSDictionary *)resolveReferencesInParsedClasses:(NSDictionary *)parsedClasses fromConstants:(NSDictionary *)constants classes:(NSDictionary *)classes error:(NSError *__autoreleasing *)error
{
    NSMutableDictionary *resolvedClasses = [parsedClasses mutableCopy];
    
    for (AUTThemeClass *parsedClass in [parsedClasses objectEnumerator].allObjects) {
        
        // Resolve the references within this class
        parsedClass.propertiesConstants = [self resolveReferenceInParsedConstants:parsedClass.propertiesConstants fromConstants:constants classes:classes error:error];
        
        // If there is a superclass reference and it is to invalid property
        id superclass = [parsedClass.propertiesConstants[AUTThemeSuperclassKey] mappedValue];
        if (superclass && ![superclass isKindOfClass:[AUTThemeClass class]]) {
            // Do not resolve this class
            [resolvedClasses removeObjectForKey:parsedClass.name];
            // Populate the error
            if (error) {
                *error = [NSError errorWithDomain:AUTThemingErrorDomain code:1 userInfo:@{
                    NSLocalizedDescriptionKey:[NSString stringWithFormat:@"The value for the 'superclass' property in '%@' must reference a valid theme class. It is currently '%@'", parsedClass.name, superclass]
                }];
            }
        }
    }
    
    return [resolvedClasses copy];
}

- (NSDictionary *)resolveReferenceInParsedConstants:(NSDictionary *)parsedConstants fromConstants:(NSDictionary *)constants classes:(NSDictionary *)classes error:(NSError *__autoreleasing *)error
{
    NSMutableDictionary *resolvedConstants = [parsedConstants mutableCopy];
    
    for (AUTThemeConstant *parsedConstant in [parsedConstants objectEnumerator].allObjects) {
        
        id mappedValue = parsedConstant.mappedValue;
        
        // If the constant does not have a reference as its value, continue
        if (!mappedValue || ![mappedValue isKindOfClass:[AUTThemeSymbolReference class]]) {
            continue;
        }
        
        // Otherwise, the constant has a symbol reference as its mapped value, so resolve it
        AUTThemeSymbolReference *reference = (AUTThemeSymbolReference *)mappedValue;
        
        switch (reference.type) {
        case AUTThemeSymbolTypeConstant: {
            // Locate the referenced constant in the existing constants dictionary
            AUTThemeConstant *constantReference = constants[reference.symbol];
            if (constantReference) {
                parsedConstant.mappedValue = constantReference;
                continue;
            }
            // This is an invalid reference, so remove it from the resolved constants
            [resolvedConstants removeObjectForKey:parsedConstant.key];
            if (error) {
                *error = [NSError errorWithDomain:AUTThemingErrorDomain code:0 userInfo:@{
                    NSLocalizedDescriptionKey: [NSString stringWithFormat:@"The named constant value for property '%@' ('%@') was not found as a registered constant", parsedConstant.key, parsedConstant.rawValue]
                }];
            }
        }
        break;
        case AUTThemeSymbolTypeClass: {
            // Locate the referenced class in the existing constants dictionary
            AUTThemeClass *classReference = classes[reference.symbol];
            if (classReference) {
                parsedConstant.mappedValue = classReference;
                continue;
            }
            // This is an invalid reference, so remove it from the resolved constants
            [resolvedConstants removeObjectForKey:parsedConstant.key];
            if (error) {
                *error = [NSError errorWithDomain:AUTThemingErrorDomain code:0 userInfo:@{
                    NSLocalizedDescriptionKey: [NSString stringWithFormat:@"The named constant value for property '%@' ('%@') was not found as a registered constant", parsedConstant.key, parsedConstant.rawValue]
                }];
            }
        }
        break;
        default:
            NSAssert(NO, @"Unhandled symbol type");
            break;
        }
    }
    
    return [resolvedConstants copy];
}

#pragma mark Classes

- (NSDictionary *)classesParsedFromRawClasses:(NSDictionary *)rawClasses error:(NSError *__autoreleasing *)error
{
    // Create AUTThemeClass objects from the raw classes
    NSMutableDictionary *parsedClasses = [NSMutableDictionary new];
    for (NSString *rawClassName in rawClasses) {
        // Ensure that the raw properties are a dictionary and not another type
        NSDictionary *rawProperties = [rawClasses aut_dictionaryValueForKey:rawClassName error:error];
        if (!rawProperties) {
            break;
        }
        // Create a theme class from this properties dictionary
        AUTThemeClass *class = [self classParsedFromRawProperties:rawProperties rawName:rawClassName error:error];
        if (class) {
            parsedClasses[class.name] = class;
        }
    }
    return [parsedClasses copy];
}

- (AUTThemeClass *)classParsedFromRawProperties:(NSDictionary *)rawProperties rawName:(NSString *)rawName error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(rawName);
    NSParameterAssert(rawProperties);
    
    NSString *name = rawName.aut_symbol;
    NSDictionary *mappedProperties = [self constantsParsedFromRawConstants:rawProperties error:error];
    AUTThemeClass *class = [[AUTThemeClass alloc] initWithName:name propertiesConstants:mappedProperties];
    
    return class;
}

#pragma mark Merging

- (NSDictionary *)mergeParsedConstants:(NSDictionary *)parsedConstants intoExistingConstants:(NSDictionary *)existingConstants error:(NSError *__autoreleasing *)error
{
    NSSet *intersectingConstants = [existingConstants aut_intersectingKeysWithDictionary:parsedConstants];
    if (intersectingConstants.count && error) {
        *error = [NSError errorWithDomain:AUTThemingErrorDomain code:1 userInfo:@{
            NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Registering new constants with identical names to previously-defined constants will overwrite existing constants with the following names: %@", intersectingConstants]
        }];
    }
    NSMutableDictionary *mergedConstants = [existingConstants mutableCopy];
    [mergedConstants addEntriesFromDictionary:parsedConstants];
    return [mergedConstants copy];
}

- (NSDictionary *)mergeParsedClasses:(NSDictionary *)parsedClasses intoExistingClasses:(NSDictionary *)existingClasses error:(NSError *__autoreleasing *)error
{
    NSSet *intersectingClasses = [existingClasses aut_intersectingKeysWithDictionary:parsedClasses];
    if (intersectingClasses.count && error) {
        *error = [NSError errorWithDomain:AUTThemingErrorDomain code:1 userInfo:@{
            NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Registering new classes with identical names to previously-defined classes will overwrite existing classes with the following names: %@", intersectingClasses]
        }];
    }
    NSMutableDictionary *mergedClasses = [existingClasses mutableCopy];
    [mergedClasses addEntriesFromDictionary:parsedClasses];
    return [mergedClasses copy];
}

@end

@implementation AUTThemeSymbolReference

@dynamic symbol;
@dynamic type;

- (instancetype)initWithRawSymbol:(NSString *)rawSymbol
{
    NSParameterAssert(rawSymbol.aut_isRawSymbolReference);
    self = [super init];
    if (self) {
        _rawSymbol = rawSymbol;
    }
    return self;
}

- (NSString *)symbol
{
    return self.rawSymbol.aut_symbol;
}

- (AUTThemeSymbolType)type
{
    return self.rawSymbol.aut_symbolType;
}

@end

@implementation NSDictionary (DictionaryValueValidation)

- (NSDictionary *)aut_dictionaryValueForKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    NSDictionary *value = self[key];
    // If there is no value for the specified key, is it not an error, just return
    if (!value) {
        return nil;
    }
    // If the value for the specified key is a dictionary but is not a valid type, return with error
    if (![value isKindOfClass:[NSDictionary class]]) {
        if (error) {
            *error = [NSError errorWithDomain:AUTThemingErrorDomain code:1 userInfo:@{
                NSLocalizedDescriptionKey : [NSString stringWithFormat:@"The value for the key '%@' is not a dictionary", key]
            }];
        }
        return nil;
    }
    return value;
}

@end
