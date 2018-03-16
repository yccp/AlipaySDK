Pod::Spec.new do |s|

  s.name                  = 'AlipaySDK_MI'
  s.version               = '15.5.0'
  s.summary               = 'Alipay payment SDK, support manual integration and Cocoapods integration mode, continuous update.'
  s.homepage              = 'https://github.com/caosuyang/AlipaySDK'
  s.ios.deployment_target = '7.0'
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'caosuyang' => 'caosuyang1026@gmail.com' }
  s.social_media_url      = 'https://twitter.com/caosuyang1'
  s.source                = { :git => 'https://github.com/caosuyang/AlipaySDK.git', :tag => s.version }
  s.frameworks            = 'SystemConfiguration', 'CoreTelephony', 'QuartzCore', 'CoreText', 'CoreGraphics', 'UIKit', 'Foundation','CFNetwork', 'CoreMotion'
  s.libraries             = 'z', 'c++'
  s.resource              = 'AlipaySDK/AlipaySDK.bundle'
  s.vendored_frameworks   = 'AlipaySDK/AlipaySDK.framework'
  s.requires_arc          = true
  
end

