//
//  MTFTestApplicants.m
//  Motif
//
//  Created by Eric Horacek on 1/7/16.
//  Copyright © 2016 Eric Horacek. All rights reserved.
//

#import "MTFTestApplicants.h"

@implementation MTFTestCTypePropertiesApplicant

@end

@implementation MTFTestObjCClassPropertiesApplicant

@end

@implementation MTFTestSuperclassPropertyApplicant

@end

@implementation MTFTestSubclassPropertyApplicant

@end

@implementation MTFTestThemeClassPropertyApplicant

@end

@implementation MTFTestThemeClassNestedPropertyApplicant

@end

@implementation MTFTestEnumerationPropertiesApplicant

@end

@implementation MTFTestSetterCountingApplicant

- (void)setStringValue:(NSString *)stringValue {
    _applications++;
    _stringValue = stringValue;
}

@end