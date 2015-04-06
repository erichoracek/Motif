//
//  UIScrollView+Theming.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 4/5/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Motif/Motif.h>
#import "UIScrollView+Theming.h"
#import "ThemeSymbols.h"

@implementation UIScrollView (Theming)

+ (void)load {
    [self
        mtf_registerThemeProperty:ContentThemeProperties.scrollIndicatorStyle
        requiringValueOfClass:NSString.class
        applierBlock:^(NSString *scrollIndicatorStyle, UIScrollView *scrollView) {
            [scrollView mtf_setScrollIndicatorStyle:scrollIndicatorStyle];
        }];
}

- (void)mtf_setScrollIndicatorStyle:(NSString *)scrollIndicatorStyle
{
    if ([scrollIndicatorStyle isEqualToString:@"light"]) {
        self.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    } else {
        self.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    }
}

@end
