//
//  MTFThemeSourceObserver.m
//  Motif
//
//  Created by Eric Horacek on 4/26/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "MTFThemeSourceObserver.h"
#import "MTFTheme.h"
#import "MTFTheme_Private.h"
#import "MTFFileObservationContext.h"

NS_ASSUME_NONNULL_BEGIN

@interface MTFThemeSourceObserver ()

@property (nonatomic, readonly) dispatch_queue_t fileObservationQueue;
@property (nonatomic) NSArray<MTFFileObservationContext *> *fileObservationContexts;
@property (nonatomic) MTFTheme *updatedTheme;
@property (nonatomic, nullable) NSError *updatedThemeError;

@end

@implementation MTFThemeSourceObserver

#pragma mark - Lifecycle

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Use the designated initializer instead" userInfo:nil];
}

- (instancetype)initWithTheme:(MTFTheme *)theme sourceDirectoryURL:(NSURL *)sourceDirectoryURL didUpdate:(MTFThemeDidUpdate)didUpdate {
    NSParameterAssert(theme != nil);
    NSParameterAssert(sourceDirectoryURL != nil);
    NSParameterAssert(didUpdate != nil);
    
    NSAssert(sourceDirectoryURL.isFileURL, @"Source directory URL must be a file URL");
    
    self = [super init];
    
    _fileObservationQueue = dispatch_queue_create(
        "com.erichoracek.motif.MTFThemeSourceObserver",
        DISPATCH_QUEUE_CONCURRENT);
    
    _sourceDirectoryURL = [sourceDirectoryURL copy];
    
    _fileObservationContexts = [self
        observeSourceFilesOfTheme:theme
        onQueue:self.fileObservationQueue
        didUpdate:didUpdate];
    
    return self;
}

- (void)dealloc {
    // Close all open files when deallocated
    for (MTFFileObservationContext *fileObservationContext in self.fileObservationContexts) {
        close(fileObservationContext.fileDescriptor);
    }
}

#pragma mark - MTFThemeSourceObserver

- (NSArray<NSString *> *)sourceFilePathsForTheme:(MTFTheme *)theme inSourceDirectoryURL:(NSURL *)sourceDirectoryURL {
    NSParameterAssert(theme != nil);
    NSParameterAssert(sourceDirectoryURL != nil);
    
    NSMutableArray<NSString *> *sourceFilePaths = [NSMutableArray array];
    
    for (NSString *filename in theme.filenames) {
        NSString *sourceFileRelativePath = [self sourceFilePathForThemeFilename:filename inSourceDirectoryURL:sourceDirectoryURL];
        
        NSString *sourceFilePath = [sourceDirectoryURL URLByAppendingPathComponent:sourceFileRelativePath].path;
        [sourceFilePaths addObject:sourceFilePath];
    }
    
    return [sourceFilePaths copy];
}

- (NSString *)sourceFilePathForThemeFilename:(NSString *)themeFilename inSourceDirectoryURL:(NSURL *)sourceDirectoryURL {
    NSParameterAssert(themeFilename != nil);
    NSParameterAssert(sourceDirectoryURL != nil);
    
    NSError *error;
    NSArray<NSString *> *subpaths = [NSFileManager.defaultManager subpathsOfDirectoryAtPath:sourceDirectoryURL.path error:&error];
    
    NSAssert(
        subpaths != nil,
        @"Error traversing directory at path %@: %@",
        sourceDirectoryURL,
        error);
    
    NSMutableArray<NSString *> *filenames = [NSMutableArray array];
    for (NSString *path in subpaths) {
        NSString *filename = path.lastPathComponent;
        NSAssert(
            filename != nil,
            @"Unable to parse last path component from path: %@",
            path);
        
        [filenames addObject:filename];
    }
    
    NSIndexSet *matchingIndices = [filenames
        indexesOfObjectsPassingTest:^BOOL(NSString *filename, NSUInteger idx, BOOL *stop) {
            return [filename isEqualToString:themeFilename];
        }];
    
    NSAssert(
        matchingIndices.count < 2,
        @"Multiple files with the filename %@ found, unable to resolve which "
            "one to observe for live reloading.",
        themeFilename);
    
    NSAssert(
        matchingIndices.count != 0,
        @"No theme file with the filename %@ found. Are your theme files a "
            "subdirectory of %@?",
        themeFilename,
        sourceDirectoryURL);
    
    return [subpaths objectAtIndex:matchingIndices.firstIndex];
}

- (NSArray<MTFFileObservationContext *> *)observeUpdatesToPaths:(NSArray<NSString *> *)paths onQueue:(dispatch_queue_t)queue didUpdate:(void(^)(NSString *))didUpdate {
    NSParameterAssert(paths != nil);
    NSParameterAssert(queue != nil);
    NSParameterAssert(didUpdate != nil);
    
    NSMutableArray<MTFFileObservationContext *> *fileObservationContexts = [NSMutableArray array];
    
    for (NSString *path in paths) {
        MTFFileObservationContext *fileObservationContext = [self
            observeUpdatesToPath:path
            onQueue:queue
            didUpdate:didUpdate];
        
        [fileObservationContexts addObject:fileObservationContext];
    }
    
    return [fileObservationContexts copy];
}

