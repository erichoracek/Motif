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

typedef NS_ENUM(NSInteger, MTFParseMode) {
    MTFParseModeStream,
    MTFParseModeDocument,
    MTFParseModeSequence,
    MTFParseModeMapping,
};

@interface MTFYAMLSerialization ()

- (instancetype)initWithData:(NSData *)data error:(NSError *__autoreleasing *)error NS_DESIGNATED_INITIALIZER;

@property (readonly, nonatomic, strong) NSRegularExpression *integerRegularExpression;
@property (readonly, nonatomic, strong) NSRegularExpression *floatRegularExpression;
@property (readonly, nonatomic, strong) NSDictionary *constantTags;
@property (readonly, nonatomic, strong) NSMutableDictionary *objectsForAnchors;
@property (readonly, nonatomic, strong) NSMutableDictionary *tagHandlers;
@property (readonly, nonatomic, strong, mtf_nullable) id object;

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
    _objectsForAnchors = [NSMutableDictionary dictionary];

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

- (mtf_nullable id)deserializeData:(NSData*)data error:(NSError *__autoreleasing*)outError {
    yaml_parser_t *parser = NULL;
    parser = malloc(sizeof(*parser));
    if (parser == NULL) {
        return nil;
    }

    yaml_parser_initialize(parser);
    yaml_parser_set_input_string(parser, data.bytes, data.length);

    NSArray *documents = [self parseDocumentsWithParser:parser error:outError];

    yaml_parser_delete(parser);
    free(parser);

    return documents.firstObject;
}

- (mtf_nullable NSArray *)parseDocumentsWithParser:(yaml_parser_t *)parser error:(NSError *__autoreleasing *)outError {
    NSError *error;
    NSMutableArray *documents = [NSMutableArray array];

    [self parseDocumentComponent:documents inMode:MTFParseModeStream withParser:parser error:&error];

    if (error != NULL) {
        if (outError != NULL) *outError = error;
        return nil;
    }

    return [documents copy];
}

