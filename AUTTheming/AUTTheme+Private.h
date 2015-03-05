//
//  AUTTheme+Private.h
//  AUTTheming
//
//  Created by Eric Horacek on 12/23/14.
//
//

@interface AUTTheme ()

/**
 If the JSON at the specified URL does not exist or is unable to be parsed, an error is returned in the pass-by-reference error parameter.
 */
- (void)addAttributesFromThemeAtURL:(NSURL *)URL error:(NSError **)error;

- (void)addConstantsAndClassesFromRawTheme:(NSDictionary *)dictionary error:(NSError *__autoreleasing *)error;

@property (nonatomic) NSArray *filenames;
@property (nonatomic) NSArray *fileURLs;

@property (nonatomic) NSArray *names;
@property (nonatomic) NSDictionary *mappedConstants;
@property (nonatomic) NSDictionary *mappedClasses;

@end

@interface AUTTheme (Testing)

- (instancetype)initWithRawTheme:(NSDictionary *)rawTheme error:(NSError **)error;

- (instancetype)initWithRawThemes:(NSArray *)rawThemes error:(NSError **)error;

@end
