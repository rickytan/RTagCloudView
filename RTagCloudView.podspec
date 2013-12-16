Pod::Spec.new do |s|
  s.name         = "RTagCloudView"
  s.version      = "1.0.0"
  s.summary      = "a UITableView like API tag cloud view"
  s.homepage     = "http://rickytan.me"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'rickytan' => 'ricky.tan.xin@gmail.com' }
  s.source       = { :git => "https://github.com/rickytan/RTagCloudView.git", :tag => s.version.to_s }
  s.platform     = :ios
  s.ios.deployment_target = '6.0'
  s.source_files = 'RTagCloudView/*.{h,m}'
  s.requires_arc = true
end