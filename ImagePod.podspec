#
# Be sure to run `pod lib lint ImagePod.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ImagePod'
  s.version          = '0.1.0'
  s.summary          = 'A short description of ImagePod.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/shubhamb-git/MDServerImage/'
  s.author           = { 'Shubham b' => 'shubhambairagi294@gmail.com' }

  s.source           = { :git => 'https://github.com/shubhamb-git/MDServerImage', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'ImagePod/Classes/**/*.swift'
  s.resources = [
    'ImagePod/Classes/**/*.{storyboard,xib}',
    'ImagePod/Assets/**/*'
  ]

  s.frameworks = 'UIKit'
end
