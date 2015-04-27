//
//  MTFLiveReloadThemeApplier.m
//  Motif
//
//  Created by Eric Horacek on 4/25/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "MTFLiveReloadThemeApplier.h"
#import "MTFThemeSourceObserver.h"

MTF_NS_ASSUME_NONNULL_BEGIN

@interface MTFLiveReloadThemeApplier ()

@property (nonatomic) MTFThemeSourceObserver *themeSourceObserver;

@end

@implementation MTFLiveReloadThemeApplier

#pragma mark - MTFDynamicThemeApplier

- (instancetype)initWithTheme:(MTFTheme *)theme {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    // Ensure that exception is thrown when just `initWithTheme:` is called.
    return [self initWithTheme:theme sourceDirectoryPath:nil];
#pragma clang diagnostic pop
}

- (void)setTheme:(MTFTheme *)theme {
    NSParameterAssert(theme);
    
    __weak typeof(self) __weak_self = self;
    
    self.themeSourceObserver = [[MTFThemeSourceObserver alloc]
        initWithTheme:theme
        sourceDirectoryPath:self.sourceDirectoryPath
        didUpdate:^(MTFTheme *theme, NSError *error) {
            __weak typeof(self) self = __weak_self;
            
            [self setSuperTheme:theme];
        }];
    
    super.theme = self.themeSourceObserver.updatedTheme;
}

#pragma mark - MTFLiveReloadThemeApplier

#pragma mark Public

- (instancetype)initWithTheme:(MTFTheme *)theme sourceFile:(char *)sourceFile {
    NSParameterAssert(theme);
    NSParameterAssert(sourceFile);
    
    NSString *sourceFilePath = [NSString stringWithUTF8String:sourceFile];
    NSString *sourceDirectoryPath = [self pathForSourceDirectoryFromSourceFilePath:sourceFilePath];
    
    return [self initWithTheme:theme sourceDirectoryPath:sourceDirectoryPath];
}

- (instancetype)initWithTheme:(MTFTheme *)theme sourceDirectoryPath:(NSString *)sourceDirectoryPath {
    NSParameterAssert(theme);
    NSParameterAssert(sourceDirectoryPath);
    
    __weak typeof(self) __weak_self = self;
    
    MTFThemeSourceObserver *themeSourceObserver = [[MTFThemeSourceObserver alloc]
        initWithTheme:theme
        sourceDirectoryPath:sourceDirectoryPath
        didUpdate:^(MTFTheme *theme, NSError *error) {
            __weak typeof(self) self = __weak_self;
            
            [self setSuperTheme:theme];
        }];
    
    self = [super initWithTheme:themeSourceObserver.updatedTheme];
    if (self == nil) return nil;
    
    _sourceDirectoryPath = [sourceDirectoryPath copy];
    
    _themeSourceObserver = themeSourceObserver;

    return self;
}

#pragma mark Private

- (void)setSuperTheme:(MTFTheme *)theme {
    super.theme = theme;
}

- (NSString *)pathForSourceDirectoryFromSourceFilePath:(NSString *)sourceFilePath {
    NSParameterAssert(sourceFilePath);
    
    BOOL fileExists = [NSFileManager.defaultManager fileExistsAtPath:sourceFilePath];
    
    NSAssert(
        fileExists,
        @"File at path %@ does not exist. Perhaps you used a live reload theme "
            "applier on device rather than on the iOS Simulator?",
        sourceFilePath);
    
    NSString *sourceFileDirectoryPath = sourceFilePath.stringByDeletingLastPathComponent;
    
    BOOL isDirectory = NO;
    BOOL directoryExists = [NSFileManager.defaultManager fileExistsAtPath:sourceFileDirectoryPath isDirectory:&isDirectory];
    
    NSAssert(
        isDirectory && directoryExists,
        @"Source file path must be contained in a valid directory");
    
    return sourceFileDirectoryPath;
}

@end

MTF_NS_ASSUME_NONNULL_END
