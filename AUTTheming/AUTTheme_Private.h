//
//  AUTTheme_Private.h
//  AUTTheming
//
//  Created by Eric Horacek on 12/23/14.
//
//

@interface AUTTheme ()

/**
 The names of the JSON themes that were added to the theme, in the order that they were added in.
 
 Does not include the extension of the theme name. If the file name is "Filename.json", the name will be "Filename". If the name is "ColorsTheme.json", the name will be "Colors".
 */
@property (nonatomic) NSArray *names;

/**
 The filenames of the JSON themes that were added to the theme, in the order that they were added in.
 
 If the file name is "Filename.json", the file name will be "Filename".
 */
@property (nonatomic) NSArray *filenames;

/**
 The URLs of the JSON themes that were added to the theme, in the order that they were added in.
 */
@property (nonatomic) NSArray *fileURLs;

/**
 The AUTThemeConstant instances on the theme, keyed by their names.
 */
@property (nonatomic) NSDictionary *constants;

/**
 The AUTThemeClass instances on the theme, keyed by their names.
 */
@property (nonatomic) NSDictionary *classes;

@end

@interface AUTTheme (Testing)

- (instancetype)initWithRawTheme:(NSDictionary *)rawTheme error:(NSError **)error;

- (instancetype)initWithRawThemes:(NSArray *)rawThemes error:(NSError **)error;

@end
