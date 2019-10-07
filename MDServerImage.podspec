#
# Be sure to run `pod lib lint ImagePod.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MDServerImage'
  s.version          = '0.1.0'
  s.summary          = 'Downloading and caching images.'
  s.swift_version    = '5'
  s.description      = 'Swift library for downloading and caching images from the web.'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }

  s.homepage         = 'https://github.com/shubhamb-git/MDServerImage/'
  s.author           = { 'Shubham b' => 'shubhambairagi294@gmail.com' }

  s.source           = { :git => 'https://github.com/shubhamb-git/MDServerImage.git', :tag => s.version }

  s.ios.deployment_target = '10.0'

  s.source_files = 'MDServerImage/Classes/**/*.swift'

  s.frameworks = 'UIKit'
  
end
