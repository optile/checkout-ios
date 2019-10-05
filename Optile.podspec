Pod::Spec.new do |s|
  s.name             = 'Optile'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Optile.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/optile/ios-sdk'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  # s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'optile GmbH' => '' }
  s.source           = { :git => 'https://github.com/optile/ios-sdk.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  # s.source_files = 'Sources/Optile/**/*'
  
  # s.resource_bundles = {
  #   'Optile' => ['Optile/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit'
  # s.dependency 'API'

  # spec.default_subspec = 'Optile/PaymentUI'

  s.subspec 'PaymentUI' do |ss|
    ss.dependency 'Optile/Network'
    ss.source_files = 'Sources/PaymentUI/**/*.swift'
  end

  s.subspec 'Network' do |ss|
    # ss.dependency ''
    ss.source_files = 'Sources/Network/**/*.swift'
  end

end
