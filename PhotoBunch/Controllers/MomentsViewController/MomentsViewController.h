//
//  MomentsViewController.h
//  PhotoBunch
//
//  Created by Gorav Grover on 29/05/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import "Constant.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"

#import "YYWebImage.h"
#import "UIImageView+WebCache.h"
#import "KSSDImageManager.h"
#import "KSPhotoBrowser.h"
#import "KSPhotoBrowser.h"
@interface MomentsViewController : UIViewController<KSPhotoBrowserDelegate>
-(void)callGetAllFriendsPosts;
@property (nonatomic, assign) KSPhotoBrowserInteractiveDismissalStyle dismissalStyle;
@property (nonatomic, assign) KSPhotoBrowserBackgroundStyle backgroundStyle;
@property (nonatomic, assign) KSPhotoBrowserPageIndicatorStyle pageindicatorStyle;
@property (nonatomic, assign) KSPhotoBrowserImageLoadingStyle loadingStyle;
@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, assign) KSImageManagerType imageManagerType;

@end
