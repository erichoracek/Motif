//
//  MTFYAMLSerialization.m
//  Motif
//
//  Created by Eric Horacek on 5/25/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#include <yaml.h>

#import "MTFYAMLSerialization.h"

NS_ASSUME_NONNULL_BEGIN

@interface MTFYAMLSerialization ()

- (instancetype)initWithData:(NSData *)data error:(NSError **)error NS_DESIGNATED_INITIALIZER;

@property (readonly, nonatomic) NSRegularExpression *integerRegularExpression;
@property (readonly, nonatomic) NSRegularExpression *floatRegularExpression;
@property (readonly, nonatomic) NSDictionary<NSString *, id> *constantTags;
@property (readonly, nonatomic) NSMutableDictionary *tagHandlers;
@property (readonly, nonatomic, nullable) id object;

@end

@implementation MTFYAMLSerialization

#pragma mark - Lifecycle

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Use the designated initializer instead" userInfo:nil];
}

- (instancetype)initWithData:(NSData *)data error:(NSError **)error {
    NSParameterAssert(data != nil);

    self = [super init];

    _tagHandlers = [NSMutableDictionary dictionary];

    // From http://yaml.org/spec/1.2/spec.html#id2804356
    _integerRegularExpression = [NSRegularExpression
        regularExpressionWithPattern:@"^-?(0|[1-9][0-9]*)$"
        options:0
        error:NULL];

    // From http://yaml.org/spec/1.2/spec.html#id2804356
    _floatRegularExpression = [NSRegularExpression
        regularExpressionWithPattern:@"^-?(0|[1-9][0-9]*)(\\.[0-9]*)?([eE][-+]?[0-9]+)?$"
        options:0
        error:NULL];

    _constantTags = @{
        // From http://yaml.org/spec/1.2/spec.html#id2803362
        @"null": NSNull.null,
        // From http://yaml.org/spec/1.2/spec.html#id2803629
        @"true": @YES,
        @"false": @NO,
        // From http://yaml.org/spec/1.2/spec.html#id2804092
        @".inf" : @(INFINITY),
        @"-.inf" : @(-INFINITY),
        @".nan" : [NSDecimalNumber notANumber],
    };

    [self registerHandlers];

    _object = [self deserializeData:data error:error];

    return self;
}

#pragma mark - Public

+ (nullable id)YAMLObjectWithData:(NSData *)data error:(NSError **)error {
    MTFYAMLSerialization *serialization = [[self alloc] initWithData:data error:error];
    return serialization.object;
}

#pragma mark - Private

- (void)registerMappingForTag:(NSString *)tag map:(id (^)(NSString *))map {
    self.tagHandlers[tag] = [map copy];
}

- (void)registerHandlers {
    [self
        registerMappingForTag:@(YAML_NULL_TAG)
        map:^(NSString *value) {
            return NSNull.null;
        }];

    [self
        registerMappingForTag:@(YAML_BOOL_TAG)
        map:^(NSString *value) {
            return @(value.boolValue);
        }];

    [self
        registerMappingForTag:@(YAML_STR_TAG)
        map:^id(NSString *value) {
            return value;
        }];

    [self
        registerMappingForTag:@(YAML_INT_TAG)
        map:^(NSString *value) {
            return @(value.integerValue);
        }];

    [self
        registerMappingForTag:@(YAML_FLOAT_TAG)
        map:^(NSString *value) {
            return @(value.doubleValue);
        }];
}

- (nullable id)deserializeData:(NSData*)data error:(NSError **)error {
    if (data.length == 0) {
        return nil;
    }

    yaml_parser_t *parser = NULL;
    parser = malloc(sizeof(*parser));
    if (parser == NULL) return nil;

    yaml_parser_initialize(parser);
    yaml_parser_set_input_string(parser, data.bytes, data.length);

    NSArray *documents = [self parseDocumentsWithParser:parser error:error];

    yaml_parser_delete(parser);
    free(parser);

    return documents.firstObject;
}

- (nullable NSArray *)parseDocumentsWithParser:(yaml_parser_t *)parser error:(NSError **)error {
    NSMutableArray *documents = [NSMutableArray array];

    BOOL didParseDocuments = [self parseDocumentComponent:documents withParser:parser error:error];
    if (!didParseDocuments) return nil;

    return [documents copy];
}

