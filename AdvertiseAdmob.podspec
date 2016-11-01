#
# Be sure to run `pod lib lint AdvertiseAdmob.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AdvertiseAdmob'
  s.version          = '0.1.8'
  s.summary          = 'AdvertiseAdmob'
  s.description      = <<-DESC
AdvertiseAdmob.
                       DESC
  s.homepage         = 'https://github.com/ietstudio/AdvertiseAdmob'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gaoyang' => 'gaoyang@joycastle.mobi' }
  s.source           = { :git => 'https://github.com/ietstudio/AdvertiseAdmob.git', :tag => s.version.to_s }
  s.ios.deployment_target = '7.0'
  s.default_subspecs = 'Core'
  s.subspec 'Core' do |cs|
  	cs.source_files = 'AdvertiseAdmob/Classes/**/*'
  	cs.dependency 'GamePluginBase'
  	cs.dependency 'Firebase/Core'
  	cs.dependency 'Firebase/AdMob'
  end
  s.subspec 'AdapterUnityAds' do |aua|
    aua.dependency 'AdvertiseAdmob/Core'
  	aua.vendored_libraries = 'AdvertiseAdmob/Mediation/LibAdapterUnity-1.0.1/libAdapterUnity.a'
    aua.frameworks = 'AVFoundation', 'CoreMedia', 'SystemConfiguration'
  	aua.dependency 'UnityAds', '~> 1.5.6'
  end
  s.subspec 'AdapterChartBoost' do |acb|
    acb.dependency 'AdvertiseAdmob/Core'
  	acb.source_files = 'AdvertiseAdmob/Mediation/LibAdapterChartboost-1.1.0/*'
  	acb.vendored_libraries = 'AdvertiseAdmob/Mediation/LibAdapterChartboost-1.1.0/libAdapterChartboostAds.a'
  	acb.dependency 'ChartboostSDK', '~> 6.4.4'
  end
  s.subspec 'AdapterAdcolony' do |aac|
    aac.dependency 'AdvertiseAdmob/Core'
  	aac.source_files = 'AdvertiseAdmob/Mediation/AdColonyAdapter1.5/*.h'
  	aac.vendored_libraries = 'AdvertiseAdmob/Mediation/AdColonyAdapter1.5/libAdapterSDKAdColony.a'
  	aac.dependency 'AdColony', '~> 2.6.1'
  end
  s.subspec 'AdapterVungle' do |avg|
    avg.dependency 'AdvertiseAdmob/Core'
  	avg.vendored_libraries = 'AdvertiseAdmob/Mediation/VungleAdMobiOS-1.2.0/libVungleAdapter.a'
  	avg.dependency 'VungleSDK-iOS', '~> 3.2.0.1'
  end
  s.subspec 'AdapterInmobi' do |aim|
    aim.dependency 'AdvertiseAdmob/Core'
    aim.vendored_libraries = 'AdvertiseAdmob/Mediation/AdMobMediation_Adapter_InMobi_iOS_531/libAdapterInMobi.a'
    aim.source_files = 'AdvertiseAdmob/Mediation/AdMobMediation_Adapter_InMobi_iOS_531/*.h'
    aim.dependency 'InMobiSDK', '~> 5.3.1'
  end
end


