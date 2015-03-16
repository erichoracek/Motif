//
//  AUTThemeHierarchy.h
//  Pods
//
//  Created by Eric Horacek on 2/8/15.
//
//

#import <Foundation/Foundation.h>
#import "AUTBackwardsCompatableNullability.h"

AUT_NS_ASSUME_NONNULL_BEGIN

@protocol AUTThemeHierarchy <NSObject>

@property (nonatomic, readonly) id<AUTThemeHierarchy> aut_themeParent;

@property (nonatomic, readonly) NSArray *aut_themeChildren;

@end

AUT_NS_ASSUME_NONNULL_END
