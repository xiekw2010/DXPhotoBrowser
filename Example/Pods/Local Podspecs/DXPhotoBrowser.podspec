#
# Be sure to run `pod lib lint DXPhotoBrowser.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DXPhotoBrowser"
  s.version          = "0.1.2"
  s.summary          = "Yet another light weight photo browser for displaying a series of photos."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = "Yet another light weight photo browser for displaying a series of photos. Enjoy it!"

  s.homepage         = "https://github.com/xiekw2010/DXPhotoBrowser"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "xiekw2010" => "xiekw2010@gmail.com" }
  s.source           = { :git => "https://github.com/xiekw2010/DXPhotoBrowser.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/*{h,m}'
  s.resource_bundles = {
    'DXPhotoBrowser' => ['Pod/Assets/*.png']
  }


  s.subspec 'ImageUtils' do |cc|
   cc.source_files = 'Pod/Classes/ImageUtils'
  end

  s.subspec 'InternalViews' do |dd|
   dd.source_files = 'Pod/Classes/InternalViews'
  end

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'Accelerate'
  # s.dependency 'AFNetworking', '~> 2.3'
end
