Pod::Spec.new do |s|
  s.name             = 'PTDB'
  s.version          = '0.0.3'
  s.summary          = '数据库，核心基于FMDB，以对象方式来直接操作数据库，简略了数据库的操作，开发者只需要关心数据的存取，不必为数据存储的分配担心.'

  s.description      = <<-DESC
非常简单的一个数据库操作工具
                       DESC

  s.homepage         = 'https://github.com/JLGB'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'JLBG' => '513466979@qq.com' }
  s.source           = { :git => 'https://github.com/JLGB/PTDB.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = "DBTest/PTDB/*.{h,m}"
  s.frameworks = 'Foundation'
  s.dependency  "FMDB"
end
