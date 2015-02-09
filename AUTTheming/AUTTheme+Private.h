//
//  AUTTheme+Private.h
//  AUTTheming
//
//  Created by Eric Horacek on 12/23/14.
//
//

extern NSString * const AUTThemeConstantsKey;
extern NSString * const AUTThemeClassesKey;
extern NSString * const AUTThemeSuperclassKey;

@interface AUTTheme ()

/**
 If the JSON at the specified URL does not exist or is unable to be parsed, an error is returned in the pass-by-reference error parameter.
 */
- (void)addAttributesFromThemeAtURL:(NSURL *)URL error:(NSError **)error;

- (void)addConstantsAndClassesFromRawAttributesDictionary:(NSDictionary *)dictionary error:(NSError *__autoreleasing *)error;

@property (nonatomic) NSArray *filenames;
@property (nonatomic) NSArray *fileURLs;

@property (nonatomic) NSArray *names;
@property (nonatomic) NSDictionary *mappedConstants;
@property (nonatomic) NSDictionary *mappedClasses;

@end

@interface AUTTheme (Testing)

- (instancetype)initWithRawAttributesDictionary:(NSDictionary *)dictionary error:(NSError **)error;

- (instancetype)initWithRawAttributesDictionaries:(NSArray *)dictionaries error:(NSError **)error;

@end
