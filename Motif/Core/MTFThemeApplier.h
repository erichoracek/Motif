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
 
 @param className If className is nil or does not map to an existing class on
                  theme, this method has no effect.
 @param object    If the object is nil or has no registered class appliers, 
                  this method has no effect.
 
 @return Whether the class was applied to the object.
 */
- (BOOL)applyClassWithName:(NSString *)name to:(id)applicant error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
