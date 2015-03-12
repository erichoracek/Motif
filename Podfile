source 'https://github.com/CocoaPods/Specs.git'

FRAMEWORK_NAME = 'AUTTheming'
PODSPEC_PATH = './'
# Target Names
TESTS_TARGET_NAME = 'Tests'
THEMING_SYMBOLS_GENERATOR_TARGET_NAME = 'AUTThemingSymbolsGenerator'
BUTTONS_EXAMPLE_TARGET_NAME = 'ButtonsExample'
DYNAMIC_THEMES_EXAMPLE_TARGET_NAME = 'DynamicThemesExample'
# Paths
EXAMPLES_FOLDER = 'Examples'
TESTS_PATH = "#{TESTS_TARGET_NAME}/#{TESTS_TARGET_NAME}"
BUTTONS_EXAMPLE_PATH = "#{EXAMPLES_FOLDER}/#{BUTTONS_EXAMPLE_TARGET_NAME}/#{BUTTONS_EXAMPLE_TARGET_NAME}"
DYNAMIC_THEMES_EXAMPLE_PATH = "#{EXAMPLES_FOLDER}/#{DYNAMIC_THEMES_EXAMPLE_TARGET_NAME}/#{DYNAMIC_THEMES_EXAMPLE_TARGET_NAME}"
THEMING_SYMBOLS_GENERATOR_PATH = "#{THEMING_SYMBOLS_GENERATOR_TARGET_NAME}/#{THEMING_SYMBOLS_GENERATOR_TARGET_NAME}"

workspace FRAMEWORK_NAME

xcodeproj TESTS_PATH
target TESTS_TARGET_NAME do
  platform :ios, '7.0'
  xcodeproj TESTS_PATH
  pod FRAMEWORK_NAME, :path => PODSPEC_PATH
end

xcodeproj BUTTONS_EXAMPLE_PATH
target BUTTONS_EXAMPLE_TARGET_NAME do
  platform :ios, '7.0'
  xcodeproj BUTTONS_EXAMPLE_PATH
  pod 'Masonry'
  pod FRAMEWORK_NAME, :path => PODSPEC_PATH
end

xcodeproj DYNAMIC_THEMES_EXAMPLE_PATH
target DYNAMIC_THEMES_EXAMPLE_TARGET_NAME do
  platform :ios, '7.0'
  xcodeproj DYNAMIC_THEMES_EXAMPLE_PATH
  pod 'Masonry'
  pod FRAMEWORK_NAME, :path => PODSPEC_PATH
end

xcodeproj THEMING_SYMBOLS_GENERATOR_PATH
target THEMING_SYMBOLS_GENERATOR_TARGET_NAME do
  platform :osx, '10.8'
  xcodeproj THEMING_SYMBOLS_GENERATOR_PATH
  pod FRAMEWORK_NAME, :path => PODSPEC_PATH
  pod 'GBCli'
end

# Add AUTTHEMING_DISABLE_SYMBOL_RESOLUTION define to preprocessor macros in theming symbols generator project
post_install do |installer|
  installer.project.targets.each do |target|
    target.build_configurations.each do |config|
      if target.to_s == "Pods-#{THEMING_SYMBOLS_GENERATOR_TARGET_NAME}-#{FRAMEWORK_NAME}"
        preprocessor_definitions = config.build_settings['GCC_PREPROCESSOR_DEFINITIONS']
        preprocessor_definitions = [ '$(inherited)' ] if preprocessor_definitions == nil
        preprocessor_definitions.push('AUTTHEMING_DISABLE_SYMBOL_RESOLUTION') if target.to_s.include?(THEMING_SYMBOLS_GENERATOR_TARGET_NAME)
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = preprocessor_definitions
      end
    end
  end
end
