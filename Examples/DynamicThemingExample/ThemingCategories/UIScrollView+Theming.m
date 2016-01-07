//
//  UIScrollView+Theming.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 4/5/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

@import Motif;

#import "ThemeSymbols.h"

#import "UIScrollView+Theming.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UIScrollView (Theming)

+ (void)load {
    [self
        mtf_registerThemeProperty:ContentThemeProperties.scrollIndicatorStyle
        requiringValueOfClass:NSString.class
        applierBlock:^(NSString *scrollIndicatorStyle, UIScrollView *scrollView, NSError **error) {
            [scrollView mtf_setScrollIndicatorStyle:scrollIndicatorStyle];
            return YES;
        }];
}

- (void)mtf_setScrollIndicatorStyle:(NSString *)scrollIndicatorStyle {
    if ([scrollIndicatorStyle isEqualToString:@"light"]) {
        self.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    } else {
        self.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    }
}

@end

NS_ASSUME_NONNULL_END
