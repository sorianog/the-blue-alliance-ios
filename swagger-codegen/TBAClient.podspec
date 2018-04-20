Pod::Spec.new do |s|
  s.name = 'TBAClient'
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.0'
  s.version = '0.0.1'
  s.source = { :git => 'git@github.com:swagger-api/swagger-mustache.git', :tag => 'v1.0.0' }
  s.authors = 'The Blue Alliance'
  s.license = 'Proprietary'
  s.homepage = 'https://thebluealliance.com'
  s.summary = 'TBAClient'
  s.source_files = 'TBAClient/Classes/**/*.swift'
  s.dependency 'Alamofire', '~> 4.5.0'
end
