Pod::Spec.new do |s|
  s.name = 'Motif'
  s.version = '0.1.2'
  s.license = {
    :type => 'MIT',
    :file => 'LICENSE'
  }
  s.osx.deployment_target = '10.8'
  s.ios.deployment_target  = '7.0'
  s.summary = 'A lightweight and customizable JSON stylesheet framework for iOS'
  s.homepage = "https://github.com/erichoracek/#{s.name}"
  s.author = { 'Eric Horacek' => 'eric@automatic.com' }
  s.source = {
    :git => "https://github.com/erichoracek/#{s.name}.git",
    :tag => s.version.to_s
  }
  s.frameworks = 'Foundation'
  s.ios.frameworks = 'UIKit'

  s.source_files = [
    "#{s.name}/#{s.name}.h",
    "#{s.name}/Core/*.{h,m}",
    "#{s.name}/Objective-C Runtime/*.{h,m}"
  ]
  s.ios.source_files = [
    "#{s.name}/iOS Support/*.{h,m}"
  ]
end
