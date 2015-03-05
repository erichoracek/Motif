//
//  AUTThemeParser.h
//  Pods
//
//  Created by Eric Horacek on 2/11/15.
//
//

#import <Foundation/Foundation.h>

@class AUTTheme;

@interface AUTThemeParser : NSObject

- (instancetype)initWithRawTheme:(NSDictionary *)rawTheme inheritingFromTheme:(AUTTheme *)theme error:(NSError **)error;

@property (nonatomic, readonly) NSDictionary *rawTheme;
@property (nonatomic, readonly) NSDictionary *parsedConstants;
@property (nonatomic, readonly) NSDictionary *parsedClasses;

@end
