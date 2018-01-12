//
//  AMAdvertiseHelper.m
//  Pods
//
//  Created by geekgy on 15/10/23.
//
//

#import "AMAdvertiseHelper.h"
#import "IOSSystemUtil.h"

@interface AMAdvertiseHelper() <GADInterstitialDelegate, GADRewardBasedVideoAdDelegate>

@end

@implementation AMAdvertiseHelper
{
    NSString* _admobSpotId;
    NSString* _admobBannerId;
    NSString* _admobVedioId;
    NSString* _admobTestDevice;
    GADBannerView* _bannerView;
    GADInterstitial* _interstitial;
    void(^_spotFunc)(BOOL);
    BOOL _spotTouched;
    void(^_videoViewFunc)(BOOL);
    void(^_videoClickFunc)(BOOL);
    BOOL _videoViewed;
    BOOL _videoClicked;
}

SINGLETON_DEFINITION(AMAdvertiseHelper)

- (void)preloadSpotAd {
    _interstitial = [[GADInterstitial alloc] initWithAdUnitID:_admobSpotId];
    _interstitial.delegate = self;
    GADRequest* request = [GADRequest request];
    request.testDevices = @[_admobTestDevice];
    // vungle
    if (self.vungleExtras) {
        [request registerAdNetworkExtras:self.vungleExtras];
    }
    [_interstitial loadRequest:request];
}

- (void)preloadVedioAd {
    [GADRewardBasedVideoAd sharedInstance].delegate = self;
    GADRequest* request = [GADRequest request];
    request.testDevices = @[_admobTestDevice];
    // vungle
    if (self.vungleExtras) {
        [request registerAdNetworkExtras:self.vungleExtras];
    }
    [[GADRewardBasedVideoAd sharedInstance] loadRequest:request withAdUnitID:_admobVedioId];
}

#pragma mark - AdvertiseDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
    _admobBannerId   = [[IOSSystemUtil getInstance] getConfigValueWithKey:Admob_BannerId];
    _admobSpotId     = [[IOSSystemUtil getInstance] getConfigValueWithKey:Admob_SpotId];
    _admobVedioId    = [[IOSSystemUtil getInstance] getConfigValueWithKey:Admob_VedioId];
    _admobTestDevice = [[IOSSystemUtil getInstance] getConfigValueWithKey:Admob_TestDevice];
    
    // vungle init
    [[NSClassFromString(@"VungleMediationHelper") getInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    // preload spot ad
    if (_admobSpotId) {
        [self preloadSpotAd];
    }
    
    // preload vedio ad
    if (_admobVedioId) {
        [self preloadVedioAd];
    }
    return YES;
}

- (int)showBannerAd:(BOOL)portrait :(BOOL)bottom {
    if (!_bannerView) {
        UIView* view = [IOSSystemUtil getInstance].controller.view;
        GADAdSize adSize = kGADAdSizeSmartBannerLandscape;
        if (portrait) {// 竖屏
            adSize = kGADAdSizeSmartBannerPortrait;
        }
        float x = (view.frame.size.width - CGSizeFromGADAdSize(adSize).width)/2;
        float y = 0;
        if (bottom) {// 屏幕底部
            y = view.frame.size.height - CGSizeFromGADAdSize(adSize).height;
        }
        CGPoint origin = CGPointMake(x, y);
        _bannerView = [[GADBannerView alloc] initWithAdSize:adSize origin:origin];
        _bannerView.adUnitID = _admobBannerId;
        _bannerView.rootViewController = [IOSSystemUtil getInstance].controller;
        [view addSubview:_bannerView];
        GADRequest* request = [GADRequest request];
        request.testDevices = @[_admobTestDevice];
        [_bannerView loadRequest:request];
    }
    _bannerView.hidden = NO;
    return _bannerView.adSize.size.height;
}

- (void)hideBannerAd {
    _bannerView.hidden = YES;
}

- (BOOL)showSpotAd:(void (^)(BOOL))func {
    if ([_interstitial isReady]) {
        UIViewController* controller = [[IOSSystemUtil getInstance] controller];
        [_interstitial presentFromRootViewController:controller];
        _spotTouched = NO;
        _spotFunc = func;
        return YES;
    }
    return NO;
}

- (BOOL)isVedioAdReady {
    return [[GADRewardBasedVideoAd sharedInstance] isReady];
}

- (BOOL)showVedioAd:(void (^)(BOOL))viewFunc :(void (^)(BOOL))clickFunc {
    if (![self isVedioAdReady]) {
        return NO;
    }
    _videoViewed = NO;
    _videoClicked = NO;
    _videoViewFunc = viewFunc;
    _videoClickFunc = clickFunc;
    UIViewController* controller = [IOSSystemUtil getInstance].controller;
    [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:controller];
    return YES;
}

- (NSString *)getName {
    return Admob_Name;
}

#pragma mark - GADInterstitialDelegate

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"interstitial:didFailToReceiveAdWithError: %@", error);
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, ADVERTISE_RETRY_INTERVAL*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self preloadSpotAd];
    });
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    _spotTouched = YES;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    _spotFunc(_spotTouched);
    [self preloadSpotAd];
}

#pragma mark - GADRewardBasedVideoAdDelegate

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"rewardBasedVideoAdDidReceiveAd");
}

- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"rewardBasedVideoAdDidOpen");
}

- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"rewardBasedVideoAdDidStartPlaying");
}

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"rewardBasedVideoAdDidClose");
    _videoViewFunc(_videoViewed);
    _videoClickFunc(_videoClicked);
    [self preloadVedioAd];
}

- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"rewardBasedVideoAdWillLeaveApplication");
    _videoClicked = YES;
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd didRewardUserWithReward:(GADAdReward *)reward {
    NSLog(@"rewardBasedVideoAd:didRewardUserWithReward %@:%@", reward.type, reward.amount);
    _videoViewed = YES;
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd didFailToLoadwithError:(NSError *)error {
    NSLog(@"rewardBasedVideoAd:didFailToLoadwithError: %@", error);
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, ADVERTISE_RETRY_INTERVAL*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self preloadVedioAd];
    });
}

@end
