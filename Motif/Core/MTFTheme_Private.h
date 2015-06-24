//
//  MTFTheme_Private.h
//  Motif
//
//  Created by Eric Horacek on 12/23/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Motif/MTFTheme.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTFTheme ()

/**
 The names of the themes files that were added to the theme, in the order that
 they were added.
 
 Does not include the extension of the theme name, nor the 'Theme' suffix if in
 the filename. If the filename is "Filename.json", the name will be "Filename".
 If the filename is "ColorsTheme.json", the name will be "Colors".
 */
@property (nonatomic, copy, readonly) NSArray *names;

/**
 The filenames of the themes files that were added to the theme, in the order
 that they were added, without an extension.
 
 If the file name is "Filename.json", the file name will be "Filename".
 */
@property (nonatomic, copy, readonly) NSArray *filenames;

/**
 The URLs of the theme files that were added to the theme, in the order that
 they were added in.
 */
@property (nonatomic, copy, null_resettable) NSArray *fileURLs;

/**
 The MTFThemeConstant instances on the theme, keyed by their names.
 */
@property (nonatomic, copy, null_resettable) NSDictionary *constants;

/**
 The MTFThemeClass instances on the theme, keyed by their names.
 */
@property (nonatomic, copy, null_resettable) NSDictionary *classes;

@end

NS_ASSUME_NONNULL_END
