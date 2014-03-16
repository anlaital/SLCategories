Pod::Spec.new do |s|
  s.name     = 'SLFramework'
  s.version  = '0.0.1'
  s.license  = 'MIT'
  s.summary  = 'Framework for boosting iOS application development.'
  s.homepage = 'https://github.com/anlaital/SLFramework'
  s.social_media_url = 'https://twitter.com/anlaital'
  s.authors  = { 'Antti Laitala' => 'antti.o.laitala@gmail.com' }
  s.source   = { :git => 'https://github.com/anlaital/SLFramework.git', :submodules => false, :tag => '0.0.1' }
  s.requires_arc = true

  s.ios.deployment_target = '6.0'

  s.public_header_files = 'SLFramework/*.h'
  s.source_files = 'SLFramework/*.m'
end