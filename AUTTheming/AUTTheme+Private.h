//
//  AUTTheme+Private.h
//  AUTTheming
//
//  Created by Eric Horacek on 12/23/14.
//
//

extern NSString * const AUTThemeConstantsKey;
extern NSString * const AUTThemeClassesKey;
extern NSString * const AUTThemeSuperclassKey;

@interface AUTTheme ()

- (void)addConstantsAndClassesFromRawAttributesDictionary:(NSDictionary *)dictionary forThemeWithName:(NSString *)name error:(NSError **)error;

@property (nonatomic) NSArray *names;
@property (nonatomic) NSDictionary *mappedConstants;
@property (nonatomic) NSDictionary *mappedClasses;

@end
