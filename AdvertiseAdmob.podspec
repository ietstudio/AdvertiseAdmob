#
# Be sure to run `pod lib lint AdvertiseAdmob.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AdvertiseAdmob'
  s.version          = '0.2.5'
  s.summary          = 'AdvertiseAdmob'
  s.description      = <<-DESC
AdvertiseAdmob.
                       DESC
  s.homepage         = 'https://github.com/ietstudio/AdvertiseAdmob'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gaoyang' => 'gaoyang@joycastle.mobi' }
  s.source           = { :git => 'https://github.com/ietstudio/AdvertiseAdmob.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.default_subspecs = 'Core'
  s.subspec 'Core' do |cs|
  	cs.source_files = 'AdvertiseAdmob/Classes/**/*'
  	cs.dependency 'GamePluginBase'
  	cs.dependency 'Google-Mobile-Ads-SDK', '~> 7.31.0'
  end
  s.subspec 'AdapterChartBoost' do |acb|
    acb.dependency 'AdvertiseAdmob/Core'
    acb.dependency 'GoogleMobileAdsMediationChartboost', '~> 7.2.0.0'
  end
  s.subspec 'AdapterVungle' do |avg|
    avg.dependency 'AdvertiseAdmob/Core'
  	avg.dependency 'GoogleMobileAdsMediationVungle', '~> 6.2.0.2'
    avg.source_files = 'AdvertiseAdmob/Mediation/Vungle/**/*'
  end
  s.subspec 'AdapterAppLovin' do |aal|
    aal.dependency 'AdvertiseAdmob/Core'
    aal.dependency 'GoogleMobileAdsMediationAppLovin', '~> 5.0.1.0'
  end
  s.subspec 'AdapterFacebook' do |afb|
    afb.dependency 'AdvertiseAdmob/Core'
    afb.dependency 'GoogleMobileAdsMediationFacebook', '~> 4.28.1.1'
  end
end


