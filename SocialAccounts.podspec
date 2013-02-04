Pod::Spec.new do |s|
  s.name     = 'SocialAccounts'
  s.version  = '0.0.1'
  s.license  = 'Apache 2.0'
  s.summary  = 'SocialAccounts is an iOS framework that provides an easy way to manage social network accounts'
  s.homepage = 'https://github.com/aporat/SocialAccounts.git'
  s.author   = { 'Adar Porat' => 'adar.porat@gmail.com' }
  s.source   = { :git => 'https://github.com/aporat/SocialAccounts.git' }
  s.platform = :ios
  s.source_files = 'src/*.{h,m}'
  s.clean_paths = "Classes", "*.{plist,pch,md,m,xcodeproj}", "SampleApp"
  s.frameworks = 'QuartzCore', 'AudioToolbox', 'Security'
  s.requires_arc = true
end
