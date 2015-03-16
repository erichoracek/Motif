//
//  AUTDynamicThemeApplier_Private.h
//  Pods
//
//  Created by Eric Horacek on 12/29/14.
//
//

#import "AUTDynamicThemeApplier.h"

AUT_NS_ASSUME_NONNULL_BEGIN

@interface AUTDynamicThemeApplier ()

/**
 The applicants of the theme classes, keyed by the the theme class names that they had applied to them.
 
 The values of this dictionary are instances of NSHashTable, containing weak references to all of the objects that have had a class applied to it. When the theme property is changed, this enables an applier instance to apply the new theme to all of its previous applicants.
 */
@property (nonatomic, aut_null_resettable) NSMutableDictionary *applicants;

@end

AUT_NS_ASSUME_NONNULL_END
