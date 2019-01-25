Pod::Spec.new do |s|
  s.name             = 'HXConvenientListView'
  s.version          = '0.0.6'
  s.summary          = '简化使用列表对象时的代码书写量,例如数据源配置、事件回调'

  s.homepage         = 'https://gitee.com/huanxiong'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dahuanxiong' => 'xinlixuezyj@163.com' }
  s.source           = { :git => 'https://github.com/yiyucanglang/HXConvenientListView.git', :tag => s.version }

  s.ios.deployment_target = '8.0'

  s.default_subspec = 'List'

  s.subspec 'Core' do |core|
    core.source_files = '*.{h,m}'
    core.exclude_files = 'HXBaseConvenientTableViewCell.{h,m}', 'HXBaseConvenientHeaderFooterView.{h,m}', 'HXBaseConvenientCollectionViewCell.{h,m}', 'HXBaseConvenientCollectionReusableView.{h,m}'
    core.dependency 'Masonry'
  end

  s.subspec 'List' do |list|
    list.source_files = 'HXBaseConvenientTableViewCell.{h,m}', 'HXBaseConvenientHeaderFooterView.{h,m}', 'HXBaseConvenientCollectionViewCell.{h,m}', 'HXBaseConvenientCollectionReusableView.{h,m}'
    list.dependency 'HXConvenientListView/Core'
  end

end
