# 

Pod::Spec.new do |s|
  s.name             = "HBLaboratory"
  s.version          = "1.0.6"
  s.summary          = "摇一摇唤起实验室，自定制各种app配置"
  s.homepage         = "https://github.com/Natoto/HBKit/tree/master/HBLaboratory"
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
