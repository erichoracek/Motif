//
//  MTFDynamicThemeApplier_Private.h
//  Motif
//
//  Created by Eric Horacek on 12/29/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Motif/MTFDynamicThemeApplier.h>

MTF_NS_ASSUME_NONNULL_BEGIN

@interface MTFDynamicThemeApplier ()

/**
 The applicants of the theme classes that were applied with this dynamic theme
 applier.
 
 An NSHashTable, containing weak references to all of the objects that have had
 a class applied to it. When the theme property is changed, this enables an
 applier instance to apply the new theme to all of its previous applicants.
 */
@property (nonatomic, mtf_null_resettable) NSHashTable *applicants;

@end

MTF_NS_ASSUME_NONNULL_END
