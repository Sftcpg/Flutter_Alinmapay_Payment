#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_alinmapay_payment.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_alinmapay_payment'
  s.version          = '2.0.0'
  s.summary          = 'Official Flutter plugin for Alinma Pay Payment SDK integration.'
  s.description      = <<-DESC
Official Flutter plugin for Alinma Pay Payment SDK integration, supporting secure and seamless payment processing.
                       DESC
  s.homepage         = 'https://github.com/Sftcpg/Flutter_Alinmapay_Payment'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Alinma Pay' => 'alinmapaypg@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.vendored_frameworks ='Frameworks/PaymentSDK.xcframework'
  s.preserve_paths      = 'Frameworks/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '15.6'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'flutter_alinmapay_payment_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
