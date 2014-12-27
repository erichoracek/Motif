//
//  NSURL+LastPathComponentWithoutExtension.h
//  AUTTheming
//
//  Created by Eric Horacek on 12/23/14.
//
//

#import <Foundation/Foundation.h>

@interface NSURL (LastPathComponentWithoutExtension)

@property (nonatomic, readonly) NSString *aut_lastPathComponentWithoutExtension;

@end
