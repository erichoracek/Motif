# 0.3.4

## Fixes

- Fixes an issue that could cause some classes to not resolve superclass properties (#90)
- Project updates for Xcode 8 (#89)

# 0.3.3

- Fix angle bracet issue when included via CocoaPods (#82)
- Migrate from gcov to profdata (#87)

# 0.3.2

## Fixes

- Fixes an issue that could cause an `EXC_BAD_ACCESS` when an error occurred while creating a theme (#81)
- Fixes an issue where multiple inter-theme constant references could fail to resolve by recursively resolving constant references (#82)

# 0.3.1

## Features

- The Motif CLI now uses nullability annotations and modular imports in generated Objective-C symbols files (#76)

# 0.3.0

## Features

- Migrates to `NSError`s to communicate theme application failure in place of runtime exceptions. `applyClassWithName:toObject:` is now `applyClassWithName:to:error:` and applier blocks and value transformers are expected to populate a pass-by-reference `NSError` in the case of failure. (#67)
- Applying the same theme class twice in a row does not perform the work of applying twice. This is helpful in the context of reusable views where performance is critical. (#70)
- Adds support for Swift symbol output from the Motif CLI by passing the `-s` or `--swift` flag. (#56)
- Fixes a logic error that could cause the Motif CLI to display an error when there wasn't one when generating theme files. (#57)
- Adds annotations for Obj-C lightweight generics. (#60)
- Removes Example project's dependency on Masonry in place of `UIStackView`. (#61)

## Fixes

- Mapped constant values are now cached to prevent unnecessary overhead of requesting them on each access. (#75)
- Codebase cleanup (#62, #63, #64, #65, #68, #69, #71, #72, #73)

# 0.2.1

## Fixes

- Fixes for Xcode 7 and iOS 9 (thanks @ekurutepe!)  (#51, #52, #53, #54)
- Simplify Swift example project (#49)

# 0.2.0

## Features

- Adds support for [YAML](http://yaml.org) in addition to JSON as a much more human-friendly way of writing your theme files. See the README for some examples (#38)
  - Of course, while YAML is now the recommended way of writing theme files, JSON will still work
- Adds a class method to `NSValueTransformer` to enable easy registration of Motif value transformer subclasses without having to declare a new interface & implementation (#28)
- Removes the need specify value transformer names as part of applier registration (#43)
- Adds default value transformers for the following: (#42)
  - Creating `UIEdgeInsets` from an array, dictionary, or number in a theme file
  - Creating `CGSize` from an array, dictionary, or number in a theme file
  - Creating `CGPoint` from an array, dictionary, or number in a theme file
  - Creating `UIOffset` from an array, dictionary, or number in a theme file
- Removes old string value transformers in favor of the above
- Adds a keyword applier registration method for easily specifying enums as strings in themes (#31)

## Fixes

- Fixes a YAML number parsing bug (thanks @jlawton!) (#44)
- Removes backwards-compatible nullability annotations as Xcode 6.3+ is standard now. (#40)
- Uses modular imports in headers (#32)
- Re-throws non-NSUndefinedKeyException exceptions when applying classes (#30)
- Handles duplicate appliers with different classes (#29)
- Inlines applier blocks to work around rdar://20723086 (#37)
- Prevents Carthage from building the tests as part of build 3cc0695
- Overrides missing designated initializer (#46)

# 0.1.2

## Fixes

- Catch theme class application exceptions when live reloading themes
- Improve theme class application exception copy to better communicate ways to resolve issue

# 0.1.1

## Fixes

- Vastly improve documentation throughout Motif
- Remove unused file MTFThemeHierarchy.h
- Add tests to screen brightness theme applier
- Error when a theme class' superclass is self-referential or invalid

# 0.1.0

## Features

- Add live reloading dynamic theme applier, see the [section](https://github.com/erichoracek/Motif#live-reload) in the README for documentation

## Fixes

- Remove unused git submodules from repo
- Add warning to screen brightness example when run on simulator
- Ensure that a theme class reference is not applied to a theme class property
- Fix compilation errors when integrated with an Objective-C++ project
- Suggest `load` instead of `initialize` in Objective-C, due to initialize being called multiple times in categories, which could lead to duplicate appliers being registered

# 0.0.1

- Initial release
