Pod::Spec.new do |s|
s.name         = "HBKit"
s.version      = "1.0.4"
s.summary      = "A  Fast Style TableViewController."
s.homepage     = "https://github.com/Natoto/HBKit.git"
s.license      = "MIT"
s.authors      = { 'nonato ' => '787038442@qq.com'}
s.platform     = :ios,'7.0'
s.source       = { :git => "https://github.com/Natoto/HBKit.git", :tag => s.version }
s.source_files = "HBKit/**/*.{h,m,plist}"
#s.vendored_frameworks = 'HBTesterKit/framework/FLEX.framework'
s.requires_arc = true 
end
