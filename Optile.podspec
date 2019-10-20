Pod::Spec.new do |s|
  s.name             = 'Optile'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Optile.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/optile/ios-sdk'
  # s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'optile GmbH' => '' }
  s.source           = { :git => 'https://github.com/optile/ios-sdk.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'Sources/**/*'
  
  # s.resource_bundles = {
  #   'Optile' => ['Optile/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit'
  # s.dependency 'API'

end