- (BOOL)parseDocumentComponent:(id)documentComponent withParser:(yaml_parser_t *)parser error:(NSError **)error {
    NSParameterAssert(documentComponent != nil);
    NSParameterAssert(parser != NULL);

    __unused BOOL isMutableCollectionType = (
        [documentComponent isKindOfClass:NSMutableArray.class] ||
        [documentComponent isKindOfClass:NSMutableDictionary.class]
    );
    NSAssert(
        isMutableCollectionType,
        @"Document component must be a mutable collection type");

    id parsedKey;
    BOOL isDoneParsing = NO;

    while (!isDoneParsing) {
        yaml_event_t event;
        int parseResult = yaml_parser_parse(parser, &event);

        if (parseResult == 0) {
            return [self populateParseError:error fromParser:parser];
        }

        id parsedObject;

        switch (event.type) {
        case YAML_DOCUMENT_START_EVENT: {
            BOOL didParseDocument = [self
                parseDocumentComponent:documentComponent
                withParser:parser
                error:error];

            if (!didParseDocument) return NO;
        }

        break;
        case YAML_SCALAR_EVENT:
            if (event.data.scalar.anchor != NULL) {
                return [self populateInvalidAnchorError:error fromParser:parser];
            }

            parsedObject = [self valueForScalarEvent:&event fromParser:parser error:error];
            if (parsedObject == nil) return NO;

        break;
        case YAML_SEQUENCE_START_EVENT: {
            NSMutableArray *sequence = [NSMutableArray array];

            BOOL didParseSequence = [self
                parseDocumentComponent:sequence
                withParser:parser
                error:error];

            if (!didParseSequence) return NO;

            parsedObject = [sequence copy];
        }

        break;
        case YAML_MAPPING_START_EVENT: {
            NSMutableDictionary *mapping = [NSMutableDictionary dictionary];

            BOOL didParseMapping = [self
                parseDocumentComponent:mapping
                withParser:parser
                error:error];

            if (!didParseMapping) return NO;

            parsedObject = [mapping copy];
        }

        break;
        case YAML_STREAM_END_EVENT:
        case YAML_DOCUMENT_END_EVENT:
        case YAML_SEQUENCE_END_EVENT:
        case YAML_MAPPING_END_EVENT:
            isDoneParsing = YES;

        break;
        case YAML_ALIAS_EVENT:
            return [self populateInvalidAliasError:error fromParser:parser];

        default:
        break;
        }

        yaml_event_delete(&event);

        if (parsedObject == nil) {
            continue;
        }

        if ([documentComponent isKindOfClass:NSMutableArray.class]) {
            [documentComponent addObject:parsedObject];
        }
        else if ([documentComponent isKindOfClass:NSMutableDictionary.class]) {
            // First, populate the key
            if (parsedKey == nil) {
                parsedKey = parsedObject;
            }
            // Then, populate the value for the key
            else {
                documentComponent[parsedKey] = parsedObject;
                parsedKey = nil;
            }
        }
    }

    return YES;
}

#pragma mark - Scalars

- (nullable id)tagForScalarEvent:(yaml_event_t *)event {
    if (event->data.scalar.tag != NULL) return @((char *)event->data.scalar.tag);

    switch ((int)event->data.scalar.style) {
    case YAML_SINGLE_QUOTED_SCALAR_STYLE:
    case YAML_DOUBLE_QUOTED_SCALAR_STYLE:
    case YAML_LITERAL_SCALAR_STYLE:
        return @(YAML_STR_TAG);
    }

    NSString *stringValue = @((char *)event->data.scalar.value);

    NSUInteger numberOfIntegerMatches = [self.integerRegularExpression
        numberOfMatchesInString:stringValue
        options:0
        range:NSMakeRange(0, stringValue.length)];

    if (numberOfIntegerMatches == 1) return @(YAML_INT_TAG);

    NSUInteger numberOfFloatMatches = [self.floatRegularExpression
        numberOfMatchesInString:stringValue
        options:0
        range:NSMakeRange(0, stringValue.length)];

    if (numberOfFloatMatches == 1) return @(YAML_FLOAT_TAG);

    return nil;
}

- (nullable id)valueForScalarEvent:(yaml_event_t *)event fromParser:(yaml_parser_t *)parser error:(NSError **)error {
    NSString *tag = [self tagForScalarEvent:event];
    NSString *stringValue = @((char *)event->data.scalar.value);
    
    id value;

    if (tag != nil) {
        id (^tagHandler)(NSString*) = self.tagHandlers[tag];

        if (tagHandler != nil) {
            value = tagHandler(stringValue);
        } else {
            if (error != NULL) {
                NSMutableDictionary<NSString *, id> *userInfo = [self
                    errorUserInfoForMark:parser->mark
                    offset:parser->offset
                    fromParser:parser];

                userInfo[NSLocalizedDescriptionKey] = [NSString stringWithFormat:
                    NSLocalizedString(@"Unhandled tag type: %@ (value: %@)", nil),
                    tag,
                    stringValue];

                *error = [NSError errorWithDomain:MTFYAMLSerializationErrorDomain code:-1 userInfo:[userInfo copy]];
            }

            return nil;
        }
    }

    if (value == nil) {
        value = self.constantTags[stringValue];
    }

    if (value == nil) return stringValue;

    return value;
}

