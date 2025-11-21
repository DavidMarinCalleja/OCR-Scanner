require File.join(File.dirname(`node --print "require.resolve('expo/package.json')"`), "scripts/autolinking")
require File.join(File.dirname(`node --print "require.resolve('react-native/package.json')"`), "scripts/react_native_pods")

require 'json'

platform :ios, '15.1'
install! 'cocoapods',
  :deterministic_uuids => false

prepare_react_native_project!

target 'VoucherScanner' do
  use_expo_modules!

  config_command = [
    'npx',
    'expo-modules-autolinking',
    'react-native-config',
    '--json',
    '--platform',
    'ios'
  ]
  config = use_native_modules!(config_command)

  use_frameworks! :linkage => ENV['USE_FRAMEWORKS'].to_sym if ENV['USE_FRAMEWORKS']

  use_react_native!(
    :path => config[:reactNativePath],
    :hermes_enabled => true,
    # An absolute path to your application root.
    :app_path => "#{Pod::Config.instance.installation_root}/..",
    :privacy_file_aggregation_enabled => true,
  )

  post_install do |installer|
    react_native_post_install(
      installer,
      config[:reactNativePath],
      :mac_catalyst_enabled => false,
    )
  end
end
