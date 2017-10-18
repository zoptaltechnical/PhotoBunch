//
//  GroupsViewController.h
//  PhotoBunch
//
//  Created by Gorav Grover on 30/05/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYWebImage.h"
#import "UIImageView+WebCache.h"
#import "KSSDImageManager.h"
#import "KSPhotoBrowser.h"
#import "KSPhotoBrowser.h"
#import "Constant.h"
#import "YBPopupMenu.h"

@interface GroupsViewController : UIViewController<KSPhotoBrowserDelegate,YBPopupMenuDelegate>
{
    
    
}

@property (nonatomic, assign) KSPhotoBrowserInteractiveDismissalStyle dismissalStyle;
@property (nonatomic, assign) KSPhotoBrowserBackgroundStyle backgroundStyle;
@property (nonatomic, assign) KSPhotoBrowserPageIndicatorStyle pageindicatorStyle;
@property (nonatomic, assign) KSPhotoBrowserImageLoadingStyle loadingStyle;
@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, assign) KSImageManagerType imageManagerType;

@end
