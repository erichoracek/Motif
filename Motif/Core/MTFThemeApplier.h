//
//  MTFThemeApplier.h
//  Motif
//
//  Created by Eric Horacek on 10/11/15.
//  Copyright © 2015 Eric Horacek. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@protocol MTFThemeApplier <NSObject>

/**
 Applies a theme class with the specified name to an object.

 @return Whether the class was applied to the object.
 */
- (BOOL)applyClassWithName:(NSString *)name to:(id)applicant error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
