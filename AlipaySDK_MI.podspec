Pod::Spec.new do |s|

  s.name                  = 'YCAlipaySDK'
  s.version               = '15.5.3'
  s.summary               = 'Alipay payment SDK, support manual integration and Cocoapods integration mode, continuous update.'
  s.homepage              = 'https://github.com/yccp/AlipaySDK'
  s.ios.deployment_target = '7.0'
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'Yu Chen' => 'yu.chen@live.ie' }
  s.source                = { :git => 'https://github.com/yccp/AlipaySDK.git', :tag => s.version }
  s.frameworks            = 'SystemConfiguration', 'CoreTelephony', 'QuartzCore', 'CoreText', 'CoreGraphics', 'UIKit', 'Foundation','CFNetwork', 'CoreMotion'
  s.libraries             = 'z', 'c++'
  s.resource              = 'AlipaySDK/AlipaySDK.bundle'
  s.vendored_frameworks   = 'AlipaySDK/AlipaySDK.framework'
  s.requires_arc          = true
  
end

