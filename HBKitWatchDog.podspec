Pod::Spec.new do |s|
s.name         = "HBKitWatchDog"
s.version      = "1.0.2"
s.summary      = "实时监听文件变化 HBKitWatchDog refresh view for hbkit."
s.homepage     = "https://github.com/Natoto/HBKit"
s.license      = "MIT"
s.authors      = { 'nonato ' => '787038442@qq.com'}
s.platform     = :ios,'7.0'
s.source       = { :git => "https://github.com/Natoto/HBKit.git", :tag => s.version }
s.source_files = "tools/HBKitWatchDog/**/*.{h,m}"
s.requires_arc = true 
s.dependency 'HBKit'
end
