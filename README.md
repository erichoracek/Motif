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
    ".ButtonText": {
        "fontName": "$FontName",
        "fontSize": 16
    },
    ".Button": {
        "borderWidth": 1,
        "cornerRadius": 5,
        "contentEdgeInsets": "{10, 20, 10, 20}",
        "tintColor": "$BlueColor",
        "borderColor": "$BlueColor",
        "titleText": ".ButtonText"
    },
    ".WarningButton": {
        "_superclass": ".Button",
        "tintColor": "$RedColor",
        "borderColor": "$RedColor"
    }
}
```

We've started by defining three constants: our button colors as `$RedColor` and `$BlueColor`, and our font name as `$FontName`. We choose to define these values as constants because we want to be able to reference these constants anywhere else in the theme file by their names—just like variables in [less](http://lesscss.org) or [Sass](http://sass-lang.com).

We now declare our first class: `.ButtonText`. This class describes the attributes of the text within the button—both its font and size. From now on, we'll use this class to declare that we want text to have this specific style.

You'll notice that the value of the `fontName` property on the `.ButtonText` class is a *reference* to the `$FontName` constant we declared above. As you can probably guess, when we use this class, its font name will have the same value as the `$FontName` constant. This way, we're able to have one definitive place that our font name exists so we don't end up repeating ourselves.

The last class we declare is our `.WarningButton` class. This class is exactly like our previous classes except for one key difference: it inherits its properties from the `.Button` class via the `_superclass` directive. As such, when the `.WarningButton` class is applied to an interface component, it will have identical styling to that of `.Button`, except for its `tintColor` and `borderColor`, which it overrides the values of to be `$RedColor` instead.

### Property appliers

Next, we'll create the _property appliers_ necessary to apply this theme to our interface elements. Most of the time, Motif is able to figure out how to apply your theme automatically by magically matching Motif property names to Objective-C property names. However, in the case of some properties, we have to declare how we'd like a property to be applied ourselves. To do this, we'll register our necessary theme property appliers in the `initialize` method of a few categories.

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

Here we've added two property appliers to `UIView`: for the `borderWidth` and `borderColor` properties. Since `UIView` doesn't have properties for these attributes, we need property appliers to teach Motif how to apply them to the underlying `CALayer`.

#### Applier type safety

If we want to ensure that we always apply property values a specific type, we can specify that an applier requires a value of a certain class by using `requiringValueOfClass:` when registering an applier. In the case of the `borderWidth` property above, we require that its value is of class `NSNumber`. This way, if we ever accidentally provide a non-number value for a `borderWidth` property, a runtime exception will be thrown so that we can easily identify and fix our mistake.

#### Applier value transformers

In the case of `borderColor`, the value specified in the JSON theme is not a color, but instead a color written as a string (e.g. `#f93d38`). To ensure that this value is transformed from a `NSString` to a `UIColor` before entering the applier block, we specify a `valueTransformerName:` of `MTFColorFromStringTransformerName` when registering the `borderColor` property. This name identifies a custom `NSValueTransformer` subclass included in Motif that transforms values from `NSString` to `UIColor`. By specifying this transformer, there's no need to manually decode the string-encoded color each time the applier is called. Instead, when the applier block is invoked, the property value is already of type `UIColor`, and setting this value as the `borderColor` of a view is just a one line operation.

Now that we've defined these two properties on `UIView`, whenever we have another class wants to specify a `borderColor` or `borderWidth`, these appliers will be able to apply those values as well.

Next up, we're going to get `UILabel` appliers working:

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

The above applier is a _compound property applier_. This means that it's a property applier that requires multiple property values from the theme class for it to be applied. In this case, we need this because we can not create a `UIFont` object without having both the size and name of the font beforehand.

### `UIButton+Theming.m`

```objective-c
+ (void)initialize {
    [self
        mtf_registerThemeProperty:"titleText"
        requiringValueOfClass:MTFThemeClass.class
        applierBlock:^(MTFThemeClass *class, UIButton *button) {
            [class applyToObject:button.titleLabel];
        }];
}
```

The final applier that we'll need is on `UIButton` to style its `titleLabel`.

#### Properties with `MTFClass` values

We've just created a style applier on `UILabel` that allows us to give it a custom font from a theme class. Thankfully, this is all we need to style our `UIButton`'s `titleTabel`. Since the `titleText` property on the `.Button` class is a reference to the `.ButtonText` class, the value that comes through the applier will be of class `MTFClass`. `MTFClass` objects are used to represent classes like `.TitleText` from theme files, and are able to apply their properties to an object. As such, to apply the font from the `.TitleText` class to our button's label, we simply invoke `applyToObject:` on `titleLabel` with the passed `MTFTheme`.

### Putting it all together

```objective-c
NSError *error;
MTFTheme *theme = [MTFTheme themeFromJSONThemeNamed:@"Theme" error:&error];
NSAssert(error != nil, @"Error loading theme %@", error);

[theme applyClassWithName:@"Button" toObject:saveButton];
[theme applyClassWithName:@"WarningButton" toObject:deleteButton];
```

We now have everything we need able to style our buttons to match the spec. To do so, we must instantiate a `MTFTheme` object from our theme file. The best way to do this is to use `themeFromJSONThemeNamed:`, which works just like `imageNamed:`, but for `MTFTheme` instead of `UIImage`.

When we have our `MTFTheme`, we want to make sure there were no errors parsing it. We do so by asserting that the pass-by-reference error pointer is still non-nil. By using `NSAssert` we'll get a runtime crash when debugging informing us our errors

To apply the classes from `Theme.json` to our buttons, all we have to do is invoke the application methods on `MTFTheme` on theme. When we do so, all of the properties are applied from the class to the button in just one simple method class. This is the power of Motif.

## Using Motif in your project

## Dynamic theming

## Generating theme symbols

## Contributing
