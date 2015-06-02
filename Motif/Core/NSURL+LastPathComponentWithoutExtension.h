//
//  NSURL+LastPathComponentWithoutExtension.h
//  Motif
//
//  Created by Eric Horacek on 12/23/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (LastPathComponentWithoutExtension)

/**
 The last path component of the URL without the extension. For example, when 
 invoked on a URL referencing a file named "Theme.json" this method will return
 "Theme".
 
 First reads the lastPathComponent of the URL, and then takes its pathExtension
 and trims it from the lastPathComponent.
 */
@property (nonatomic, readonly, nullable) NSString *mtf_lastPathComponentWithoutExtension;

@end

NS_ASSUME_NONNULL_END