#pragma mark - Error handling

- (BOOL)populateParseError:(NSError **)error fromParser:(yaml_parser_t *)parser {
    if (error != NULL) {
        NSMutableDictionary<NSString *, id> *userInfo = [self
            errorUserInfoForMark:parser->problem_mark
            offset:parser->problem_offset
            fromParser:parser];

        const char *problem = parser->problem;
        if (problem != NULL) {
            NSString *string = @(problem);

            userInfo[NSLocalizedDescriptionKey] = string;
        }

        const char *context = parser->context;
        if (context != NULL) {
            NSString *string = @(context);

            userInfo[MTFYAMLSerializationContextDescriptionErrorKey] = string;
        }

        *error = [NSError errorWithDomain:MTFYAMLSerializationErrorDomain code:parser->error userInfo:[userInfo copy]];
    }

    return NO;
}

- (BOOL)populateInvalidAliasError:(NSError **)error fromParser:(yaml_parser_t *)parser {
    if (error != NULL) {
        NSMutableDictionary<NSString *, id> *userInfo = [self
            errorUserInfoForMark:parser->mark
            offset:parser->offset
            fromParser:parser];

        userInfo[NSLocalizedDescriptionKey] = NSLocalizedString(
            @"YAML aliases (denoted by a leading '*') are not supported in Motif "
                "theme files.",
            nil),

        *error = [NSError errorWithDomain:MTFYAMLSerializationErrorDomain code:-1 userInfo:[userInfo copy]];
    }

    return NO;
}

- (BOOL)populateInvalidAnchorError:(NSError **)error fromParser:(yaml_parser_t *)parser {
    if (error != NULL) {
        NSMutableDictionary<NSString *, id> *userInfo = [self
            errorUserInfoForMark:parser->mark
            offset:parser->offset
            fromParser:parser];

        userInfo[NSLocalizedDescriptionKey] = NSLocalizedString(
            @"YAML anchors (denoted by a leading '&') are not supported in Motif "
                "theme files.",
            nil);

        *error = [NSError errorWithDomain:MTFYAMLSerializationErrorDomain code:-1 userInfo:[userInfo copy]];
    }

    return NO;
}

- (NSMutableDictionary<NSString *, id> *)errorUserInfoForMark:(yaml_mark_t)mark offset:(size_t)offset fromParser:(yaml_parser_t *)parser {
    NSMutableDictionary<NSString *, id> *userInfo = [NSMutableDictionary dictionaryWithDictionary:@{
        MTFYAMLSerializationOffsetErrorKey: @(offset),
        MTFYAMLSerializationLineErrorKey: @(mark.line),
        MTFYAMLSerializationColumnErrorKey: @(mark.column),
        MTFYAMLSerializationIndexErrorKey: @(mark.index)
    }];

    // Add the line contents to the user info if able
    NSString *input = @((char *)parser->input.string.start);
    NSArray *inputLines = [input componentsSeparatedByCharactersInSet:NSCharacterSet.newlineCharacterSet];

    size_t problemLineIndex = (mark.line - 1);
    if (problemLineIndex < inputLines.count) {
        NSString *string = inputLines[problemLineIndex];

        userInfo[MTFYAMLSerializationLineContentsErrorKey] = string;
    }

    return userInfo;
}

@end

NSString * const MTFYAMLSerializationErrorDomain = @"MTFYAMLSerializationErrorDomain";

NSString * const MTFYAMLSerializationOffsetErrorKey = @"MTFYAMLSerializationOffsetErrorKey";

NSString * const MTFYAMLSerializationLineErrorKey = @"MTFYAMLSerializationLineErrorKey";

NSString * const MTFYAMLSerializationColumnErrorKey = @"MTFYAMLSerializationColumnErrorKey";

NSString * const MTFYAMLSerializationIndexErrorKey = @"MTFYAMLSerializationIndexErrorKey";

NSString * const MTFYAMLSerializationContextDescriptionErrorKey = @"MTFYAMLSerializationContextDescriptionErrorKey";

NSString * const MTFYAMLSerializationLineContentsErrorKey = @"MTFYAMLSerializationLineContentsErrorKey";

NS_ASSUME_NONNULL_END
