Pod::Spec.new do |s|

  s.name         = "XCDropdownMenu"
  s.version      = "1.0.1"
  s.summary      = "DropdownMenu"

  s.description  = "DropdownMenu自定义下拉菜单封装"

  s.homepage     = "https://github.com/fanxiaocong/XCDropdownMenu"

  s.license      = "MIT"


  s.author       = { "樊小聪" => "1016697223@qq.com" }


  s.source       = { :git => "https://github.com/fanxiaocong/XCDropdownMenu.git", :tag => s.version }


  s.source_files  = "XCDropdownMenu"
  s.requires_arc = true

   s.platform     = :ios, "8.0"
  s.frameworks   =  'UIKit'

end
