Pod::Spec.new do |s|
  s.name = 'AUTTheming'
  s.version = '0.0.1'
  s.license = {
    :type => 'Copyright',
    :text => <<-LICENSE
      Copyright 2015 Automatic Labs, Inc. All rights reserved.
      LICENSE
  }
  s.osx.deployment_target = '10.8'
  s.ios.deployment_target  = '7.0'
  s.summary = 'Style sheets for iOS and appliers'
  s.homepage = 'https://github.com/erichoracek/AUTTheming'
  s.author = { 'Eric Horacek' => 'eric@automatic.com' }
  s.source = { :git => 'https://github.com/erichoracek/#{s.name}.git', :tag => s.version.to_s}
  s.frameworks = 'Foundation'
  s.dependency 'libextobjc/RuntimeExtensions', '~> 0.4.0'

  s.source_files = "#{s.name}/*.{h,m}"
  s.ios.source_files = "#{s.name}/ValueTransformers/*.{h,m}"
  s.ios.dependency 'UIColor-HTMLColors', '1.0.0'

end
