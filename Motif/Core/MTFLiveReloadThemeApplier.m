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
    return [self initWithTheme:theme sourceDirectoryURL:nil];
#pragma clang diagnostic pop
}

- (void)setTheme:(MTFTheme *)theme {
    NSParameterAssert(theme);
    
    __weak typeof(self) __weak_self = self;
    
    self.themeSourceObserver = [[MTFThemeSourceObserver alloc]
        initWithTheme:theme
        sourceDirectoryURL:self.sourceDirectoryURL
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
    
    NSURL *sourceFileURL = [NSURL fileURLWithFileSystemRepresentation:sourceFile isDirectory:NO relativeToURL:nil];
    NSURL *sourceDirectoryURL = [self URLForSourceDirectoryFromSourceFileURL:sourceFileURL];
    
    return [self initWithTheme:theme sourceDirectoryURL:sourceDirectoryURL];
}

- (instancetype)initWithTheme:(MTFTheme *)theme sourceDirectoryURL:(NSURL *)sourceDirectoryURL {
    NSParameterAssert(theme);
    NSParameterAssert(sourceDirectoryURL);
    
    NSAssert(sourceDirectoryURL.isFileURL, @"Source directory URL must be file URL");
    
    NSError *error;
    NSNumber *isDirectory;
    __unused BOOL resourceValueQuerySuccess = [sourceDirectoryURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error];
    
    NSAssert(
        resourceValueQuerySuccess && isDirectory.boolValue,
        @"Source directory (%@) is not a valid directory. Error: %@",
        sourceDirectoryURL,
        error);
    
    __weak typeof(self) __weak_self = self;
    
    MTFThemeSourceObserver *themeSourceObserver = [[MTFThemeSourceObserver alloc]
        initWithTheme:theme
        sourceDirectoryURL:sourceDirectoryURL
        didUpdate:^(MTFTheme *theme, NSError *error) {
            __weak typeof(self) self = __weak_self;
            
            [self setSuperTheme:theme];
        }];
    
    self = [super initWithTheme:themeSourceObserver.updatedTheme];
    if (self == nil) return nil;
    
    _sourceDirectoryURL = sourceDirectoryURL;
    _themeSourceObserver = themeSourceObserver;

    return self;
}

#pragma mark Private

- (void)setSuperTheme:(MTFTheme *)theme {
    super.theme = theme;
}

- (mtf_nullable NSURL *)URLForSourceDirectoryFromSourceFileURL:(NSURL *)sourceFileURL {
    NSParameterAssert(sourceFileURL);
    
    NSError *error;
    __unused BOOL isReachable = [sourceFileURL checkResourceIsReachableAndReturnError:&error];
    
    NSAssert(
        isReachable,
        @"File at path %@ does not exist. Perhaps you used a live reload theme "
            "applier on device rather than on the iOS Simulator? Error %@",
        sourceFileURL,
        error);
    
    return sourceFileURL.URLByDeletingLastPathComponent;
}

@end

MTF_NS_ASSUME_NONNULL_END
