//
//  UIScrollView+Theming.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 4/5/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import <AUTTheming/AUTTheming.h>
#import "UIScrollView+Theming.h"
#import "ThemeSymbols.h"

@implementation UIScrollView (Theming)

+ (void)load {
    [self
        aut_registerThemeProperty:ContentThemeProperties.scrollIndicatorStyle
        requiringValueOfClass:NSString.class
        applierBlock:^(NSString *scrollIndicatorStyle, UIScrollView *scrollView) {
            [scrollView aut_setScrollIndicatorStyle:scrollIndicatorStyle];
        }];
}

- (void)aut_setScrollIndicatorStyle:(NSString *)scrollIndicatorStyle
{
    if ([scrollIndicatorStyle isEqualToString:@"light"]) {
        self.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    } else {
        self.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    }
}

@end
