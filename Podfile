source 'https://github.com/CocoaPods/Specs.git'

Framework_name = 'AUTTheming'
Podspec_path = './'
# Target Names
Tests_target_name = 'Tests'
Theming_cli_target_name = 'AUTThemingSymbolsGenerator'
Buttons_target_name = 'ButtonsExample'
# Paths
Example_folder_name = 'Examples'
Tests_path = "#{Tests_target_name}/#{Tests_target_name}"
Buttons_path = "#{Example_folder_name}/#{Buttons_target_name}/#{Buttons_target_name}"
Theming_cli_path = "#{Theming_cli_target_name}/#{Theming_cli_target_name}"

workspace Framework_name

xcodeproj Tests_path
target Tests_target_name do
  platform :ios, '7.0'
  xcodeproj Tests_path
  pod Framework_name, :path => Podspec_path
end

xcodeproj Buttons_path
target Buttons_target_name do
  platform :ios, '7.0'
  xcodeproj Buttons_path
  pod 'Masonry'
  pod Framework_name, :path => Podspec_path
end

xcodeproj Theming_cli_path
target Theming_cli_target_name do
  platform :osx, '10.8'
  xcodeproj Theming_cli_path
  pod Framework_name, :path => Podspec_path
  pod 'GBCli'
end
