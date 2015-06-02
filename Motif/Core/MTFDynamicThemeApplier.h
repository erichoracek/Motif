//
//  MTFDynamicThemeApplier.h
//  Motif
//
//  Created by Eric Horacek on 12/29/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MTFTheme;

/**
 A dynamic theme applier enables dynamic theming, allowing the objects that are
 themed to have a new theme reapplied to them by simply changing the theme
 property on the dynamic theme applier that initially applied their theme class.
 
 When using a MTFDynamicThemeApplier, you should not use the 
 applyClassWithName:toObject: method on MTFTheme to apply theme classes to
 objects. Instead, use the method on MTFDynamicThemeApplier.
 
 If the `theme` property is changed on an `MTFDynamicThemeApplier`, it reapplies
 the theme classes that were previously applied by it with classes from the new
 theme. If some classes are unavailable in the new theme, they are ignored, and
 no style is applied to the object.
 */
@interface MTFDynamicThemeApplier : NSObject

/**
 Initializes a dynamic theme applier with a theme.
 
 @param theme The theme that the dynamic theme applier instance should be
              responsible for applying. Must not be nil.
 
 @return An initialized theme applier.
 */
- (instancetype)initWithTheme:(MTFTheme *)theme NS_DESIGNATED_INITIALIZER;

/**
 The theme that the dynamic theme applier should be responsible for applying.
 
 When the theme is changed, the objects that had the previous theme applied to
 theme have the same theme classes reapplied to them from the new theme.
 The value of this property may not be nil.
 */
@property (nonatomic) MTFTheme *theme;

/**
 Applies a theme class with the specified name to an object.
 
 @param className If className is nil or does not map to an existing class on
                  theme, this method has no effect.
 @param object    If the object is nil or has no registered class appliers, 
                  this method has no effect.
 
 @return Whether the class was applied to the object.
 */
- (BOOL)applyClassWithName:(NSString *)className toObject:(id)object;

@end

NS_ASSUME_NONNULL_END
