//
//  MTFThemeClassPropertiesApplier.h
//  Motif
//
//  Created by Eric Horacek on 6/7/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Motif/MTFThemeClassApplicable.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTFThemeClassPropertiesApplier : NSObject <MTFThemeClassApplicable>

/**
 Initializes a theme class properties applier.
 
 @param properties   The names of the properties that this applier is 
                     responsible for applying.

 @param applierBlock The block that is invoked when all of the specified
                     properties are contained within a theme class that is being
                     applied to the object that this applier is registered with.
 
 @return An initialized theme class properties applier.
 */
- (instancetype)initWithProperties:(NSArray *)properties applierBlock:(MTFThemePropertiesApplierBlock)applierBlock NS_DESIGNATED_INITIALIZER;

/**
 The block that is invoked to apply the property values to an instance of the
 class that this applier is registered with.
 */
@property (nonatomic, copy, readonly) MTFThemePropertiesApplierBlock applierBlock;

@end

@interface MTFThemeClassTypedValuesPropertiesApplier : MTFThemeClassPropertiesApplier

- (instancetype)initWithProperties:(NSArray *)properties valueClassesOrObjCTypes:(NSArray *)valueClassesOrObjCTypes applierBlock:(MTFThemePropertiesApplierBlock)applierBlock NS_DESIGNATED_INITIALIZER;

@property (readonly, nonatomic, copy) NSArray *valueClassesOrObjCTypes;

@end

NS_ASSUME_NONNULL_END
