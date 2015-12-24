//
//  MTFLiveReloadThemeApplier.m
//  Motif
//
//  Created by Eric Horacek on 4/25/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "MTFLiveReloadThemeApplier.h"
#import "MTFThemeSourceObserver.h"

NS_ASSUME_NONNULL_BEGIN

@interface MTFLiveReloadThemeApplier ()

@property (nonatomic) MTFThemeSourceObserver *themeSourceObserver;

@end

@implementation MTFLiveReloadThemeApplier

#pragma mark - MTFDynamicThemeApplier

- (instancetype)initWithTheme:(MTFTheme *)theme {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Use the designated initializer instead" userInfo:nil];
}

- (void)setTheme:(MTFTheme *)theme {
    NSParameterAssert(theme);
    
    __weak typeof(self) __weak_self = self;
    
    self.themeSourceObserver = [[MTFThemeSourceObserver alloc]
        initWithTheme:theme
        sourceDirectoryURL:self.sourceDirectoryURL
        didUpdate:^(MTFTheme *theme, NSError *error) {
            typeof(__weak_self) self = __weak_self;
            
            [self safelySetTheme:theme];
        }];
    
    super.theme = self.themeSourceObserver.updatedTheme;
}

#pragma mark - MTFLiveReloadThemeApplier

#pragma mark Public

- (instancetype)initWithTheme:(MTFTheme *)theme sourceFile:(char *)sourceFile {
    NSParameterAssert(theme);
    NSParameterAssert(sourceFile);
    
    NSURL *sourceFileURL = [NSURL
        fileURLWithFileSystemRepresentation:sourceFile
        isDirectory:NO
        relativeToURL:nil];

    NSURL *sourceDirectoryURL = [self URLForSourceDirectoryFromSourceFileURL:sourceFileURL];
    
    return [self initWithTheme:theme sourceDirectoryURL:sourceDirectoryURL];
}

- (instancetype)initWithTheme:(MTFTheme *)theme sourceDirectoryURL:(NSURL *)sourceDirectoryURL {
    NSParameterAssert(theme);
    NSParameterAssert(sourceDirectoryURL);
    
    NSAssert(sourceDirectoryURL.isFileURL, @"Source directory URL must be file URL");
    
    NSError *error;
    NSNumber *isDirectory;
    __unused BOOL resourceValueQuerySuccess = [sourceDirectoryURL
        getResourceValue:&isDirectory
        forKey:NSURLIsDirectoryKey
        error:&error];

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
            typeof(__weak_self) self = __weak_self;
            
            [self safelySetTheme:theme];
        }];
    
    self = [super initWithTheme:themeSourceObserver.updatedTheme];
    
    _sourceDirectoryURL = sourceDirectoryURL;
    _themeSourceObserver = themeSourceObserver;

    return self;
}

#pragma mark Private

- (void)safelySetTheme:(MTFTheme *)theme {
    // Catch runtime exceptions when reloading a theme due to live reload. This
    // prevents the consumer from having to re-build and re-run if they mistype
    // a property name during live reload.
    @try {
        super.theme = theme;
    }
    @catch (NSException *exception) {
#ifdef DEBUG
        NSLog(
            @"Exception raised while attempting to reapply the reloaded theme. "
                "This exception will not be caught outside the context "
                "of live reloading. Exception:\n%@",
            exception);
#endif
    }
}

- (nullable NSURL *)URLForSourceDirectoryFromSourceFileURL:(NSURL *)sourceFileURL {
    NSParameterAssert(sourceFileURL);
    
    NSError *error;
    __unused BOOL isReachable = [sourceFileURL checkResourceIsReachableAndReturnError:&error];
    
    NSAssert(
        isReachable,
        @"File at URL %@ does not exist. Perhaps you used a live reload theme "
            "applier on device rather than on the iOS Simulator? Error: %@",
        sourceFileURL,
        error);
    
    return sourceFileURL.URLByDeletingLastPathComponent;
}

@end

NS_ASSUME_NONNULL_END
