//
//  MTFThemeHierarchy.h
//  Motif
//
//  Created by Eric Horacek on 2/8/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTFBackwardsCompatableNullability.h"

MTF_NS_ASSUME_NONNULL_BEGIN

@protocol MTFThemeHierarchy <NSObject>

@property (nonatomic, readonly) id<MTFThemeHierarchy> mtf_themeParent;

@property (nonatomic, readonly) NSArray *mtf_themeChildren;

@end

MTF_NS_ASSUME_NONNULL_END
