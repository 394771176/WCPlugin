#
# Be sure to run `pod lib lint WCPlugin.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WCPlugin'
  s.version          = '0.1.1'
  s.summary          = 'WCPlugin.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "常用的第三方UI插件"

  s.homepage         = 'https://github.com/394771176/WCPlugin'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '394771176' => '394771176@qq.com' }
  s.source           = { :git => 'https://github.com/394771176/WCPlugin.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  # s.source_files = 'WCPlugin/Classes/**/*'
  
  # s.resource_bundles = {
  #   'WCPlugin' => ['WCPlugin/Assets/*.png']
  # }

  s.subspec 'FLAnimatedImage' do |fl|
    fl.source_files = [
    'WCPlugin/Classes/FLAnimatedImage/*',
    ]
    fl.frameworks = 'ImageIO', 'MobileCoreServices', 'QuartzCore'
    fl.dependency 'WCModule/SDWebImage'
  end

  s.subspec 'MBProgressHUD' do |hud|
    hud.source_files = [
    'WCPlugin/Classes/MBProgressHUD/*',
    ]
    hud.frameworks = 'CoreGraphics'
    hud.resources = 'WCPlugin/Classes/*.bundle'
  end

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation'
  # s.dependency 'AFNetworking', '~> 2.3'
end
