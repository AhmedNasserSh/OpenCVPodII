Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '11.0'
s.name = "OpenCVPodII"
s.summary = "pod test"
s.requires_arc = true
s.version = "0.1.0"
s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "Ahmed Nasser" => "ahmed.nasser2310@gmail.com" }
s.homepage = "https://github.com/AvaVaas/OpenCVPodII"
s.source = { :git => "https://github.com/AvaVaas/OpenCVPodII.git", :tag => "#{s.version}"}

s.frameworks = 'UIKit', 'AVFoundation','UIKit','CoreVideo','Accelerate','AssetsLibrary','QuartzCore','Foundation','CoreMedia', 'CoreImage','AVFoundation'

s.dependency 'OpenCV'

s.source_files = "OpenCVPod/*.{h,m,mm,hpp,cpp}"
s.resources = "OpenCVPod/**/*.{xml}"


end