- (MTFFileObservationContext *)observeUpdatesToPath:(NSString *)path onQueue:(dispatch_queue_t)queue didUpdate:(void(^)(NSString *))didUpdate {
    NSParameterAssert(path != nil);
    NSParameterAssert(queue != nil);
    NSParameterAssert(didUpdate != nil);
    
    const char *fileSystemRepresentation = path.fileSystemRepresentation;
    int fileDescriptor = open(fileSystemRepresentation, O_EVTONLY, 0);

    NSAssert(fileDescriptor != -1,
        @"Unable to subscribe to changes to the file %@, errno %@. See errno.h "
             "for a description of the error.",
        path,
        @(errno));

    __block dispatch_source_t source = dispatch_source_create(
        DISPATCH_SOURCE_TYPE_VNODE,
        fileDescriptor,
        DISPATCH_VNODE_DELETE | DISPATCH_VNODE_WRITE | DISPATCH_VNODE_EXTEND,
        queue);
    
    NSAssert(
        source != NULL,
        @"Unable to create a dispatch source for the file: %@",
        path);
    
    __weak typeof(self) __weak_self = self;
    __weak typeof(source) __weak_source = source;
    
    dispatch_source_set_event_handler(source, ^{
        typeof(__weak_source) source = __weak_source;
        
        unsigned long data = dispatch_source_get_data(source);
        if (data != 0) {
            dispatch_source_cancel(source);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                typeof(__weak_self) self = __weak_self;
                
                // The dispatch source and file handle must be recreated for
                // events to continue to fire, thus this method must be called
                // recursively.
                MTFFileObservationContext *context = [self
                    observeUpdatesToPath:path
                    onQueue:self.fileObservationQueue
                    didUpdate:didUpdate];
                
                // The new context is added to the contexts array to ensure
                // that its source is not auto-released by ARC.
                [self updateObservationContext:context];
                
                didUpdate(path);
            });
        }
    });
    
    dispatch_source_set_cancel_handler(source, ^(void){
        close(fileDescriptor);
    });
    
    dispatch_resume(source);
    
    return [[MTFFileObservationContext alloc]
        initWithDispatchSource:source
        fileDescriptor:fileDescriptor
        path:path];
}

- (nullable MTFTheme *)themeFromSourceFilePaths:(NSArray<NSString *> *)sourceFilePaths error:(NSError **)error {
    NSParameterAssert(sourceFilePaths != nil);
    
    // Transform the paths into URLs
    NSMutableArray<NSURL *> *sourceFileURLs = [NSMutableArray array];
    for (NSString *sourceFilePath in sourceFilePaths) {
        NSURL *sourceFileURL = [NSURL fileURLWithPath:sourceFilePath];
        [sourceFileURLs addObject:sourceFileURL];
    }
    
    return [[MTFTheme alloc]
        initWithFiles:sourceFileURLs
        error:error];
}

- (NSArray<MTFFileObservationContext *> *)observeSourceFilesOfTheme:(MTFTheme *)theme onQueue:(dispatch_queue_t)queue didUpdate:(MTFThemeDidUpdate)didUpdate {
    NSParameterAssert(theme != nil);
    NSParameterAssert(queue != nil);
    NSParameterAssert(didUpdate != nil);

    NSArray<NSString *> *sourceFilePaths = [self
        sourceFilePathsForTheme:theme
        inSourceDirectoryURL:self.sourceDirectoryURL];

    __weak typeof(self) __weak_self = self;

    return [self
        observeUpdatesToPaths:sourceFilePaths
        onQueue:queue
        didUpdate:^(NSString *path) {
            typeof(__weak_self) self = __weak_self;

            NSError *error;
            MTFTheme *theme = [self
                themeFromSourceFilePaths:sourceFilePaths
                error:&error];

            self.updatedTheme = theme;
            self.updatedThemeError = error;
            
            didUpdate(theme, error);
        }];
}

- (void)updateObservationContext:(MTFFileObservationContext *)contextToUpdate {
    NSParameterAssert(contextToUpdate != nil);
    
    NSMutableArray<MTFFileObservationContext *> *fileObservationContexts = [self.fileObservationContexts mutableCopy];
    
    NSInteger indexToReplace = [fileObservationContexts
        indexOfObjectPassingTest:^BOOL(MTFFileObservationContext *context, NSUInteger index, BOOL *stop) {
            return [context.path isEqualToString:contextToUpdate.path];
        }];
    
    NSAssert(
        indexToReplace != NSNotFound,
        @"Unable to locate context to replace");

    [fileObservationContexts
        replaceObjectAtIndex:indexToReplace
        withObject:contextToUpdate];
    
    self.fileObservationContexts = [fileObservationContexts copy];
}

@end

NS_ASSUME_NONNULL_END
