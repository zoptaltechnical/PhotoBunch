//
//  Constant.h
//  Bibble
//
//  Created by Jitendra Nigam on 12/18/15.
//  Copyright © 2015 Seasia. All rights reserved.


#import "AppDelegate.h"
#import "Reachability.h"
#import "UserDefaultHandler.h"
#import "SharedParsing.h"
#import "RunOnMainThread.h"
#import "WebServiceConstant.h"
#import "SingletonClass.h"
#import "GMDCircleLoader.h"
#import "NSString+PJR.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import <CRToast/CRToast.h>
#import "ImageCompress.h"
#import "UIButton+WebCache.h"

typedef NS_ENUM(NSInteger, KSImageManagerType) {
    KSImageManagerTypeYYWebImage,
    KSImageManagerTypeSDWebImage
};
#ifdef __OBJC__
#include "UIView+Extension.h"
#import "UIColor+Tools.h"
#endif


#define rGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define rGBColor_A(r, g, b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define kDevicePlatform     @"ios"
#define kFacebookAccessToken @"fbAccessToken"
#define kNetworkAlert        @"No network available"
#define kServiceFailure      @"Something went wrong on server, Please try again later."
#define kComingSoonAlert     @"Coming Soon..."
#define kUpdateSearchResult  @"updateResult"



#define kSWidth     ([UIScreen mainScreen].bounds.size.width)
#define kSHeight    ([UIScreen mainScreen].bounds.size.height)


#define kSScale    ([UIScreen mainScreen].bounds.size.width/320.0)



#define IS_IOS7    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_IOS8    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define Appdelegate    ((AppDelegate *)[[UIApplication sharedApplication] delegate])


/**
 * THIS HELPTS US TO DEFINE THE SHARED QUEUE.
 * CALL THIS IN YOUR GCD.
 */
#define sharedQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define kServerCommunication  [ServerCommunication instance]

#define kiPhone4                     @"iPhone4"
#define kiPhone5                     @"iPhone5"
#define kServerTime                  @"server_time"

#if !(TARGET_IPHONE_SIMULATOR)

#define NSLog if (1)NSLog

#endif

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define KSharedParsing [SharedParsing sharedSharedParsing]
#define IS_IPHONE ( [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] )
#define IS_IPOD   ( [[[UIDevice currentDevice ] model] isEqualToString:@"iPod touch"] )
#define IS_SIMULATOR   ( [[[UIDevice currentDevice ] model] isEqualToString:@"iPhone Simulator"] )
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height == 568.0f
#define IS_HEIGHT_GTE_480 [[UIScreen mainScreen ] bounds].size.height == 480.0f
#define IS_HEIGHT_GTE_667 [[UIScreen mainScreen ] bounds].size.height == 667.0f
#define IS_HEIGHT_GTE_736 [[UIScreen mainScreen ] bounds].size.height == 736.0f

#define IS_IPHONE_5 ( (IS_SIMULATOR || IS_IPHONE) && IS_HEIGHT_GTE_568 )
#define IS_IPHONE_4 ( (IS_SIMULATOR|| IS_IPHONE) && IS_HEIGHT_GTE_480 )
#define IS_IPHONE_6 ( (IS_SIMULATOR || IS_IPHONE) && IS_HEIGHT_GTE_667 )
#define IS_IPHONE_6_PLUS ( (IS_SIMULATOR|| IS_IPHONE) && IS_HEIGHT_GTE_736 )


#define UI_USER_INTERFACE_IDIOM() ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] ? [[UIDevice currentDevice] userInterfaceIdiom] : UIUserInterfaceIdiomPhone)



#define  kBorderColor   [UIColor lightGrayColor];
#define  kBlueColor @"276efa"
#define  kLightGreyColor @"b1b2b7"
#define  kBlackColor @"18191b"
#define WorkSans_Light(s) [UIFont fontWithName:@"WorkSans-Light" size:s]
#define WorkSans_Regular(s) [UIFont fontWithName:@"WorkSans-Regular" size:s]
#define WorkSans_Bold(s) [UIFont fontWithName:@"WorkSans-Bold" size:s]
#define WorkSans_SemiBold(s) [UIFont fontWithName:@"WorkSans-SemiBold" size:s]
#define WorkSans_Medium(s) [UIFont fontWithName:@"WorkSans-Medium" size:s]

# define KAppdelegate  ((AppDelegate*) [[UIApplication sharedApplication] delegate])

#define KUserDefault   [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]
#define kTotalRecord 15.0


