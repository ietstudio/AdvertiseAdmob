//
//  VungleMediationHelper.h
//  Pods
//
//  Created by 高杨 on 12/01/2018.
//

#import <Foundation/Foundation.h>
#import "Macros.h"

#define Vungle_AppId        @"Vungle_AppId"
#define Vungle_SpotId       @"Vungle_SpotId"
#define Vungle_VedioId      @"Vungle_VedioId"

@interface VungleMediationHelper : NSObject <UIApplicationDelegate>

SINGLETON_DECLARE(VungleMediationHelper)

@end
