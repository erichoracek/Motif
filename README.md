# Motif

[![Build Status](https://travis-ci.org/erichoracek/Motif.svg?branch=master)](https://travis-ci.org/erichoracek/Motif)

_A lightweight and customizable CSS-style framework for iOS._

## What can it do?

<!-- ![Brightness Theming](README/brightness.gif) -->
![Brightness Theming](https://github.com/erichoracek/Motif/blob/master/README/brightness.gif?raw=true)

Dynamically change your app's appearance from a user setting, as an premium feature, or even from the screen's brightness like Tweetbot (pictured) or based on the time of day like Apple Maps.

## Why should I use it?

You have an app. Maybe even a family of apps. You know about CSS, which enables web developers to write a set of declarative classes to style elements throughout their site, creating composable interface definitions that are entirely divorced from content or layout. You'll admit that you're a little jealous that things aren't quite the same on iOS.

To style your app, maybe you have a `MyAppStyle` singleton that vends styled interface components that's a dependency of nearly every view controller in your app. Maybe you use Apple's `UIAppearance` APIs, but you're limited to a frustratingly small subset of the appearance APIs. Maybe you've started to subclass some UIKit classes just to set a few defaults to create some styled components. You know this sucks, but there just isn't a better way to do things in iOS.

Well, things about about to change. Take a look at the example below to see what `Motif` can do for you:

## An example

The following is a simple example of how you'd create a pair of styled buttons with Motif. To follow along, you can either continue reading below or clone this repo and run the `Buttons Example` target within `Motif.xcworkspace`.

### The design

<!-- <img src="README/buttons.png" alt="Horizontal Layout" height="91" width="339" /> -->
<img src="https://github.com/erichoracek/Motif/blob/master/README/Buttons.png?raw=true" alt="Horizontal Layout" height="91" width="339" />

Your designer just sent over a spec outlining the style of a couple buttons in your app. Since you'll be using Motif to create these components, that means it's time to create a theme file.

### Theme files

A theme file in Motif is just a simple JSON dictionary. It can have two types of key/value pairs: _classes_ or _constants_:

- Classes: Denoted by a leading period (e.g. `.Button`) and encoded as a nested JSON dictionary, a class is a collection of named properties corresponding to values that together define the style of an element in your interface. Class property values can be any JSON types, or alternatively references to other classes or constants.

- Constants: Denoted by a leading dollar sign (e.g. `$RedColor`) and encoded as a key-value pair, a constant is a named reference to a value. Constant values can be any JSON types, or alternatively a reference to a class or constant.

To create the buttons from the design spec, we've written the following theme file:

#### `Theme.json`

```javascript
{
    "$RedColor": "#f93d38",
    "$BlueColor": "#50b5ed",
    "$FontName": "AvenirNext-Regular",
    ".ButtonText" {
        "fontName": "$FontName",
        "fontSize": 16
    },
    ".Button": {
        "borderWidth": 1,
        "cornerRadius": 5,
        "contentEdgeInsets": "{10, 20, 10, 20}"
        "tintColor": "$BlueColor",
        "borderColor": "$BlueColor",
        "titleText": ".ButtonText",
    },
    ".DestructiveButton": {
        "_superclass": ".Button",
        "tintColor": "$RedColor",
        "borderColor": "$RedColor"
    }
}
```

We've started by defining three constants: our button colors as `$RedColor` and `$BlueColor`, and our font name as `$FontName`. We choose define these values as constants because we'll probably want to have them available again down the line when we're styling other components, and also because it's nice to give them a name that describes their function. We're now able to reference these constants anywhere else in the theme file by their names—just like variables in [less](http://lesscss.org) or [Sass](http://sass-lang.com).

We now declare our first class: `.ButtonText`. This class describes the attributes of the text within the button—both its font and size. From now on, we'll use this class to declare that we want text to have this specific style.

Next, we declare the class to style the primary button from the spec: `.Button`. The button class has a number of properties, each declaring a specific attribute of the styled button that together enable us to create the button from the design spec. For example, the first two properties on `.Button` declare that the button should have a 1 point `borderWidth` and a 5 point `cornerRadius`.

A few of the properties on the `.Button` class are different from others: they're *references* to other constants or classes. For example, the `tintColor` property is declared with a value of `$BlueColor`, meaning that when the button class is applied to a button, its text should be the color defined in the `$BlueColor` constant. As such, if you change the value of the `$BlueColor` constant above, the `tintColor` of the button will change as well.

Another *reference* property on the `.Button` class is `titleText`, which is a reference to the `.ButtonText` class that we defined above. Here we're declaring that the text of the button should have the attributes of the `.ButtonText` class. As such, whenever we change any of the attributes of the `.ButtonText` class, the text style of the button will change as well.

Last of all, we declare our `.DestructiveButton` class. This class is exactly like our previous classes except for one key difference: it inherits its properties from the `.Button` class via the `_superclass` directive. As such, when the `.DestructiveButton` class is applied to an interface component, it will have identical styling to that of `.Button`, except for its `tintColor` and `borderColor`, which it overrides the values of.

### Property appliers

Next, we'll create the _property appliers_ necessary to apply this theme to our interface elements. Most of the time, Motif is able to figure out how to apply the theme properties automatically by matching Motif property names to Objective-C class property names. However, in the case of some properties, we have to declare how we'd like a property to be applied ourselves. To do this, we'll register our necessary theme property appliers in the `initialize` method of a few categories.

The first set of property appliers we've created is on `UIView`:

#### `UIView+Theming.m`
```objective-c
+ (void)initialize {
    [self
        mtf_registerThemeProperty:@"borderWidth"
        requiringValueOfClass:NSNumber.class
        applier:^(NSNumber *width, UIView *view) {
            view.layer.borderWidth = width.floatValue;
        }];

    [self
        mtf_registerThemeProperty:@"borderColor"
        valueTransformerName:MTFColorFromStringTransformerName
        applier:^(UIColor *color, UIView *view) {
            view.layer.borderColor = color.CGColor;
        }];
}
```

Here we've added two property appliers to `UIView` for both `borderWidth` and `borderColor`. Since these properties are defined on `CALayer` rather than `UIView`, we need to create property appliers to enable the properties from the `.Button` class to be applied.

#### Applier type safety

If we want to ensure that we always apply property values a specific type, we can specify that an applier requires a value of a certain class by using `requiringValueOfClass:` when registering an applier. In the case of the `borderWidth` property, we require that its value is of class `NSNumber`. This way, if we every accidentally provide a non-number value for a `borderWidth` property, a runtime exception will be thrown so that we can easily identify and fix our mistake.

#### Applier value transformers

In the case of `borderColor`, the value specified in the JSON theme is not a color, but instead a color written as a string (e.g. `#f93d38`). To ensure that the applied property value is transformed from a `NSString` to a `UIColor` before entering the applier block, we specify a `valueTransformerName:` of `MTFColorFromStringTransformerName` when registering the `borderColor` property. This name identifies a custom `NSValueTransformer` subclass included in Motif that transforms values from `NSString` to `UIColor`. By specifying this transformer, there's no need to manually decode the string-encoded color each time the applier is called. Instead, when the applier block is invoked, the property value is already of type `UIColor`, and setting this value as the `borderColor` of a view is just a one line operation.

This is the beginning of our custom set of _rules_ for Motif. Now that we've defined these two properties, whenever we have another need to that apply a `borderColor` or `borderWidth` to a `UIView`, these appliers can be reused.


### `UILabel+Theming.m`

```objective-c
+ (void)initialize {
    [self
        mtf_registerThemeProperties:@[
            @"fontName",
            @"fontSize"
        ] valueTransformerNamesOrRequiredClasses:@[
            NSString.class,
            NSNumber.class
        ] applierBlock:^(NSDictionary *properties, UIButton *button) {
            NSString *name = properties[@"fontName"];
            CGFloat size = [properties[@"fontSize"] floatValue];
            button.titleLabel.font = [UIFont fontWithName:name size:size];
        }];
}
```

#### Compound property appliers

### `UIButton+Theming.m`

```objective-c
+ (void)initialize {
    [self
        mtf_registerThemeProperty:"titleText"
        requiringValueOfClass:MTFThemeClass.class
        applierBlock:^(MTFThemeClass *themeClass, UIButton *button) {
            [themeClass applyToObject:button.titleLabel];
        }];
}
```

#### Properties with `MTFClass` values

### Putting it all together

### `MyViewController.m`

```objective-c
NSError *error;
MTFTheme *theme = [MTFTheme themeFromJSONThemeNamed:@"Theme" error:&error];
NSAssert(error != nil, @"Error loading theme %@", error);

[theme applyClassWithName:@"Button" toObject:saveButton];
[theme applyClassWithName:@"DestructiveButton" toObject:deleteButton];
```

## Using Motif in your project

## Dynamic theming

## Generating theme symbols

## Contributing
