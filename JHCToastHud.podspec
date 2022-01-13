
Pod::Spec.new do |s|
  s.name             = 'JHCToastHud'
  s.version          = '0.1.0'
  s.summary          = 'toast类'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/jihengcong/JHCToastHud'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jihengcong' => '525995423@qq.com' }
  s.source           = { :git => 'https://github.com/jihengcong/JHCToastHud.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'JHCToastHud/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JHCToastHud' => ['JHCToastHud/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
