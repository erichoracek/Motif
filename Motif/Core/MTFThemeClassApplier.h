//
//  MTFThemeClassApplier.h
//  Motif
//
//  Created by Eric Horacek on 6/8/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Motif/MTFThemeClassApplicable.h>

/**
 An applier that is invoked when a theme class is applied to an object.
 */
@interface MTFThemeClassApplier : NSObject <MTFThemeClassApplicable>

/**
 Initializes an theme class applier.
 
 @param applierBlock A block that is invoked when a class is applied to the
                     object that this applier is registered with.
 
 @return An initialized theme class applier.
 */
- (instancetype)initWithClassApplierBlock:(MTFThemeClassApplierBlock)applierBlock NS_DESIGNATED_INITIALIZER;

/**
 The block that is invoked when a theme class is applied to an instance of the
 class that this applier is registered with.
 */
@property (nonatomic, copy, readonly) MTFThemeClassApplierBlock applierBlock;

@end
