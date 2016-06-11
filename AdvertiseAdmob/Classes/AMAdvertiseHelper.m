//
//  AMAdvertiseHelper.m
//  Pods
//
//  Created by geekgy on 15/10/23.
//
//

#import "AMAdvertiseHelper.h"
#import "IOSSystemUtil.h"

#import <GoogleMobileAds/GoogleMobileAds.h>

@interface AMAdvertiseHelper() <GADInterstitialDelegate, GADRewardBasedVideoAdDelegate>

@end

@implementation AMAdvertiseHelper
{
    NSString* _admobSpotId;
    NSString* _admobBannerId;
    NSString* _admobVedioId;
    NSString* _admobTestDevice;
    GADInterstitial* _interstitial;
    GADBannerView* _bannerView;
    //
    void(^_spotFunc)(BOOL);
    BOOL spotTouched;
    void(^_viewFunc)(BOOL);
    void(^_clickFunc)(BOOL);
}

SINGLETON_DEFINITION(AMAdvertiseHelper)

- (void)preloadSpotAd {
    _interstitial = [[GADInterstitial alloc] initWithAdUnitID:_admobSpotId];
    _interstitial.delegate = self;
    GADRequest* request = [GADRequest request];
    request.testDevices = @[_admobTestDevice];
    [_interstitial loadRequest:request];
}

- (void)preloadVedioAd {
    GADRequest* request = [GADRequest request];
    request.testDevices = @[_admobTestDevice];
    [GADRewardBasedVideoAd sharedInstance].delegate = self;
    [[GADRewardBasedVideoAd sharedInstance] loadRequest:request
                                           withAdUnitID:_admobVedioId];
}

#pragma mark - AdvertiseDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
    _admobBannerId   = [[IOSSystemUtil getInstance] getConfigValueWithKey:Admob_BannerId];
    _admobSpotId     = [[IOSSystemUtil getInstance] getConfigValueWithKey:Admob_SpotId];
    _admobVedioId    = [[IOSSystemUtil getInstance] getConfigValueWithKey:Admob_VedioId];
    _admobTestDevice = [[IOSSystemUtil getInstance] getConfigValueWithKey:Admob_TestDevice];
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
        float y = 0;
        if (bottom) {// 屏幕底部
            y = view.frame.size.height - CGSizeFromGADAdSize(adSize).height;
        }
        CGPoint origin = CGPointMake(0, y);
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

- (void)hideBanner {
    _bannerView.hidden = YES;
}

- (BOOL)showSpotAd:(void (^)(BOOL))func {
    if ([_interstitial isReady]) {
        UIViewController* controller = [[IOSSystemUtil getInstance] controller];
        [_interstitial presentFromRootViewController:controller];
        spotTouched = NO;
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
    _viewFunc = viewFunc;
    _clickFunc = clickFunc;
    UIViewController* controller = [IOSSystemUtil getInstance].controller;
    [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:controller];
    return YES;
}

- (NSString *)getName {
    return Admob_Name;
}

#pragma mark - GADInterstitialDelegate

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"interstitial:didFailToReceiveAdWithError");
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10*NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self preloadSpotAd];
    });
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    spotTouched = YES;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    _spotFunc(spotTouched);
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
    [self preloadVedioAd];
}

- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"rewardBasedVideoAdWillLeaveApplication");
    
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward {
    NSLog(@"rewardBasedVideoAd:didRewardUserWithReward %@:%@", reward.type, reward.amount);
    
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadwithError:(NSError *)error {
    NSLog(@"rewardBasedVideoAd:didFailToLoadwithError:");
    [self preloadVedioAd];
}

@end
