//
//  AMAdvertiseHelper.h
//  Pods
//
//  Created by geekgy on 15/10/23.
//
//

#import <Foundation/Foundation.h>
#import "AdvertiseDelegate.h"
#import "Macros.h"

#define Admob_Name          @"Admob"
#define Admob_BannerId      @"Admob_BannerId"
#define Admob_SpotId        @"Admob_SpotId"
#define Admob_VedioId       @"Admob_VedioId"
#define Admob_TestDevice    @"Admob_TestDevice"

@interface AMAdvertiseHelper : NSObject <AdvertiseDelegate>

SINGLETON_DECLARE(AMAdvertiseHelper)

@end