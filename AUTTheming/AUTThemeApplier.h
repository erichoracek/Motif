//
//  AUTThemeApplier.h
//  Pods
//
//  Created by Eric Horacek on 12/29/14.
//
//

#import <Foundation/Foundation.h>

@class AUTTheme;

@interface AUTThemeApplier : NSObject

/**
 Initializes a theme applier with a theme.
 
 @param theme The theme that the applier instance should be responsible for applying.
 
 @return An initialized theme applier.
 */
- (instancetype)initWithTheme:(AUTTheme *)theme;

/**
 The theme that the applier should be responsible for applying.
 */
@property (nonatomic) AUTTheme *theme;

/**
 Applies a theme class with the specified name to an object.
 
 @param className If className is nil or does not map to an existing class on theme, this method has no effect.
 @param object    If the object is nil or has no registered class appliers, this method has no effect.
 */
- (void)applyClassWithName:(NSString *)className toObject:(id)object;

@end
