//
//  NSOutputStream+TemporaryOutput.m
//  MotifCLI
//
//  Created by Eric Horacek on 8/17/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <GBCli/GBCli.h>
#import <objc/runtime.h>

#import "NSOutputStream+TemporaryOutput.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSOutputStream (TemporaryOutput)

+ (instancetype)temporaryOutputStreamWithDestinationURL:(NSURL *)destinationURL {
    NSParameterAssert(destinationURL != nil);

    NSString *templateName = [destinationURL.lastPathComponent stringByAppendingString:@"XXX"];

    NSURL *temporaryURL = [self createTemporaryFileWithTemplateName:templateName error:NULL];
    if (temporaryURL == nil) return nil;

    NSOutputStream *stream = [self outputStreamWithURL:temporaryURL append:NO];

    stream.temporaryURL = [temporaryURL copy];
    stream.destinationURL = [destinationURL copy];

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

- (void)copyToDestinationIfNecessary {
    NSAssert(self.streamStatus == NSStreamStatusClosed, @"Stream must be closed");

    BOOL equalContents = [NSFileManager.defaultManager
        contentsEqualAtPath:self.temporaryURL.path
        andPath:self.destinationURL.path];

    if (equalContents) {
        [NSFileManager.defaultManager removeItemAtURL:self.temporaryURL error:NULL];

    } else {
        [NSFileManager.defaultManager removeItemAtURL:self.destinationURL error:NULL];

        NSError *error;
        BOOL success = [NSFileManager.defaultManager
            moveItemAtURL:self.temporaryURL
            toURL:self.destinationURL
            error:&error];

        if (!success) {
            gbfprintln(stderr, @"[!] Error: unable to create file at path %@: %@", self.destinationURL, error);
        }
    }
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
