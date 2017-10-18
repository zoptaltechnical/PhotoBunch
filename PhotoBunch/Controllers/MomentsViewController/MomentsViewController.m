//
//  MomentsViewController.m
//  PhotoBunch
//
//  Created by Gorav Grover on 29/05/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import "MomentsViewController.h"
#import "groupsCell.h"
#import "Constant.h"
#import "groupInCellCell.h"
#import "FriendsCell.h"
#import "groupsTableCell.h"
#import "JoinGroupControllerViewController.h"
#import "PostDetailsViewController.h"
#import "FriendsProfileViewController.h"
#import "NotificationsViewController.h"
#import "NSDate+NVTimeAgo.h"
#import "ASMediaFocusManager.h"
#import "GroupMediaViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "friendsPostNewCell.h"
@import AVFoundation;
@import AVKit;

@interface MomentsViewController ()<ASMediasFocusDelegate,AVPlayerViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *MainTableView;
@property (strong, nonatomic) IBOutlet UIButton *groupBtn;

@property (strong, nonatomic) IBOutlet UIButton *friendsBtn;
@property (strong, nonatomic) IBOutlet UIImageView *alertImage;

@property (strong, nonatomic) ASMediaFocusManager *mediaFocusManager;
@property(assign)BOOL isGroupSelected;

@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;


@property (nonatomic, strong) NSArray *friendsPost;
@property (nonatomic, strong) NSMutableDictionary *friendsPostDict;

@end

@implementation MomentsViewController
{
    NSMutableArray*groupsArray,*groupIcons;
    NSMutableArray*friendsArray,*friendsIcons,*sampleCollectionIcons;
    NSMutableArray*groupWallPosts,*friendsWallPosts;
    BOOL isReload;
    AVPlayerViewController *playerViewController;
    
    NSMutableArray*sliderAllArray;


}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_alertImage setHidden:YES];
    [_MainTableView setHidden:NO];

    groupWallPosts=[[NSMutableArray alloc]init];
    friendsWallPosts=[[NSMutableArray alloc]init];
    groupsArray=[[NSMutableArray alloc]init];
    groupIcons=[[NSMutableArray alloc]init];
    friendsArray=[[NSMutableArray alloc]init];
    friendsIcons=[[NSMutableArray alloc]init];
    sampleCollectionIcons=[[NSMutableArray alloc]init];
    sliderAllArray=[[NSMutableArray alloc]init];
    _isGroupSelected=YES;
    
    
//    self.mediaFocusManager = [[ASMediaFocusManager alloc] init];
//    self.mediaFocusManager.delegate = self;
//    self.mediaFocusManager.elasticAnimation = YES;
//    self.mediaFocusManager.focusOnPinch = YES;
//
    isReload=YES;
    [self callGetProfile];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerViewController];

    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    if (isReload==YES)
    {
        [_alertImage setHidden:YES];
        [_MainTableView setHidden:NO];
        if ([KAppdelegate.notificationType isEqualToString:@"friend_new_post"])
        {
            [self friendsBtnPressed:_friendsBtn];
            KAppdelegate.notificationType=@"NoNotification";

        }
        else
        {
            [self callGetAllGroupPosts];

        }
        
        
    }
    isReload=YES;

}
-(void)callGetProfile
{
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken]
                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        
        [KSharedParsing wsCallToGetUserProfile:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    [UserDefaultHandler setFullUserInfoInfo:[resultArray valueForKey:@"data"]];
                    
                }
                else
                {
                    
                }
            }];
            
        } failureBlock:^(BOOL succeeded, NSArray *failureArray)
         {
             
             [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                 
             }];
             
             
         }];
    }
    else
    {
        
    }
    
    
}



#pragma mark- Service Calls

