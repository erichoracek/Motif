//
//  AUTThemeConstant.h
//  AUTTheming
//
//  Created by Eric Horacek on 12/24/14.
//
//

#import <Foundation/Foundation.h>

@interface AUTThemeConstant : NSObject

- (instancetype)initWithKey:(NSString *)key rawValue:(id)rawValue mappedValue:(id)mappedValue;

@property (nonatomic, copy, readonly) NSString *key;

@property (nonatomic, readonly) id rawValue;

/**
 Defaults as a pass-through accessor to `rawValue`, but is able to be set to a different value via `setMappedValue:`.
 */
@property (nonatomic, readonly) id mappedValue;

- (id)transformedValueFromTransformerWithName:(NSString *)name;

@end
