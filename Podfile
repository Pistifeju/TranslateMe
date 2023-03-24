platform :ios, 11.0

target 'TranslateX' do
  use_frameworks!

  pod 'SwiftLint'
  pod 'GoogleMLKit/Translate', '3.2.0'
  pod 'GoogleMLKit/LanguageID', '3.2.0'
  pod 'JGProgressHUD'

  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
end
