Pod::Spec.new do |s|
  s.name             = "JCWebImage"
  s.version          = "1.0.0"
  s.summary          = "A lightweight web image cache library with loading progress"
  s.description      = <<-DESC
                       A lightweight web image cache library with loading progress.
                       DESC
  s.homepage         = "https://github.com/yojie/JCWebImage"
  # s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Jai Chow" => "yonkit@live.com" }
  s.source           = { :git => "https://github.com/yojie/JCWebImage.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/NAME'
 
  s.platform     = :ios, '8.0'
  # s.ios.deployment_target = '5.0'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true
 
  s.source_files = 'JCWebImage/Loader/*'
 
  # s.ios.exclude_files = 'Classes/osx'
  # s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'Foundation', 'UIKit'

end
