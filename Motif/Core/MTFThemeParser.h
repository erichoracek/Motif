//
//  MTFThemeParser.h
//  Motif
//
//  Created by Eric Horacek on 2/11/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MTFTheme;
@class MTFThemeClass;
@class MTFThemeConstant;

NS_ASSUME_NONNULL_BEGIN

/**
 Parses a raw theme into its classes and constants, optionally inheriting 
 exiting classes and constants from another theme.
 */
@interface MTFThemeParser : NSObject

- (instancetype)init NS_UNAVAILABLE;

/**
 Initializes a theme parser with a raw theme and parses it, populating the
 parsedConstants and parsedClasses properties synchronously.
 
 @param rawTheme The raw theme that should be parsed by this parser.
 @param theme    The theme that this parsed theme should inherit its classes
                 and properties from.
 @param error    A pass-by-reference error, populated if a parsing error
                 occurred.
 
 @return An initialized theme parser.
 */
- (instancetype)initWithRawTheme:(NSDictionary<NSString *, id> *)rawTheme inheritingFromTheme:(nullable MTFTheme *)theme error:(NSError **)error NS_DESIGNATED_INITIALIZER;

/**
 The theme constants parsed from the raw theme.
 
 A dictionary keyed by theme constant names with values of MTFThemeConstant.
 */
@property (nonatomic, copy, readonly) NSDictionary<NSString *, MTFThemeConstant *> *parsedConstants;

/**
 The theme classes parsed from the raw theme.
 
 A dictionary keyed by theme class names with values of MTFThemeClass.
 */
@property (nonatomic, copy, readonly) NSDictionary<NSString *, MTFThemeClass *> *parsedClasses;

/**
 Whether theme parsers should globally resolve their constants, producing errors
 when references are invalid.
 
 @param shouldResolveReferences Whether references should be resolved.
 */
+ (void)setShouldResolveReferences:(BOOL)shouldResolveReferences;

@end

NS_ASSUME_NONNULL_END
