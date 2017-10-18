//
//  GroupMediaViewController.h
//  PhotoBunch
//
//  Created by Gorav Grover on 28/06/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "YBPopupMenu.h"
#import "DropDownListView.h"



@protocol joinGroupDelegate <NSObject>


-(void)joinGroupNotification;
-(void)delGroup;

@end


@interface GroupMediaViewController : UIViewController<YBPopupMenuDelegate,kDropDownListViewDelegate>

@property (nonatomic, weak) id<joinGroupDelegate> delegate;

@property(strong,nonatomic)NSString*groupID;
@property(strong,nonatomic)NSString*PopUpStringID;

@end
