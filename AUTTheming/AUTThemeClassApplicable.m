//
//  AUTDynamicThemeApplier.m
//  Pods
//
//  Created by Eric Horacek on 12/26/14.
//
//

#import <objc/runtime.h>
#import "AUTThemeClassApplicable.h"
#import "AUTThemeConstant.h"
#import "AUTThemeClass_Private.h"

@interface AUTThemeClassApplier ()

@property (nonatomic, copy) AUTThemeClassApplierBlock applierBlock;

@end

@implementation AUTThemeClassApplier

#pragma mark - NSObject

- (instancetype)init
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    // Ensure that exception is thrown when just `init` is called.
    self = [self initWithClassApplierBlock:nil];
#pragma clang diagnostic pop
    return self;
}

#pragma mark - AUTThemeClassApplier

- (instancetype)initWithClassApplierBlock:(AUTThemeClassApplierBlock)applierBlock
{
    NSParameterAssert(applierBlock);
    self = [super init];
    if (self) {
        self.applierBlock = applierBlock;
    }
    return self;
}

#pragma mark - AUTThemeClassApplier <AUTDynamicThemeApplier>

@dynamic properties;

- (NSArray *)properties
{
    return @[];
}

- (void)applyClass:(AUTThemeClass *)class toObject:(id)object;
{
    NSParameterAssert(class);
    NSParameterAssert(object);
    
    self.applierBlock(class, object);
}

- (BOOL)shouldApplyClass:(AUTThemeClass *)class
{
    return YES;
}

@end

@interface AUTThemeClassPropertyApplier ()

@property (nonatomic, copy) NSString *property;
@property (nonatomic, copy) NSString *valueTransformerName;
@property (nonatomic) Class requiredClass;
@property (nonatomic, copy) AUTThemePropertyApplierBlock applierBlock;

@end

@implementation AUTThemeClassPropertyApplier

#pragma mark - NSObject

- (instancetype)init
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    // Ensure that exception is thrown when just `init` is called.
    self = [self initWithProperty:nil valueTransformerName:nil requiredClass:Nil applierBlock:nil];
#pragma clang diagnostic pop
    return self;
}

#pragma mark - AUTThemePropertyApplier

- (instancetype)initWithProperty:(NSString *)property valueTransformerName:(NSString *)name requiredClass:(Class)class applierBlock:(AUTThemePropertyApplierBlock)applierBlock
{
    NSParameterAssert(property);
    NSParameterAssert(applierBlock);
    
    self = [super init];
    if (self) {
        self.property = property;
        self.applierBlock = applierBlock;
        self.valueTransformerName = name;
        self.requiredClass = class;
    }
    return self;
}

+ (id)valueFromConstant:(AUTThemeConstant *)constant forProperty:(NSString *)property onObject:(id)object withRequiredClass:(Class)requiredClass valueTransformerName:(NSString *)valueTransformerName
{
    NSAssert(constant, @"Constant must not be nil");
    id value = constant.value;
    
    // Enforce required class if necessary
    if (requiredClass) {
        BOOL isValueOfRequiredClass = [value isKindOfClass:requiredClass];
        if (!isValueOfRequiredClass) {
            __unused NSString *applierClassName = NSStringFromClass([object class]);
            __unused NSString *requiredClassName = NSStringFromClass(requiredClass);
            __unused NSString *valueClassName = NSStringFromClass([value class]);
            NSAssert(isValueOfRequiredClass, @"The theme applier on '%@' requires that the value for property '%@' is of class '%@'. It is instead an instace of '%@'", applierClassName, requiredClassName, property, valueClassName);
        }
    }
    
    // Transform value if necessary
    if (valueTransformerName) {
        __unused NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:valueTransformerName];
        NSAssert(valueTransformer, @"There is no value transfomer registered for the name '%@'. Before applying a theme, you must first register a value transformer instance using `+[NSValueTransformer setValueTransformer:forName:]` for the specified name.", valueTransformerName);
        id transformedValue = [constant transformedValueFromTransformerWithName:valueTransformerName];
        value = transformedValue;
    }
    
    return value;
}

