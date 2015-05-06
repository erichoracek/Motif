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
