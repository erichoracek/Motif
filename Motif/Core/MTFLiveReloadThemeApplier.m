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

- (BOOL)setTheme:(MTFTheme *)theme error:(NSError **)error {
    NSParameterAssert(theme);

    self.themeSourceObserver = [self createThemeSourceObserverFromTheme:theme];
    return [super setTheme:theme error:error];
}

#pragma mark - MTFLiveReloadThemeApplier

#pragma mark Public

- (instancetype)initWithTheme:(MTFTheme *)theme sourceFile:(char const *)sourceFile {
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

    self = [super initWithTheme:theme];
    
    _sourceDirectoryURL = sourceDirectoryURL;
    _themeSourceObserver = [self createThemeSourceObserverFromTheme:theme];

    return self;
}

#pragma mark Private

- (MTFThemeSourceObserver *)createThemeSourceObserverFromTheme:(MTFTheme *)theme {
    __weak typeof(self) __weak_self = self;

    return [[MTFThemeSourceObserver alloc]
        initWithTheme:theme
        sourceDirectoryURL:self.sourceDirectoryURL
        didUpdate:^(MTFTheme *theme, NSError *error) {
            typeof(__weak_self) self = __weak_self;

            if (theme == nil) {
                NSLog(@"Error loading live-reloaded theme: %@", error);
                return;
            }

            NSError *applicationError;
            if (![self setTheme:theme error:&applicationError]) {
                NSLog(@"Error applying live-reloaded theme: %@", applicationError);
            }
        }];
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
