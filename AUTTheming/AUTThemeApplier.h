//
//  AUTThemeApplier.h
//  Pods
//
//  Created by Eric Horacek on 12/29/14.
//
//

#import <Foundation/Foundation.h>

@class AUTTheme;

/**
 A theme applier is responsible for applying an AUTTheme to objects.
 
 If the `theme` property is changed on an `AUTThemeApplier`, it reapplies the theme classes that were previously applied by it with classes from the new theme.
 */
@interface AUTThemeApplier : NSObject

/**
 Initializes a theme applier with a theme.
 
 @param theme The theme that the applier instance should be responsible for applying. Must not be nil.
 
 @return An initialized theme applier.
 */
- (instancetype)initWithTheme:(AUTTheme *)theme NS_DESIGNATED_INITIALIZER __attribute__ ((nonnull));

/**
 The theme that the applier should be responsible for applying.
 
 When the theme is changed, the objects that had the previous theme applied to theme have the same theme classes reapplied to them from the new theme. The value of this property may not be nil.
 */
@property (nonatomic) AUTTheme *theme;

/**
 Applies a theme class with the specified name to an object.
 
 @param className If className is nil or does not map to an existing class on theme, this method has no effect.
 @param object    If the object is nil or has no registered class appliers, this method has no effect.
 
 @return Whether the class was applied to the object.
 */
- (BOOL)applyClassWithName:(NSString *)className toObject:(id)object;

@end
