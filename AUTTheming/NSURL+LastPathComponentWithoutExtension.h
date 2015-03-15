//
//  NSURL+LastPathComponentWithoutExtension.h
//  AUTTheming
//
//  Created by Eric Horacek on 12/23/14.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (LastPathComponentWithoutExtension)

@property (nonatomic, readonly, nullable) NSString *aut_lastPathComponentWithoutExtension;

@end

NS_ASSUME_NONNULL_END
