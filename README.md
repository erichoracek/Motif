# Motif

[![Build Status](https://travis-ci.org/erichoracek/Motif.svg?branch=master)](https://travis-ci.org/erichoracek/Motif)

_A lightweight and customizable CSS-style framework for iOS._

## Why should I use it?

You have an app. Maybe even a family of apps. You know about CSS, which enables web developers to write a set of declarative rules that style elements throughout their site, creating reusable interface components that are entirely divorced from content or layout. You'll admit that you're a little jealous that things aren't quite the same on iOS.

Maybe you have a `MyAppStyle` singleton that vends styled objects, which is a dependency of nearly every view controller in your app. Maybe you use Apple's `UIAppearance` APIs, but you're limited to a subset of supported APIs, and declare them in a really long method in a `Style` singleton which defines a convoluted set of rules for your entire app. Maybe you've even started to subclass UIKit classes just to set a few defaults to create some styled components. You know this sucks, but there just isn't a better way to do things in iOS.

Well, things about about to change. Take a look at the example below to see what `Motif` can do for you:

## Example

Alternatively, you can clone this repo and follow along to a similar example in the `ButtonsExample` target within `Motif.xcworkspace`.

### The output:

<!-- <img src="README/buttons.png" alt="Horizontal Layout" height="91" width="339" /> -->
<img src="https://github.com/erichoracek/Motif/blob/master/README/Buttons.png?raw=true" alt="Horizontal Layout" height="91" width="339" />

### `Theme.json`:

```javascript
{
    "$WhiteColor": "#f1efeb",
    "$RedColor": "#f93d38",
    "$BlueColor": "#50b5ed",
    "$H5FontSize": 16,
    "$RegularFontName": "AvenirNext-Regular",
    ".Button": {
        "fontName": "$RegularFontName",
        "fontSize": "$H5FontSize",
        "contentEdgeInsets": "{10.0, 20.0, 10.0, 20.0}",
        "borderWidth": 1.0,
        "cornerRadius": 5.0
    },
    ".DestructiveButton": {
        "_superclass": ".Button",
        "textColor": "$RedColor",
        "borderColor": "$RedColor"
    },
    ".PrimaryButton": {
        "_superclass": ".Button",
        "textColor": "$BlueColor",
        "borderColor": "$BlueColor"
    },
    ".ContentBackground": {
        "backgroundColor": "$WhiteColor"
    },
}
```

### `ButtonsViewController.m`:

```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];

    NSError *error;
    MTFTheme *theme = [MTFTheme themeWithThemeNamed:@"Theme" error:&error];
    NSAssert(!error, @"Error loading theme %@", error);
    
    [theme applyClassWithName:@"PrimaryButton" toObject:self.saveButton];
    [theme applyClassWithName:@"DestructiveButton" toObject:self.deleteButton];
    [theme applyClassWithName:@"ContentBackground" toObject:self.view];
}
```

## Where the magic happens:

### `UIView+Theming.m`:
```objective-c
+ (void)load
{
    [self
        mtf_registerThemeProperty:@"borderWidth"
        requiringValueOfClass:[NSNumber class]
        applier:^(NSNumber *width, UIView *view) {
            view.layer.borderWidth = width.floatValue;
        }];

    [self
        mtf_registerThemeProperty:@"borderColor"
        valueTransformerName:MTFColorFromStringTransformerName
        applier:^(UIColor *color, UIView *view) {
            view.layer.borderColor = color.CGColor;
        }];
    
    [self
        mtf_registerThemeProperty:@"backgroundColor"
        valueTransformerName:MTFColorFromStringTransformerName
        applier:^(UIColor *color, UIView *view) {
            view.backgroundColor = color;
        }];
}
```

### `UIButton+Theming.m`:

```objective-c
+ (void)load
{
    [self
        mtf_registerThemeProperty:@"textColor"
        valueTransformerName:MTFColorFromStringTransformer
        applier:^(UIColor *textColor, UIButton *button) {
            [button setTextColor:textColor forState:UIControlStateNormal];
    }];

    [self
        mtf_registerThemeProperties:@[
            @"fontName",
            @"fontSize"
        ] valueTransformersNamesOrRequiredClasses:@[
            [NSString class],
            [NSNumber class]
        ] applier:^(NSDictionary *properties, UIButton *button) {
            NSString *name = properties[@"fontName"];
            CGFloat size = [properties[@"fontSize"] floatValue];
            button.titleLabel.font = [UIFont fontWithName:name size:size];
        }];
}
```
