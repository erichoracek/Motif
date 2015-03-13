//
//  AUTDynamicThemeApplier.h
//  Pods
//
//  Created by Eric Horacek on 12/29/14.
//
//

#import <Foundation/Foundation.h>

@class AUTTheme;

/**
 A dynamic theme applier enables dynamic theming, allowing the objects that are
 themed to have a new theme reapplied to them by simply changing the theme
 property on the dynamic theme applier that initially applied their theme class.
 
 If the `theme` property is changed on an `AUTDynamicThemeApplier`, it reapplies
 the theme classes that were previously applied by it with classes from the new
 theme. If some classes are unavailable in the new theme, they are ignored, and
 no style is applied to the object.
 */
@interface AUTDynamicThemeApplier : NSObject

/**
 Initializes a dynamic theme applier with a theme.
 
 @param theme The theme that the dynamic theme applier instance should be
              responsible for applying. Must not be nil.
 
 @return An initialized theme applier.
 */
- (instancetype)initWithTheme:(AUTTheme *)theme NS_DESIGNATED_INITIALIZER __attribute__ ((nonnull));

/**
 The theme that the dynamic theme applier should be responsible for applying.
 
 When the theme is changed, the objects that had the previous theme applied to
 theme have the same theme classes reapplied to them from the new theme.
 The value of this property may not be nil.
 */
@property (nonatomic) AUTTheme *theme;

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