#pragma mark - AUTThemePropertyApplier <AUTDynamicThemeApplier>

@dynamic properties;

- (NSArray *)properties
{
    return @[self.property];
}

- (void)applyClass:(AUTThemeClass *)class toObject:(id)object;
{
    NSParameterAssert(class);
    NSParameterAssert(object);
    
    AUTThemeConstant *constant = class.resolvedPropertiesConstants[self.property];
    
    id value = [[self class] valueFromConstant:constant forProperty:self.property onObject:object withRequiredClass:self.requiredClass valueTransformerName:self.valueTransformerName];
    
    self.applierBlock(value, object);
}

- (BOOL)shouldApplyClass:(AUTThemeClass *)class
{
    return [class.properties.allKeys containsObject:self.property];
}

@end

@interface AUTThemeClassPropertiesApplier ()

@property (nonatomic, copy) AUTThemePropertiesApplierBlock applierBlock;
@property (nonatomic) NSArray *properties;
@property (nonatomic) NSArray *valueTransformersOrRequiredClasses;

@end

@implementation AUTThemeClassPropertiesApplier

#pragma mark - NSObject

- (instancetype)init
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    // Ensure that exception is thrown when just `init` is called.
    self = [self initWithProperties:nil valueTransformersOrRequiredClasses:nil applierBlock:nil];
#pragma clang diagnostic pop
    return self;
}

#pragma mark - AUTThemePropertiesApplier

- (instancetype)initWithProperties:(NSArray *)properties valueTransformersOrRequiredClasses:(NSArray *)valueTransformersOrRequiredClasses applierBlock:(AUTThemePropertiesApplierBlock)applierBlock
{
    NSParameterAssert(properties);
    NSParameterAssert(applierBlock);
    
    self = [super init];
    if (self) {
        self.properties = properties;
        self.applierBlock = applierBlock;
        if (valueTransformersOrRequiredClasses) {
            NSAssert(properties.count == valueTransformersOrRequiredClasses.count, @"The `properties` array and the `valueTransformersOrRequiredClasses` array must have the same number of elements.");
            self.valueTransformersOrRequiredClasses = valueTransformersOrRequiredClasses;
        }
    }
    return self;
}

- (Class)requiredClassForPropertyAtIndex:(NSUInteger)index
{
    Class class = self.valueTransformersOrRequiredClasses[index];
    // Check for whether the passed object is of type `Class`
    if (class_isMetaClass(object_getClass(class))) {
        return class;
    }
    return nil;
}

- (NSString *)valueTransformerNameForPropertyAtIndex:(NSUInteger)index
{
    NSString *name = self.valueTransformersOrRequiredClasses[index];
    if ([name isKindOfClass:[NSString class]]) {
        return name;
    }
    return nil;
}

#pragma mark - AUTThemePropertiesApplier <AUTDynamicThemeApplier>

- (void)applyClass:(AUTThemeClass *)class toObject:(id)object
{
    NSParameterAssert(class);
    NSParameterAssert(object);
    
    NSMutableDictionary *valuesForProperties = [NSMutableDictionary new];
    
    [self.properties enumerateObjectsUsingBlock:^(NSString *property, NSUInteger propertyIndex, BOOL *stop) {
        
        AUTThemeConstant *constant = class.resolvedPropertiesConstants[property];
        
        Class requiredClass = [self requiredClassForPropertyAtIndex:propertyIndex];
        NSString *valueTransformerName = [self valueTransformerNameForPropertyAtIndex:propertyIndex];
        id value = [AUTThemeClassPropertyApplier valueFromConstant:constant forProperty:property onObject:object withRequiredClass:requiredClass valueTransformerName:valueTransformerName];
        
        valuesForProperties[property] = value;
    }];
    
    self.applierBlock([valuesForProperties copy], object);
}

- (BOOL)shouldApplyClass:(AUTThemeClass *)class
{
    NSSet *classProperties = [NSSet setWithArray:class.properties.allKeys];
    NSSet *applierProperties = [NSSet setWithArray:self.properties];
    return [classProperties intersectsSet:applierProperties];
}

@end
