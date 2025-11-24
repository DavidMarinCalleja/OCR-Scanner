expo_root = File.expand_path('ocr-expo', __dir__)
expo_ios_path = File.join(expo_root, 'ios')
expo_pkg = `node --print "require.resolve('expo/package.json', { paths: ['#{expo_root}'] })"`.strip
react_native_pkg = `node --print "require.resolve('react-native/package.json', { paths: ['#{expo_root}'] })"`.strip

ENV['NODE_PATH'] = [ENV['NODE_PATH'], File.join(expo_root, 'node_modules')].compact.join(':')
node_options_helper = File.expand_path('scripts/expo-node-path.cjs', __dir__)
ENV['NODE_OPTIONS'] = [ENV['NODE_OPTIONS'], "--require #{node_options_helper}"].compact.join(' ')

require File.join(File.dirname(expo_pkg), "scripts/autolinking")
require File.join(File.dirname(react_native_pkg), "scripts/react_native_pods")

require 'json'

platform :ios, '15.1'
install! 'cocoapods',
  :deterministic_uuids => false

prepare_react_native_project!

target 'VoucherScanner' do
  use_expo_modules!(
    projectRoot: expo_root,
    searchPaths: ['--project-root', expo_root]
  )

  config_command = [
    'npx',
    'expo-modules-autolinking',
    'react-native-config',
    '--json',
    '--platform',
    'ios',
    '--project-root',
    expo_root
  ]
  config = use_native_modules!(config_command)
  react_native_path = File.join('ocr-expo', 'node_modules', 'react-native')

  use_frameworks! :linkage => ENV['USE_FRAMEWORKS'].to_sym if ENV['USE_FRAMEWORKS']

  use_react_native!(
    :path => react_native_path,
    :hermes_enabled => true,
    # An absolute path to your application root.
    :app_path => expo_root,
    :privacy_file_aggregation_enabled => true,
  )

  post_install do |installer|
    react_native_post_install(
      installer,
      react_native_path,
      :mac_catalyst_enabled => false,
    )

    installer.pods_project.targets.each do |target|
      if target.name == 'EXConstants'
        target.build_configurations.each do |config|
          config.build_settings['PROJECT_ROOT'] = expo_root
        end
      end
    end
  end
end
