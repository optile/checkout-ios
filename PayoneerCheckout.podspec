Pod::Spec.new do |s|
  s.name             = 'PayoneerCheckout'
  s.version          = '0.2.0'
  s.summary          = 'Payoneer Checkout SDK for iOS-based devices'

  s.homepage         = 'https://github.com/optile/checkout-ios'
  s.license          = { :type => 'MIT' }
  s.author           = { 'Payoneer Germany GmbH' => '' }
  s.source           = { :git => 'https://github.com/optile/checkout-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.4'
  s.swift_version = '5.3'

  s.source_files = 'Sources/**/*.swift'
  
  s.resources = ['Sources/Assets/*']

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'MaterialComponents/TextFields', '117.0.0'

end