-(void)callGetAllFriendsPosts
{
    NSDate*date=[NSDate date];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDateFormatter *dateFormatterNew = [[NSDateFormatter alloc] init];
    [dateFormatterNew setLocale:enUSPOSIXLocale];
    [dateFormatterNew setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *stringForNewDate =[dateFormatterNew stringFromDate:date];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"page":@"1",
                                   @"limit":@"250",
                                   @"device_time":stringForNewDate

                                   };
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallToGetFriendsWallPosts:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    
                    friendsWallPosts=[resultArray valueForKey:@"data"];
                    
                    const NSInteger numberOfTableViewRows = [friendsWallPosts  count];
                    
                    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:numberOfTableViewRows];
                    
                    for (NSInteger tableViewRow = 0; tableViewRow < numberOfTableViewRows; tableViewRow++)
                    {
                        NSMutableArray *colorArray = [NSMutableArray arrayWithCapacity:[[[friendsWallPosts objectAtIndex:tableViewRow]valueForKey:@"posts"] count]];
                        NSMutableArray *sliderUrlsArray = [NSMutableArray arrayWithCapacity:[[[friendsWallPosts objectAtIndex:tableViewRow]valueForKey:@"posts"] count]];
                        for (NSInteger collectionViewItem = 0; collectionViewItem < [[[friendsWallPosts objectAtIndex:tableViewRow]valueForKey:@"posts"] count]; collectionViewItem++)
                        {
                            [colorArray addObject:[[[friendsWallPosts objectAtIndex:tableViewRow]valueForKey:@"posts"] objectAtIndex:collectionViewItem]];
                            [sliderUrlsArray addObject:[[[friendsWallPosts objectAtIndex:tableViewRow]valueForKey:@"posts"] objectAtIndex:collectionViewItem]];
                            
                            
                        }
                        
                        [mutableArray addObject:colorArray];
                    }
                    
                    self.friendsPost = [NSArray arrayWithArray:mutableArray];
                    self.friendsPostDict = [NSMutableDictionary dictionary];
                    
                    
                    
                    [_alertImage setHidden:YES];
                    [_MainTableView setHidden:NO];
//
//                    friendsWallPosts=[resultArray valueForKey:@"data"];
                    [_MainTableView reloadData];
                }
                else
                {
                    if ([[resultArray valueForKey:@"code"] integerValue]==201 )
                    {
                        [_alertImage setHidden:NO];
                        [_MainTableView setHidden:YES];
                        
                    }
                    else
                    {
                        NSDictionary *options = @{
                                                  kCRToastTextKey : kServiceFailure,
                                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                                  kCRToastBackgroundColorKey : [UIColor redColor],
                                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                                  };
                        [CRToastManager showNotificationWithOptions:options
                                                    completionBlock:^{
                                                        NSLog(@"Completed");
                                                    }];
                    }

                    
                }
            }];
            
        } failureBlock:^(BOOL succeeded, NSArray *failureArray)
         {
             
             [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                 
                 [KAppdelegate stopLoader:self.view];
                 NSDictionary *options = @{
                                           kCRToastTextKey : kServiceFailure,
                                           kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                           kCRToastBackgroundColorKey : [UIColor redColor],
                                           kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                           kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                           kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                           kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                           };
                 [CRToastManager showNotificationWithOptions:options
                                             completionBlock:^{
                                                 NSLog(@"Completed");
                                             }];

                 
                 
             }];
             
             
         }];
    }
    else
    {
        NSDictionary *options = @{
                                  kCRToastTextKey : kNetworkAlert,
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey : [UIColor redColor],
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                  };
        [CRToastManager showNotificationWithOptions:options
                                    completionBlock:^{
                                        NSLog(@"Completed");
                                    }];

    }
    
    
}


