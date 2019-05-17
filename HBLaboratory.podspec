# 

Pod::Spec.new do |s|
  s.name             = "HBLaboratory"
  s.version          = "1.0.0"
  s.summary          = "实验室框架"
  s.homepage         = "https://github.com/Natoto/HBKit.git"
  s.license          = 'MIT'
  s.author           = { "huangbo" => "huangbo@yy.com" }
  s.source           = { :git => "https://github.com/Natoto/HBKit.git"} 
  s.ios.deployment_target = '7.0' 
  s.source_files = 'HBLaboratory/**/*.{h,m,mm}' 
  s.resource = 'HBLaboratory/**/*.{bundle,xib,storyboard}'
  s.public_header_files = 'HBLaboratory/**/*.h'  
  #s.dependency 'YCViper' 
  s.dependency 'HBTesterKit' 

end
