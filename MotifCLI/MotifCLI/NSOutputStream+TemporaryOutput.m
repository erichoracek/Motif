//
//  NSOutputStream+TemporaryOutput.m
//  MotifCLI
//
//  Created by Eric Horacek on 8/17/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import ObjectiveC;
#import <GBCli/GBCli.h>

#import "NSOutputStream+TemporaryOutput.h"

NS_ASSUME_NONNULL_BEGIN

NSString * const MTFTemporaryOutputStreamErrorDomain = @"MTFTemporaryOutputStreamErrorDomain";

@implementation NSOutputStream (TemporaryOutput)

+ (nullable instancetype)temporaryOutputStreamWithDestinationURL:(NSURL *)destinationURL error:(NSError **)error {
    NSParameterAssert(destinationURL != nil);

    NSString *templateName = [destinationURL.lastPathComponent stringByAppendingString:@"XXX"];

    NSURL *temporaryURL = [self createTemporaryFileWithTemplateName:templateName error:error];
    if (temporaryURL == nil) return nil;

    NSOutputStream *stream = [self outputStreamWithURL:temporaryURL append:NO];
    if (stream == nil) {
        if (error != NULL) {
            NSString *description = [NSString stringWithFormat:NSLocalizedString(@"Failed to create temporary output stream to URL: %@", nil), temporaryURL];

            *error = [NSError
                errorWithDomain:MTFTemporaryOutputStreamErrorDomain
                code:MTFTemporaryOutputStreamErrorCreationFailure
                userInfo:@{
                    NSLocalizedDescriptionKey: description,
                }];
        }

        return nil;
    }

    stream.temporaryURL = temporaryURL;
    stream.destinationURL = destinationURL;

    return stream;
}

+ (NSURL *)createTemporaryFileWithTemplateName:(NSString *)templateName error:(NSError **)error {
    NSParameterAssert(templateName != nil);

    NSString *templatePath = [NSTemporaryDirectory() stringByAppendingPathComponent:templateName];

    char *template = strdup(templatePath.UTF8String);
    int fd = mkstemp(template);

    if (fd == -1) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:errno userInfo:nil];
        }

        return nil;
    }

    NSString *path = [[NSString alloc]
        initWithBytesNoCopy:template
        length:templatePath.length
        encoding:NSUTF8StringEncoding
        freeWhenDone:YES];

    return [NSURL fileURLWithPath:path isDirectory:NO];
}

- (BOOL)copyToDestinationIfNecessaryWithError:(NSError **)error {
    NSAssert(self.streamStatus == NSStreamStatusClosed, @"Stream must be closed");

    BOOL equalContents = [NSFileManager.defaultManager
        contentsEqualAtPath:self.temporaryURL.path
        andPath:self.destinationURL.path];

    // If contents are equal, just delete the temporary file.
    if (equalContents) {
        NSError *removeError;
        BOOL success = [NSFileManager.defaultManager removeItemAtURL:self.temporaryURL error:&removeError];

        // If failed to delete a file that doesn't exist, this is fine.
        if (!success && [removeError.domain isEqual:NSCocoaErrorDomain] && removeError.code == NSFileNoSuchFileError) {
            return YES;
        }

        if (!success && error != NULL) {
            *error = removeError;
        }

        return success;
    }

    // Otherwise, remove the destination file and move the temporary file to
    // replace it.
    NSError *removeError;
    BOOL removeSuccess = [NSFileManager.defaultManager removeItemAtURL:self.destinationURL error:&removeError];

    BOOL failedToRemoveNonExistentFile = !removeSuccess && ([removeError.domain isEqual:NSCocoaErrorDomain] && removeError.code == NSFileNoSuchFileError);

    // If failed in any way other than failure to delete a file that doesn't
    // exist, consider this a failure.
    if (!removeSuccess && !failedToRemoveNonExistentFile) {
        if (error != NULL) {
            *error = removeError;
        }
        return NO;
    }

    return [NSFileManager.defaultManager
        moveItemAtURL:self.temporaryURL
        toURL:self.destinationURL
        error:error];
}

- (NSURL *)temporaryURL {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTemporaryURL:(NSURL *)temporaryURL {
    objc_setAssociatedObject(self, @selector(temporaryURL), temporaryURL, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSURL *)destinationURL {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDestinationURL:(NSURL *)destinationURL {
    objc_setAssociatedObject(self, @selector(destinationURL), destinationURL, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

NS_ASSUME_NONNULL_END
