//
//  VungleMediationHelper.m
//  Pods
//
//  Created by 高杨 on 12/01/2018.
//

#import "VungleMediationHelper.h"
#import <GoogleMobileAdsMediationVungle/VungleAdapter/VungleAdapter.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <VungleSDK/VungleSDK.h>
#import "IOSSystemUtil.h"
#import "AMAdvertiseHelper.h"

@implementation VungleMediationHelper

SINGLETON_DEFINITION(VungleMediationHelper)

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString* appId = [[IOSSystemUtil getInstance] getConfigValueWithKey:Vungle_AppId];
    NSString* spotId = [[IOSSystemUtil getInstance] getConfigValueWithKey:Vungle_SpotId];
    NSString* videoId = [[IOSSystemUtil getInstance] getConfigValueWithKey:Vungle_VedioId];
    [[VungleSDK sharedSDK] startWithAppId:appId placements:@[spotId, videoId] error:nil];
    
    VungleAdNetworkExtras *extras = [[VungleAdNetworkExtras alloc] init];
    extras.allPlacements = @[spotId, videoId];
    [[AMAdvertiseHelper getInstance] setVungleExtras:extras];
    
    return YES;
}

@end
