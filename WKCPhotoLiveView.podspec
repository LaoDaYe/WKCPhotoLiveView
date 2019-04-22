Pod::Spec.new do |s|
s.name         = "WKCPhotoLiveView"
s.version      = "0.1.5"
s.summary      = "WKCPhotoLiveView is a view for livwPhoto."
s.homepage     = "https://github.com/WeiKunChao/WKCPhotoLiveView.git"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author             = { "WeiKunChao" => "17736289336@163.com" }
s.platform     = :ios, "9.1"
s.source       = { :git => "https://github.com/WeiKunChao/WKCPhotoLiveView.git", :tag => "0.1.5" }
s.source_files  = "WKCPhotoLiveView/**/*.{h,m}"
s.public_header_files = "WKCPhotoLiveView/**/*.h"
s.frameworks = "Foundation", "UIKit", "Photos", "PhotosUI"
s.requires_arc = true
s.dependency "AFNetworking"
s.dependency "SDWebImage"

end
