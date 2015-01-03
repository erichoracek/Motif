//
//  AUTThemeApplier+Private.h
//  Pods
//
//  Created by Eric Horacek on 12/29/14.
//
//

#import "AUTThemeApplier.h"

@class AUTThemeClass;

@interface AUTThemeApplier ()

/**
 The applicants of the theme classes, keyed by the the theme class names that they had applied to them.
 
 The values of this dictionary are instances of NSHashTable, containing weak references to all of the objects that have had a class applied to it. When the theme is changed, an applier can apply the new theme to all of its objects.
 */
@property (nonatomic) NSMutableDictionary *applicants;

/**
 Applies a theme class to an object.
 
 @param class  The theme class that should be applied to the specified object.
 @param object The object that should have the be theme class applied to it.
 */
- (void)applyClass:(AUTThemeClass *)class toApplicant:(id)applicant;

@end
