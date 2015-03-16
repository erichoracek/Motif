desc 'Run the Cocoapods library linter on AUTTheming'
task :lint do
  setup_environment
  sh "bundle exec pod lib lint --allow-warnings '#{ENV['PODSPEC_PATH']}'"
end

desc 'Run the Tests on AUTTheming'
task :test do
  setup_environment
  sh %{ \
    xcodebuild test \
    -workspace '#{ENV['WORKSPACE_PATH']}' \
    -scheme '#{ENV['SCHEME_TESTS']}' \
    -destination '#{ENV['DEST_SIM']}' \
    | xcpretty --color ; exit ${PIPESTATUS[0]}
  }
end

desc 'Build the AUTTheming Example projects'
task :build_examples do
  setup_environment
  # Build buttons example
  sh %{ \
    xcodebuild build \
    -workspace '#{ENV['WORKSPACE_PATH']}' \
    -scheme '#{ENV['SCHEME_BUTTONS_EXAMPLE']}' \
    -destination '#{ENV['DEST_SIM']}' \
    | xcpretty --color ; exit ${PIPESTATUS[0]}
  }
  # Build swift example
  sh %{ \
    xcodebuild build \
    -workspace '#{ENV['WORKSPACE_PATH']}' \
    -scheme '#{ENV['SCHEME_DYNAMIC_THEMES_EXAMPLE']}' \
    -destination '#{ENV['DEST_SIM']}' \
    | xcpretty --color ; exit ${PIPESTATUS[0]}
  }
end

private

LIBRARY_NAME = 'AUTTheming'

def setup_environment
  ENV['WORKSPACE'] = "#{__FILE__.gsub "/Rakefile", ""}"
  ENV['WORKSPACE_PATH'] = "#{ENV['WORKSPACE']}/#{LIBRARY_NAME}.xcworkspace"
  ENV['PODSPEC_PATH'] = "#{ENV['WORKSPACE']}/#{LIBRARY_NAME}.podspec"
  ENV['SCHEME_TESTS'] = 'Tests'
  ENV['SCHEME_BUTTONS_EXAMPLE'] = 'ButtonsExample'
  ENV['SCHEME_DYNAMIC_THEMES_EXAMPLE'] = 'DynamicThemesExample'
  ENV['DEST_SIM'] = 'platform=iOS Simulator,name=iPhone 4s,OS=latest'
end
