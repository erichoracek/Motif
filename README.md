# AUTTheming

_A lightweight and customizable CSS-style framework for Objective-C._

## Why should I use it?

You have an app. Maybe even a family of apps. You know about CSS, which enables web developers to write a set of declarative rules that style elements throughout their site, creating reusable interface components that are entirely divorced from content or layout. You'll admit that you're a little jealous that things aren't quite the same on iOS. Maybe you have a `MyAppStyle` singleton that vends styled objects, which is a dependency of nearly every view controller in your app. Maybe you even use Apple's `UIAppearance` APIs, but you're limited to a subset of supported APIs, and declare all your rules in a really long method in a `Style` singleton which defines a convoluted set of rules for your entire app. Maybe you've even started to subclass UIKit classes just to set a few defaults to create some styled components. You know this sucks, but there just isn't a better way to do things in iOS.

Well, things about about to change. Take a look at the example below to see what `AUTTheming` can do for you:

## Example

### The output:

<img src="README/buttons.png" alt="Horizontal Layout" height="91" width="339" />

### `MyAppTheme.json`:

```javascript
{
    "$RedColor": "#f93d38",
    "$BlueColor": "#50b5ed",
    "$RegularFontName": "AvenirNext-Regular",
    "$H5FontSize": 16
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
    }
}
```

### `ViewController.m`:

```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];

    AUTTheme *theme = [AUTTheme themeWithThemeNamed:@"MyApp" error:nil];
    AUTThemeApplier *themeApplier = [[AUTThemeApplier alloc] initWithTheme:theme]

    self.deleteButton = [UIButton new];
    self.saveButton = [UIButton new];

    [themeApplier applyThemeClassWithName:@"DestructiveButton" toObject:self.deleteButton];
    [themeApplier applyThemeClassWithName:@"PrimaryButton" toObject:self.deleteButton];
}
```

## Where the magic happens:

### `UIView+Theming.m`:
```objective-c
+ (void)load
{
    [self aut_registerThemeProperty:@"borderWidth"
              requiringValueOfClass:[NSNumber class]
                            applier:^(NSNumber *width, UIView *view) {
        view.layer.borderWidth = width.floatValue;
    }];

    [self aut_registerThemeProperty:@"borderColor"
               valueTransformerName:AUTColorFromStringTransformerName
                            applier:^(UIColor *color, UIView *view) {
        view.layer.borderColor = color.CGColor;
    }];
}
```

### `UIButton+Theming.m`:

```objective-c
+ (void)load
{
    [self aut_registerThemeProperty:@"textColor"
               valueTransformerName:AUTColorFromStringTransformer
                            applier:^(UIColor *textColor, UIButton *button) {
        [button setTextColor:textColor forState:UIControlStateNormal];
    }];

    [self aut_registerThemeProperty:@"contentEdgeInsets"
               valueTransformerName:AUTStringEdgeInsetsTransformer
                            applier:^(NSValue *edgeInsets, UIButton *button) {
        button.contentEdgeInsets = edgeInsets.UIEdgeInsetsValue;
    }];

    [self aut_registerThemeProperties:@[
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
