Pod::Spec.new do |s|
  s.name             = 'HXConvenientListView'
  s.version          = '0.0.1'
  s.summary          = '简化使用列表对象时的代码量书写,例如数据源配置、事件回调'

  s.homepage         = 'https://gitee.com/huanxiong'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dahuanxiong' => 'xinlixuezyj@163.com' }
  s.source           = { :git => 'https://github.com/yiyucanglang/HXConvenientListView.git', :tag => s.version }


  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = 'HXConvenientListView/*.{h,m}'
    core.exclude_files = 'SDWebImage/UIImage+WebP.{h,m}', 'SDWebImage/SDWebImageWebPCoder.{h,m}'
    core.tvos.exclude_files = 'SDWebImage/MKAnnotationView+WebCache.*'
  end


  s.ios.deployment_target = '8.0'
  s.dependency 'Masonry'
  s.public_header_files = '*{h}'
  s.source_files = '*.{h,m}'
 end
