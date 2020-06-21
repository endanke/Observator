#
# Be sure to run `pod lib lint Observator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Observator'
  s.version          = '0.2.0'
  s.summary          = 'Simple global data sharing mechanism for Swift.'
  s.homepage         = 'https://github.com/endanke/Observator'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'endanke' => 'endanke@gmail.com' }
  s.source           = { :git => 'https://github.com/endanke/Observator.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'
  s.tvos.deployment_target = '10.0'
  s.watchos.deployment_target = '3.0'
  s.swift_versions = ['4.0']

  s.source_files = 'Observator/**/*'
end