-(void)callGetAllGroupPosts
{
    //access_token

    NSDate*date=[NSDate date];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDateFormatter *dateFormatterNew = [[NSDateFormatter alloc] init];
    [dateFormatterNew setLocale:enUSPOSIXLocale];
    [dateFormatterNew setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *stringForNewDate =[dateFormatterNew stringFromDate:date];
    
    NSDictionary* registerInfo = @{
                                    @"access_token":[UserDefaultHandler getUserAccessToken],
                                    @"page":@"1",
                                    @"limit":@"250",
                                    @"device_time":stringForNewDate

                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallToGetGroupWallPosts:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
              
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    [_alertImage setHidden:YES];
                    [_MainTableView setHidden:NO];

                    groupWallPosts=[resultArray valueForKey:@"data"];
                    NSLog(@"groups all posts= %@",groupWallPosts);
                    const NSInteger numberOfTableViewRows = [groupWallPosts  count];
                    
                    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:numberOfTableViewRows];
                    
                    for (NSInteger tableViewRow = 0; tableViewRow < numberOfTableViewRows; tableViewRow++)
                    {
                        NSMutableArray *colorArray = [NSMutableArray arrayWithCapacity:[[[groupWallPosts objectAtIndex:tableViewRow]valueForKey:@"group_posts"] count]];
                         NSMutableArray *sliderUrlsArray = [NSMutableArray arrayWithCapacity:[[[groupWallPosts objectAtIndex:tableViewRow]valueForKey:@"group_posts"] count]];
                        for (NSInteger collectionViewItem = 0; collectionViewItem < [[[groupWallPosts objectAtIndex:tableViewRow]valueForKey:@"group_posts"] count]; collectionViewItem++)
                        {
                            [colorArray addObject:[[[groupWallPosts objectAtIndex:tableViewRow]valueForKey:@"group_posts"] objectAtIndex:collectionViewItem]];
                            [sliderUrlsArray addObject:[[[groupWallPosts objectAtIndex:tableViewRow]valueForKey:@"group_posts"] objectAtIndex:collectionViewItem]];
                            
                            
                        }
                        
                        [mutableArray addObject:colorArray];
                    }
                    
                    self.colorArray = [NSArray arrayWithArray:mutableArray];
                    self.contentOffsetDictionary = [NSMutableDictionary dictionary];

                    [_MainTableView reloadData];
                    
                }
                else
                {
                        [_alertImage setHidden:NO];
                        [_MainTableView setHidden:YES];
                        
                }
            }];
            
        } failureBlock:^(BOOL succeeded, NSArray *failureArray)
         {
             
             [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                 
                 [KAppdelegate stopLoader:self.view];
                 
                 NSDictionary *options = @{
                                           kCRToastTextKey : kServiceFailure,
                                           kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                           kCRToastBackgroundColorKey : [UIColor redColor],
                                           kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                           kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                           kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                           kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                           };
                 [CRToastManager showNotificationWithOptions:options
                                             completionBlock:^{
                                                 NSLog(@"Completed");
                                             }];

                 
             }];
             
             
         }];
    }
    else
    {
        NSDictionary *options = @{
                                  kCRToastTextKey : kNetworkAlert,
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey : [UIColor redColor],
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                  };
        [CRToastManager showNotificationWithOptions:options
                                    completionBlock:^{
                                        NSLog(@"Completed");
                                    }];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)groupsBtnPressed:(id)sender
{
    [_alertImage setHidden:YES];
    [_MainTableView setHidden:YES];

    [self callGetAllGroupPosts];
    
    _isGroupSelected=YES;
    
    [_groupBtn setBackgroundColor:rGBColor(21, 165, 230)];
    [_groupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_friendsBtn setBackgroundColor:rGBColor(235,239,242)];
    [_friendsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    //[_MainTableView reloadData];

    
}
- (IBAction)friendsBtnPressed:(id)sender
{

    [_alertImage setHidden:YES];
    [_MainTableView setHidden:YES];
    _isGroupSelected=NO;
    [_friendsBtn setBackgroundColor:rGBColor(21, 165, 230)];
    [_friendsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [_groupBtn setBackgroundColor:rGBColor(235,239,242)];
    [_groupBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self callGetAllFriendsPosts];

    
}

#pragma mark
#pragma mark- CollectionView
#pragma mark

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_isGroupSelected)
    {
        NSArray *collectionViewArray = self.colorArray[[(GroupsPostsCollectionView *)collectionView indexPath].row];
        return collectionViewArray.count;
    }
    else
    {
        NSArray *collectionViewArray = self.friendsPost[[(friendsPostsCollectionView *)collectionView indexPath].row];
        return collectionViewArray.count;
    }
   
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (_isGroupSelected)
    {
        groupInCellCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"groupInCellCellID" forIndexPath:indexPath];
        
        NSArray *collectionViewArray = self.colorArray[[(GroupsPostsCollectionView *)collectionView indexPath].row];
        
        NSIndexPath*ip=[(GroupsPostsCollectionView1 *)collectionView indexPath];
        NSIndexPath*ip1=[NSIndexPath indexPathForRow:indexPath.row inSection:ip.row];
        
        [cell.groupInCellImage setAccessibilityIdentifier:[NSString stringWithFormat:@"%ld",(long)ip1.section]];
        [cell.groupInCellImage setTag:ip1.row];
        
        NSDictionary*dict=[collectionViewArray objectAtIndex:indexPath.row];
        if ([[dict valueForKey:@"medias"]count]>0)
        {
            if ([[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_type"]isEqualToString:@"image"])
            {
                [cell.playImage setHidden:YES];
                
                //                UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
                //                [tapRecognizer addTarget:self action:@selector(bigButtonTapped:)];
                //                [cell.groupInCellImage addGestureRecognizer:tapRecognizer];
                
                if ([[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_path"] length]>0)
                {
                    
                    [cell.groupInCellImage sd_setImageWithURL:[NSURL URLWithString:[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_thumb"]] placeholderImage:[UIImage imageNamed:@"groupSmallBack"] options:SDWebImageRefreshCached];
                    
                }
                else
                {
                    cell.groupInCellImage.image=[UIImage imageNamed:@"groupSmallBack"];
                }
                
            }
            else
            {
                
                //  [self.mediaFocusManager installOnView:cell.groupInCellImage];
                
                [cell.playImage setHidden:NO];
                //                UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
                //                tapRecognizer.accessibilityLabel=[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_path"];
                //                [tapRecognizer addTarget:self action:@selector(playVideo1:)];
                //                [cell.groupInCellImage addGestureRecognizer:tapRecognizer];
                
                if ([[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_thumb"] length]>0)
                {
                    
                    [cell.groupInCellImage sd_setImageWithURL:[NSURL URLWithString:[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_thumb"]] placeholderImage:[UIImage imageNamed:@"groupSmallBack"] options:SDWebImageRefreshCached];
                    
                }
                else
                {
                    cell.groupInCellImage.image=[UIImage imageNamed:@"groupSmallBack"];
                }
                
            }
            
        }
        else
        {
            cell.groupInCellImage.image=[UIImage imageNamed:@"groupSmallBack"];
            
        }
        
        return cell;

    }
    else
    {
        groupInCellCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"groupInCellCellID" forIndexPath:indexPath];
        
        NSArray *collectionViewArray = self.friendsPost[[(friendsPostsCollectionView *)collectionView indexPath].row];
        
        NSIndexPath*ip=[(friendsPostsCollectionView *)collectionView indexPath];
        NSIndexPath*ip1=[NSIndexPath indexPathForRow:indexPath.row inSection:ip.row];
        
        [cell.groupInCellImage setAccessibilityIdentifier:[NSString stringWithFormat:@"%ld",(long)ip1.section]];
        [cell.groupInCellImage setTag:ip1.row];
        
        NSDictionary*dict=[collectionViewArray objectAtIndex:indexPath.row];
        if ([[dict valueForKey:@"medias"]count]>0)
        {
            if ([[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_type"]isEqualToString:@"image"])
            {
                [cell.playImage setHidden:YES];
                
                //                UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
                //                [tapRecognizer addTarget:self action:@selector(bigButtonTapped:)];
                //                [cell.groupInCellImage addGestureRecognizer:tapRecognizer];
                
                if ([[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_path"] length]>0)
                {
                    
                    [cell.groupInCellImage sd_setImageWithURL:[NSURL URLWithString:[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_thumb"]] placeholderImage:[UIImage imageNamed:@"groupSmallBack"] options:SDWebImageRefreshCached];
                    
                }
                else
                {
                    cell.groupInCellImage.image=[UIImage imageNamed:@"groupSmallBack"];
                }
                
            }
            else
            {
                
                //  [self.mediaFocusManager installOnView:cell.groupInCellImage];
                
                [cell.playImage setHidden:NO];
                //                UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
                //                tapRecognizer.accessibilityLabel=[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_path"];
                //                [tapRecognizer addTarget:self action:@selector(playVideo1:)];
                //                [cell.groupInCellImage addGestureRecognizer:tapRecognizer];
                
                if ([[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_thumb"] length]>0)
                {
                    
                    [cell.groupInCellImage sd_setImageWithURL:[NSURL URLWithString:[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_thumb"]] placeholderImage:[UIImage imageNamed:@"groupSmallBack"] options:SDWebImageRefreshCached];
                    
                }
                else
                {
                    cell.groupInCellImage.image=[UIImage imageNamed:@"groupSmallBack"];
                }
                
            }
            
        }
        else
        {
            cell.groupInCellImage.image=[UIImage imageNamed:@"groupSmallBack"];
            
        }
        
        return cell;

    }
    
   
}

- (void)playVideo1:(UITapGestureRecognizer*)sender
{
//    NSURL *fileURL = [NSURL URLWithString:sender.accessibilityLabel];
//    
//    playerViewController = [[AVPlayerViewController alloc] init];
//    
//    NSURL *url = fileURL;
//    
//    AVURLAsset *asset = [AVURLAsset assetWithURL: url];
//    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset: asset];
//    
//    AVPlayer * player = [[AVPlayer alloc] initWithPlayerItem: item];
//    playerViewController.player = player;
//    [playerViewController.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
//    
//    playerViewController.view.center=self.view.center;
//    
//   // playerViewController.showsPlaybackControls = YES;
//    
//    
//    [self.view addSubview:playerViewController.view];
//    
//    [player play];
//


}
-(void)itemDidFinishPlaying:(NSNotification *) notification
{
    // Will be called when AVPlayer finishes playing playerItem

    [playerViewController.view removeFromSuperview];

}
- (void)moviePlayerPlaybackDidFinishNotification:(NSNotification*)notification
{
    
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (_isGroupSelected)
    {
        groupInCellCell* cell = (groupInCellCell*)[collectionView cellForItemAtIndexPath:indexPath];
        
        NSIndexPath*ip=[(GroupsPostsCollectionView1 *)collectionView indexPath];
        NSIndexPath*ip1=[NSIndexPath indexPathForRow:indexPath.row inSection:ip.row];
        
        NSMutableArray*urlsArray=[[NSMutableArray alloc]init];
        NSMutableArray*typesArray=[[NSMutableArray alloc]init];
        NSMutableArray*mediaPaths=[[NSMutableArray alloc]init];
        NSMutableArray*dictArray=[[NSMutableArray alloc]init];

        NSArray*sampleArray;
        sampleArray=self.colorArray;
        
        for (NSDictionary*dict in [sampleArray objectAtIndex:ip1.section])
        {
            
            KSPhotoItem *item;
            if ([[[[dict valueForKey:@"medias"] objectAtIndex:0] valueForKey:@"media_type"]isEqualToString:@"video"]) {
                item = [KSPhotoItem itemWithSourceView:cell.groupInCellImage thumbImage:[UIImage imageNamed:@"cover_picBack"] imageUrl:[NSURL URLWithString:[[[dict valueForKey:@"medias"] objectAtIndex:0] valueForKey:@"media_thumb"]]];
            }
            else
            {
                item = [KSPhotoItem itemWithSourceView:cell.groupInCellImage thumbImage:[UIImage imageNamed:@"cover_picBack"] imageUrl:[NSURL URLWithString:[[[dict valueForKey:@"medias"] objectAtIndex:0] valueForKey:@"media_path"]]];
            }
            
            
            [urlsArray addObject:item];
            [typesArray addObject:[[[dict valueForKey:@"medias"] objectAtIndex:0] valueForKey:@"media_type"]];
            [mediaPaths addObject:[[[dict valueForKey:@"medias"] objectAtIndex:0] valueForKey:@"media_path"]];
            [dictArray addObject:dict];
            
        }
        
        KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:urlsArray selectedIndex:indexPath.row typesArray:typesArray mediaPaths:mediaPaths allDataDicts:dictArray];
        browser.delegate = self;
        browser.dismissalStyle = _dismissalStyle;
        browser.backgroundStyle = _backgroundStyle;
        browser.loadingStyle = _loadingStyle;
        browser.pageindicatorStyle = _pageindicatorStyle;
        browser.bounces = _bounces;
        browser.indexPath=ip1;
        [browser showFromViewController:self];
    }
    else
    {
        groupInCellCell* cell = (groupInCellCell*)[collectionView cellForItemAtIndexPath:indexPath];
        
        NSIndexPath*ip=[(friendsPostsCollectionView *)collectionView indexPath];
        NSIndexPath*ip1=[NSIndexPath indexPathForRow:indexPath.row inSection:ip.row];
        
        NSMutableArray*urlsArray=[[NSMutableArray alloc]init];
        NSMutableArray*typesArray=[[NSMutableArray alloc]init];
        NSMutableArray*mediaPaths=[[NSMutableArray alloc]init];
        
        NSArray*sampleArray;
        sampleArray=self.friendsPost;
        
        for (NSDictionary*dict in [sampleArray objectAtIndex:ip1.section])
        {
            
            KSPhotoItem *item;
            if ([[[[dict valueForKey:@"medias"] objectAtIndex:0] valueForKey:@"media_type"]isEqualToString:@"video"]) {
                item = [KSPhotoItem itemWithSourceView:cell.groupInCellImage thumbImage:[UIImage imageNamed:@"cover_picBack"] imageUrl:[NSURL URLWithString:[[[dict valueForKey:@"medias"] objectAtIndex:0] valueForKey:@"media_thumb"]]];
            }
            else
            {
                item = [KSPhotoItem itemWithSourceView:cell.groupInCellImage thumbImage:[UIImage imageNamed:@"cover_picBack"] imageUrl:[NSURL URLWithString:[[[dict valueForKey:@"medias"] objectAtIndex:0] valueForKey:@"media_path"]]];
            }
            
            
            [urlsArray addObject:item];
            [typesArray addObject:[[[dict valueForKey:@"medias"] objectAtIndex:0] valueForKey:@"media_type"]];
            [mediaPaths addObject:[[[dict valueForKey:@"medias"] objectAtIndex:0] valueForKey:@"media_path"]];
            
            
        }
        
        KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:urlsArray selectedIndex:indexPath.row typesArray:typesArray mediaPaths:mediaPaths allDataDicts:sampleArray];
        browser.delegate = self;
        browser.dismissalStyle = _dismissalStyle;
        browser.backgroundStyle = _backgroundStyle;
        browser.loadingStyle = _loadingStyle;
        browser.pageindicatorStyle = _pageindicatorStyle;
        browser.bounces = _bounces;
        browser.indexPath=ip1;
        [browser showFromViewController:self];
    }
    
    
}

// MARK: - KSPhotoBrowserDelegate

- (void)ks_photoBrowser:(KSPhotoBrowser *)browser didSelectItem:(KSPhotoItem *)item atIndex:(NSUInteger)index
{
    //NSLog(@"selected index: %ld", index);
}
- (CGSize)collectionView:(UICollectionView* )collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath* )indexPath
{
    return CGSizeMake(130, 130);

}



#pragma mark
#pragma mark- Zoom Image
#pragma mark

- (void)bigButtonTapped:(UITapGestureRecognizer*)sender
{
    isReload=NO;

    UIImageView*seletedImage;
    
    seletedImage=(UIImageView*)sender.view;
 
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    
    imageInfo.image = seletedImage.image;
    
    imageInfo.referenceRect = seletedImage.frame;
    
    imageInfo.referenceView = seletedImage.superview;
    imageInfo.referenceContentMode = seletedImage.contentMode;
    imageInfo.referenceCornerRadius = seletedImage.layer.cornerRadius;
    
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc] initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
    
    
}


#pragma mark
#pragma mark- UITableView
#pragma mark


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    if (_isGroupSelected)
    {
        return [groupWallPosts count];

    }
    else
    {
        return [friendsWallPosts count];

    }
 
}

-(void)groupSelected :(UITapGestureRecognizer*)sender
{
    
    GroupMediaViewController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"GroupMediaViewControllerID"];
    tabBarController.groupID=[[groupWallPosts objectAtIndex:sender.view.tag]valueForKey:@"id"];
    [self.navigationController pushViewController:tabBarController animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//     if (!_isGroupSelected)
//     {
//    PostDetailsViewController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"PostDetailsViewControllerID"];
//    
//    tabBarController.postDetails=[friendsWallPosts objectAtIndex:indexPath.row];
//    tabBarController.postID=[[friendsWallPosts objectAtIndex:indexPath.row] valueForKey:@"id"];
//    
//    [self.navigationController pushViewController:tabBarController animated:YES];
//    
//     }

}

- (UITableViewCell *)tableView:(UITableView *)TableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if (_isGroupSelected) {
        static NSString *MyIdentifier = @"groupsCellID";
        groupsCell *cell = [TableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[groupsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        }
        
        cell.groupIcon.layer.cornerRadius = cell.groupIcon.frame.size.height/2;
        cell.groupIcon.clipsToBounds = YES;
        
        cell.groupIcon.tag=indexPath.row;
        cell.groupName.tag=indexPath.row;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
        [tapRecognizer addTarget:self action:@selector(groupSelected:)];
        
        UITapGestureRecognizer *tapRecognizer1 = [[UITapGestureRecognizer alloc] init];
        [tapRecognizer1 addTarget:self action:@selector(groupSelected:)];
        
        [cell.groupIcon addGestureRecognizer:tapRecognizer];
        [cell.groupName addGestureRecognizer:tapRecognizer1];

        NSDictionary*dict=[groupWallPosts objectAtIndex:indexPath.row];
     
        if ([dict valueForKey:@"group_image"])
        {
            
            if ([[dict valueForKey:@"group_image"] length]>0) {
                [cell.groupIcon sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"group_image"]] placeholderImage:[UIImage imageNamed:@"groupSmallBack"] options:SDWebImageRefreshCached];
                
            }
            else
            {
                cell.groupIcon.image=[UIImage imageNamed:@"groupSmallBack"];
            }
        }
        else
        {
            cell.groupIcon.image=[UIImage imageNamed:@"groupSmallBack"];
            
        }
        if ([dict valueForKey:@"group_name"])
        {
            if ([[dict valueForKey:@"group_name"] length]>0) {
                
                cell.groupName.text=[dict valueForKey:@"group_name"];
            }
            else
            {
                cell.groupName.text=@"";
            }
            
        }
        else
        {
            cell.groupName.text=@"";
            
        }

       
        if ([[[dict valueForKey:@"group_posts"] objectAtIndex:0] valueForKey:@"post_time"])
        {
            if ([[[[dict valueForKey:@"group_posts"] objectAtIndex:0] valueForKey:@"post_time"] length]>0)
            {
                
                NSString *timeAgoFormattedDate = [NSDate mysqlDatetimeFormattedAsTimeAgo:[[[dict valueForKey:@"group_posts"] objectAtIndex:0] valueForKey:@"post_time"]];
                
                cell.timeLbl.text=timeAgoFormattedDate;
                
            }
            else
            {
                
                cell.timeLbl.text=@"";
                
            }
            
        }
        else
        {
            cell.timeLbl.text=@"";
            
        }
        
        return cell;


    }
    else
    {
        static NSString *MyIdentifier = @"friendsPostNewCellID";
        friendsPostNewCell *cell = [TableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[friendsPostNewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        }
        
        cell.friendIcon.layer.cornerRadius = cell.friendIcon.frame.size.height/2;
        cell.friendIcon.clipsToBounds = YES;
        
        cell.friendIcon.tag=indexPath.row;
        cell.friendName.tag=indexPath.row;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
        [tapRecognizer addTarget:self action:@selector(friendSelected:)];
        
        UITapGestureRecognizer *tapRecognizer1 = [[UITapGestureRecognizer alloc] init];
        [tapRecognizer1 addTarget:self action:@selector(friendSelected:)];
        
        [cell.friendIcon addGestureRecognizer:tapRecognizer];
        [cell.friendName addGestureRecognizer:tapRecognizer1];
        
        NSDictionary*dict=[friendsWallPosts objectAtIndex:indexPath.row];
        
        
        NSDictionary*dict1=[[[friendsWallPosts objectAtIndex:indexPath.row] valueForKey:@"posts"] objectAtIndex:0];

        
        
        if ([dict1 valueForKey:@"profile_pic"])
        {
            
            if ([[dict1 valueForKey:@"profile_pic"] length]>0) {
                [cell.friendIcon sd_setImageWithURL:[NSURL URLWithString:[dict1 valueForKey:@"profile_pic"]] placeholderImage:[UIImage imageNamed:@"groupSmallBack"] options:SDWebImageRefreshCached];
                
            }
            else
            {
                cell.friendIcon.image=[UIImage imageNamed:@"groupSmallBack"];
            }
        }
        else
        {
            cell.friendIcon.image=[UIImage imageNamed:@"groupSmallBack"];
            
        }
        if ([dict valueForKey:@"name"])
        {
            if ([[dict valueForKey:@"name"] length]>0) {
                
                cell.friendName.text=[dict valueForKey:@"name"];
            }
            else
            {
                cell.friendName.text=@"";
            }
            
        }
        else
        {
            cell.friendName.text=@"";
            
        }
        
        
        
        if ([dict1 valueForKey:@"post_time"])
        {
            if ([[dict1 valueForKey:@"post_time"] length]>0)
            {
                
                NSString *timeAgoFormattedDate = [NSDate mysqlDatetimeFormattedAsTimeAgo:[dict1 valueForKey:@"post_time"]];
                
                cell.timeLbl.text=timeAgoFormattedDate;
                
            }
            else
            {
                
                cell.timeLbl.text=@"";
                
            }
            
        }
        else
        {
            cell.timeLbl.text=@"";
            
        }
        
        return cell;
        
        
    }
    
    
   
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize :(UIImage*)source
{
    UIImage *sourceImage = source;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isGroupSelected)
    {
        groupsCell*cell1=(groupsCell*)cell;
        [cell1 setCollectionViewDataSourceDelegate:self indexPath:indexPath];
        NSInteger index = cell1.groupCollections.indexPath.row;
        
        CGFloat horizontalOffset = [self.contentOffsetDictionary[[@(index) stringValue]] floatValue];
        [cell1.groupCollections setContentOffset:CGPointMake(horizontalOffset, 0)];

    }
    else
    {
         friendsPostNewCell*cell1=(friendsPostNewCell*)cell;
        [cell1 setCollectionViewDataSourceDelegate:self indexPath:indexPath];
        NSInteger index = cell1.friendCollections.indexPath.row;
        
        CGFloat horizontalOffset = [self.contentOffsetDictionary[[@(index) stringValue]] floatValue];
        [cell1.friendCollections setContentOffset:CGPointMake(horizontalOffset, 0)];

    }
}

- (IBAction)notificationsPressed:(UIButton*)sender
{
    
    NotificationsViewController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationsViewControllerID"];
    [self.navigationController pushViewController:tabBarController animated:YES];
}

-(void)friendSelected :(UITapGestureRecognizer*)sender
{
    
//    FriendsProfileViewController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendsProfileViewControllerID"];
//    tabBarController.friendID=[[friendsWallPosts objectAtIndex:sender.view.tag]valueForKey:@"user_id"];
//    [self.navigationController pushViewController:tabBarController animated:YES];
    
    
}


-(void)viewDidDisappear:(BOOL)animated
{
    
}


#pragma mark - ASMediasFocusDelegate
- (UIViewController *)parentViewControllerForMediaFocusManager:(ASMediaFocusManager *)mediaFocusManager
{
    return self;
}

- (NSURL *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager mediaURLForView:(UIView *)view
{
    NSString *name;
    NSURL *url;
    
    NSLog(@"%@",view.accessibilityIdentifier);
    
    NSIndexPath*ip1=[NSIndexPath indexPathForRow:view.tag inSection:[view.accessibilityIdentifier integerValue]];
    NSDictionary*dict=[[_colorArray objectAtIndex:ip1.section] objectAtIndex:ip1.row];
    
    
    name = @"Tittle";
    url = [[NSBundle mainBundle] URLForResource:[name stringByDeletingPathExtension] withExtension:name.pathExtension];
    
   
        url=[NSURL URLWithString:[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_path"]];
    
    return url;
}

- (NSString *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager titleForView:(UIView *)view;
{
    BOOL isVideo;
    NSURL *url;
    NSString *extension;
    
    url = [self mediaFocusManager:mediaFocusManager mediaURLForView:view];
    extension = url.pathExtension.lowercaseString;
    isVideo = [extension isEqualToString:@"mp4"] || [extension isEqualToString:@"mov"];
    
 //   return (isVideo?@"Videos are also supported.":@"Of course, you can zoom in and out on the image.");
    return @"";

}

- (void)mediaFocusManagerWillAppear:(ASMediaFocusManager *)mediaFocusManager
{
    /*
     *  Call here setDefaultDoneButtonText, if you want to change the text and color of default "Done" button
     *  eg: [self.mediaFocusManager setDefaultDoneButtonText:@"Panda" withColor:[UIColor purpleColor]];
     */
    if([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)mediaFocusManagerWillDisappear:(ASMediaFocusManager *)mediaFocusManager
{
    if([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
