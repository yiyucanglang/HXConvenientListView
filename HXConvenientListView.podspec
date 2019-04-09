Pod::Spec.new do |s|
  s.name             = 'HXConvenientListView'
  s.version          = '1.0.0'
  s.summary          = '简化使用列表对象时的代码书写量,例如数据源配置、事件回调'

  s.homepage         = 'https://gitee.com/huanxiong'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dahuanxiong' => 'xinlixuezyj@163.com' }
  s.source           = { :git => 'https://github.com/yiyucanglang/HXConvenientListView.git', :tag => s.version }

  s.static_framework = true
  s.ios.deployment_target = '8.0'

  s.subspec 'Core' do |core|
    core.public_header_files = 'Core/*{h}'
    core.source_files = 'Core/*.{h,m}'
    core.dependency 'Masonry'
  end

  s.subspec 'List' do |list|
    list.public_header_files = 'List/*{h}'
    list.source_files = 'List/*.{h,m}'
    list.dependency 'HXConvenientListView/Core'
  end

end
