Pod::Spec.new do |s|
  s.platform     = :ios
  s.ios.deployment_target = "6.0"
  s.name         = "AFNetworking+ImageActivityIndicator"
  s.version      = "1.0.1"
  s.summary      = "AFNetworking+ImageActivityIndicator makes it easy to show an activity indicator while an image view's image is loading using AFNetworking."
  s.homepage     = "https://github.com/JRG-Developer/AFNetworking-ImageActivityIndicator"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Joshua Greene" => "josh@app-order.com" }
  s.source   	   = { :git => "https://github.com/JRG-Developer/AFNetworking-ImageActivityIndicator.git", :tag => "#{s.version}"}
  s.framework    = "UIKit"
  s.requires_arc = true

  s.dependency 'AFNetworking', '~> 2.0'
  s.source_files = "AFNetworking+ImageActivityIndicator/*.{h,m}"
end