- (BOOL)parseDocumentComponent:(id)documentComponent inMode:(MTFParseMode)mode withParser:(yaml_parser_t *)parser error:(NSError *__autoreleasing *)outError {
    id key;
    NSError *error;
    BOOL isDone = NO;

    while (!isDone && error == nil) {
        yaml_event_t event;
        if (!yaml_parser_parse(parser, &event)) {
            error = [NSError
                errorWithDomain:@"libyaml"
                code:parser->error
                userInfo:@{
                    NSLocalizedDescriptionKey : @(parser->problem),
                    @"offset" : @(parser->offset),
                }];

            if (outError != NULL) {
                *outError = error;
            }
            return NO;
        }

        id object;
        NSString *anchor;

        switch (event.type) {
        case YAML_NO_EVENT:
            [self populateUnexpectedEvent:event fromParser:parser error:&error];

        break;
        case YAML_STREAM_START_EVENT:
            if (mode != MTFParseModeStream) {
                [self populateUnexpectedEvent:event fromParser:parser error:&error];
            }

        break;
        case YAML_STREAM_END_EVENT:
            if (mode != MTFParseModeStream) {
                [self populateUnexpectedEvent:event fromParser:parser error:&error];
            } else {
                isDone = YES;
            }

        break;
        case YAML_DOCUMENT_START_EVENT:
            if (mode != MTFParseModeStream) {
                [self populateUnexpectedEvent:event fromParser:parser error:&error];
            } else {
                [self parseDocumentComponent:documentComponent inMode:MTFParseModeDocument withParser:parser error:&error];
            }

        break;
        case YAML_DOCUMENT_END_EVENT:
            if (mode != MTFParseModeDocument) {
                [self populateUnexpectedEvent:event fromParser:parser error:&error];
            } else {
                isDone = YES;
            }

        break;
        case YAML_ALIAS_EVENT: {
            NSString *aliasAnchor = @((char *)event.data.alias.anchor);
            object = self.objectsForAnchors[aliasAnchor];

            if (object == NULL) {
                error = [NSError errorWithDomain:@"CocoaYAML"
                                               code:-1
                                           userInfo:@{
                                               NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Could not find tagged object with anchor %@", aliasAnchor],
                                               @"offset" : @(parser->offset),
                                           }];
            }

        }
        break;
        case YAML_SCALAR_EVENT:
            object = [self valueForScalarEvent:&event fromParser:parser error:&error];
            if (event.data.scalar.anchor != NULL) {
                anchor = @((char *)event.data.scalar.anchor);
            }

        break;
        case YAML_SEQUENCE_START_EVENT: {
            NSMutableArray *sequence = [NSMutableArray array];
            [self parseDocumentComponent:sequence inMode:MTFParseModeSequence withParser:parser error:&error];
            object = [sequence copy];

            if (event.data.sequence_start.anchor != NULL) {
                anchor = @((char *)event.data.sequence_start.anchor);
            }
        }

        break;
        case YAML_SEQUENCE_END_EVENT:
            if (mode != MTFParseModeSequence) {
                [self populateUnexpectedEvent:event fromParser:parser error:&error];
            } else {
                isDone = YES;
            }

        break;
        case YAML_MAPPING_START_EVENT: {
            NSMutableDictionary *mapping = [NSMutableDictionary dictionary];
            [self parseDocumentComponent:mapping inMode:MTFParseModeMapping withParser:parser error:&error];
            object = [mapping copy];

            if (event.data.mapping_start.anchor != NULL) {
                anchor = @((char *)event.data.mapping_start.anchor);
            }
        }

        break;
        case YAML_MAPPING_END_EVENT:
            if (mode != MTFParseModeMapping) {
                [self populateUnexpectedEvent:event fromParser:parser error:&error];
            }

            isDone = YES;

        break;
        default:
            [self populateUnexpectedEvent:event fromParser:parser error:&error];

        break;
        }

        yaml_event_delete(&event);

        if (error) {
            if (outError) {
                *outError = error;
            }
            return NO;
        }

        if (object) {
            if (anchor) {
                self.objectsForAnchors[anchor] = object;
            }

            switch (mode) {
            case MTFParseModeSequence:
            case MTFParseModeStream:
            case MTFParseModeDocument:
                NSCParameterAssert(documentComponent);
                NSCParameterAssert([documentComponent isKindOfClass:NSMutableArray.class]);

                [documentComponent addObject:object];

            break;
            case MTFParseModeMapping:
                NSCParameterAssert(documentComponent);
                NSCParameterAssert([documentComponent isKindOfClass:NSMutableDictionary.class]);

                if (key == nil) {
                    key = object;
                } else {
                    documentComponent[key] = object;
                    key = nil;
                }

            break;
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
        const yaml_scalar_style_t style = event->data.scalar.style;

        switch ((int)style) {
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
        }
        else {
            if (error) {
                *error = [NSError errorWithDomain:@"TODO"
                    code:-1
                    userInfo:@{
                    NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Unhandled tag type: %@ (value: %@)", tag, string],
                        @"offset" : @(parser->offset),
                    }];
            }
            return nil;
        }
    }

    if (value == nil) {
        value = self.constantTags[string.lowercaseString];
    }

    if (value == nil) {
        value = string;
    }

    return value;
}

- (BOOL)populateUnexpectedEvent:(yaml_event_t)event fromParser:(yaml_parser_t *)parser error:(NSError *__autoreleasing *)error {
    if (error == NULL) {
        return NO;
    }

    *error = [NSError
        errorWithDomain:@"CocoaYAML"
        code:-1
        userInfo:@{
            NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Received unexpected event %@.", @(event.type)],
            @"offset" : @(parser->offset)
        }];

    return NO;
}

@end

MTF_NS_ASSUME_NONNULL_END
