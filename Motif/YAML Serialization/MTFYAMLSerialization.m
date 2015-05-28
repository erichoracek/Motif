//
//  MTFYAMLSerialization.m
//  Motif
//
//  Created by Eric Horacek on 5/25/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#include <yaml.h>

#import "MTFYAMLSerialization.h"

MTF_NS_ASSUME_NONNULL_BEGIN

@interface MTFYAMLSerialization ()

- (instancetype)initWithData:(NSData *)data error:(NSError *__autoreleasing *)error NS_DESIGNATED_INITIALIZER;

@property (readonly, nonatomic) NSRegularExpression *integerRegularExpression;
@property (readonly, nonatomic) NSRegularExpression *floatRegularExpression;
@property (readonly, nonatomic) NSDictionary *constantTags;
@property (readonly, nonatomic) NSMutableDictionary *tagHandlers;
@property (readonly, nonatomic, mtf_nullable) id object;

@end

@implementation MTFYAMLSerialization

#pragma mark - Public

+ (mtf_nullable id)YAMLObjectWithData:(NSData *)data error:(NSError **)error {
    MTFYAMLSerialization *serialization = [[self alloc] initWithData:data error:error];
    return serialization.object;
}

#pragma mark - Private

- (instancetype)init {
    return [self initWithData:[NSData data] error:nil];
}

- (instancetype)initWithData:(NSData *)data error:(NSError *__autoreleasing *)error {
    NSParameterAssert(data);

    self = [super init];
    if (self == nil) return nil;

    _tagHandlers = [NSMutableDictionary dictionary];

    _integerRegularExpression = [NSRegularExpression
        regularExpressionWithPattern:@"^-?\\d+$"
        options:0
        error:NULL];

    _floatRegularExpression = [NSRegularExpression
        regularExpressionWithPattern:@"^(-?[1-9]\\d*(\\.\\d*)?(e[-+]?[1-9][0-9]+)?|0|inf|-inf|nan)$"
        options:0
        error:NULL];

    _constantTags = @{
        @"true" : @YES,
        @"false" : @NO,
        @"yes" : @YES,
        @"no" : @NO,
        @"null" : NSNull.null,
        @".inf" : @(INFINITY),
        @"-.inf" : @(-INFINITY),
        @"+.inf" : @(INFINITY),
        @".nan" : @(NAN),
    };

    [self registerHandlers];

    _object = [self deserializeData:data error:error];

    return self;
}

- (void)registerMappingForTag:(NSString *)tag map:(mtf_nullable id (^)(id, NSError *__autoreleasing *))map {
    if (map == nil) {
        map = ^(id value, NSError *__autoreleasing *_) {
            return value;
        };
    }

    self.tagHandlers[tag] = [map copy];
}

- (void)registerHandlers {
    [self
        registerMappingForTag:@(YAML_NULL_TAG)
        map:^(id value, NSError *__autoreleasing *_) {
            return NSNull.null;
        }];

    [self
        registerMappingForTag:@(YAML_BOOL_TAG)
        map:^(id value, NSError *__autoreleasing *_) {
            return @([value boolValue]);
        }];

    [self
        registerMappingForTag:@(YAML_STR_TAG)
        map:nil];

    [self
        registerMappingForTag:@(YAML_INT_TAG)
        map:^(id value, NSError *__autoreleasing *_) {
            return @([value integerValue]);
        }];

    [self
        registerMappingForTag:@(YAML_FLOAT_TAG)
        map:^(id value, NSError *__autoreleasing *_) {
            return @([value doubleValue]);
        }];
}

- (mtf_nullable id)deserializeData:(NSData*)data error:(NSError *__autoreleasing *)error {
    yaml_parser_t *parser = NULL;
    parser = malloc(sizeof(*parser));
    if (parser == NULL) {
        return nil;
    }

    yaml_parser_initialize(parser);
    yaml_parser_set_input_string(parser, data.bytes, data.length);

    NSArray *documents = [self parseDocumentsWithParser:parser error:error];

    yaml_parser_delete(parser);
    free(parser);

    return documents.firstObject;
}

- (mtf_nullable NSArray *)parseDocumentsWithParser:(yaml_parser_t *)parser error:(NSError *__autoreleasing *)error {
    NSMutableArray *documents = [NSMutableArray array];

    BOOL didParseDocuments = [self parseDocumentComponent:documents withParser:parser error:error];
    if (!didParseDocuments) return nil;

    return [documents copy];
}

