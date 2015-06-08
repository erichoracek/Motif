//
//  MTFThemeClassPropertyApplier.h
//  Motif
//
//  Created by Eric Horacek on 6/7/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Motif/MTFThemeClassApplicable.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTFThemeClassPropertyApplier : NSObject <MTFThemeClassApplicable>

- (instancetype)initWithProperty:(NSString *)property applierBlock:(MTFThemePropertyApplierBlock)applierBlock NS_DESIGNATED_INITIALIZER;

/// The name of the property that this theme property applier is responsible for
/// applying.
@property (nonatomic, copy, readonly) NSString *property;

/// The block that is invoked to apply the property value to an instance of the
/// class that this applier is registered with.
@property (nonatomic, copy, readonly) MTFThemePropertyApplierBlock applierBlock;

@end

@interface MTFThemeClassValueClassPropertyApplier : MTFThemeClassPropertyApplier

- (instancetype)initWithProperty:(NSString *)property valueClass:(Class)valueClass applierBlock:(MTFThemePropertyApplierBlock)applierBlock NS_DESIGNATED_INITIALIZER;

@property (readonly, nonatomic) Class valueClass;

+ (nullable id)valueForApplyingProperty:(NSString *)property withValueClass:(Class)valueClass fromThemeClass:(MTFThemeClass *)themeClass;

@end

@interface MTFThemeClassValueObjCTypePropertyApplier : MTFThemeClassPropertyApplier

- (instancetype)initWithProperty:(NSString *)property valueObjCType:(const char *)valueObjCType applierBlock:(MTFThemePropertyApplierBlock)applierBlock NS_DESIGNATED_INITIALIZER;

/// The Objective-C type of the value that this applier is expecting.
@property (readonly, nonatomic) const char * valueObjCType;

+ (nullable id)valueForApplyingProperty:(NSString *)property withValueObjCType:(const char *)valueObjCType fromThemeClass:(MTFThemeClass *)themeClass;

@end

NS_ASSUME_NONNULL_END