- (BOOL)parseDocumentComponent:(id)documentComponent withParser:(yaml_parser_t *)parser error:(NSError *__autoreleasing *)error {
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
            if (event.data.sequence_start.anchor != NULL) {
                return [self populateInvalidAnchorError:error fromParser:parser];
            }

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
            if (event.data.mapping_start.anchor != NULL) {
                return [self populateInvalidAnchorError:error fromParser:parser];
            }

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

        break;
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

- (mtf_nullable id)valueForScalarEvent:(yaml_event_t *)event fromParser:(yaml_parser_t *)parser error:(NSError *__autoreleasing *)error {

    NSString *tag;
    if (event->data.scalar.tag != NULL) {
        tag = @((char *)event->data.scalar.tag);
    }

    if (tag == nil) {
        switch ((int)event->data.scalar.style) {
        case YAML_SINGLE_QUOTED_SCALAR_STYLE:
        case YAML_DOUBLE_QUOTED_SCALAR_STYLE:
        case YAML_LITERAL_SCALAR_STYLE:
            tag = @(YAML_STR_TAG);
        }
    }

    NSString *string = @((char *)event->data.scalar.value);

    if (tag == nil) {
        NSUInteger numberOfMatches = [self.integerRegularExpression
            numberOfMatchesInString:string
            options:0
            range:NSMakeRange(0, string.length)];

        if (numberOfMatches == 1) {
            tag = @(YAML_INT_TAG);
        }
    }

    if (tag == nil) {
        NSUInteger numberOfMatches = [self.floatRegularExpression
            numberOfMatchesInString:string
            options:0
            range:NSMakeRange(0, string.length)];

        if (numberOfMatches == 1) {
            tag = @(YAML_FLOAT_TAG);
        }
    }

    id value;

    if (tag != nil) {
        id (^handler)(NSString*, NSError *__autoreleasing *) = self.tagHandlers[tag];
        if (handler) {
            value = handler(string, error);
        } else {
            if (error == NULL) return nil;

            *error = [NSError errorWithDomain:MTFYAMLSerializationErrorDomain
                code:-1
                userInfo:@{
                    NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Unhandled tag type: %@ (value: %@)", tag, string],
                    MTFYAMLSerializationOffsetErrorKey : @(parser->offset),
                }];

            return nil;
        }
    }

    if (value == nil) value = self.constantTags[string.lowercaseString];
    if (value == nil) value = string;

    return value;
}

#pragma mark - Error handling

- (BOOL)populateParseError:(NSError *__autoreleasing *)error fromParser:(yaml_parser_t *)parser {
    if (error == NULL) return NO;

    NSMutableDictionary *userInfo = [self
        errorUserInfoForMark:parser->problem_mark
        offset:parser->problem_offset
        fromParser:parser];

    const char *problem = parser->context;
    if (problem != NULL) {
        NSString *string = [@(problem) capitalizedString];

        userInfo[NSLocalizedDescriptionKey] = string;
    }

    const char *context = parser->context;
    if (context != NULL) {
        NSString *string = [@(context) capitalizedString];

        userInfo[MTFYAMLSerializationContextDescriptionErrorKey] = string;
    }

    *error = [NSError errorWithDomain:MTFYAMLSerializationErrorDomain code:parser->error userInfo:[userInfo copy]];

    return NO;
}

- (BOOL)populateInvalidAliasError:(NSError *__autoreleasing *)error fromParser:(yaml_parser_t *)parser {
    if (error == NULL) return NO;

    NSMutableDictionary *userInfo = [self
        errorUserInfoForMark:parser->mark
        offset:parser->offset
        fromParser:parser];

    userInfo[NSLocalizedDescriptionKey] = NSLocalizedString(@"YAML aliases (denoted by a leading '*') are not supported in Motif theme files.", nil),

    *error = [NSError errorWithDomain:MTFYAMLSerializationErrorDomain code:-1 userInfo:[userInfo copy]];

    return NO;
}

- (BOOL)populateInvalidAnchorError:(NSError *__autoreleasing *)error fromParser:(yaml_parser_t *)parser {
    if (error == NULL) return NO;

    NSMutableDictionary *userInfo = [self
        errorUserInfoForMark:parser->mark
        offset:parser->offset
        fromParser:parser];

    userInfo[NSLocalizedDescriptionKey] = NSLocalizedString(@"YAML anchors (denoted by a leading '&') are not supported in Motif theme files.", nil);

    *error = [NSError errorWithDomain:MTFYAMLSerializationErrorDomain code:-1 userInfo:[userInfo copy]];

    return NO;
}

- (NSMutableDictionary *)errorUserInfoForMark:(yaml_mark_t)mark offset:(size_t)offset fromParser:(yaml_parser_t *)parser {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:@{
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

MTF_NS_ASSUME_NONNULL_END
