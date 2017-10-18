//
//  ProfileViewController.m
//  PhotoBunch
//
//  Created by Gorav Grover on 30/05/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileCollectionCell.h"
#import "SettingsViewController.h"
#import "Constant.h"
#import "profilePostTableCell.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "groupMediaCollectionCell.h"
#import "FTPopOverMenu.h"
#import <AVKit/AVKit.h>

@import AVFoundation;

@interface ProfileViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UIButton *messageBtn;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UIImageView *coverImage;
@property (strong, nonatomic) IBOutlet UIButton *settingsBtn;
@property (strong, nonatomic) IBOutlet UILabel *pointsLbl;
@property (strong, nonatomic) IBOutlet UILabel *postsLbl;
@property (strong, nonatomic) IBOutlet UILabel *friendsLbl;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *descriptionConstant;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (strong, nonatomic) IBOutlet UICollectionView *postsCollections;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewConstant;

@property (weak, nonatomic) IBOutlet UIImageView *friendsBlockBack;

@end

@implementation ProfileViewController
{
    NSMutableArray*friendsIcons,*profilePosts;
    BOOL isReload;
    NSDictionary*profileInfo1;
    AVPlayerViewController *playerViewController;


}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   // _profileImage.layer.cornerRadius = _profileImage.frame.size.height/2;
   // _profileImage.clipsToBounds = YES;
//    _profileImage.contentMode=UIViewContentModeScaleAspectFit;
    profilePosts=[[NSMutableArray alloc]init];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapRecognizer addTarget:self action:@selector(bigButtonTapped:)];
    
    UITapGestureRecognizer *tapRecognizer1 = [[UITapGestureRecognizer alloc] init];
    [tapRecognizer1 addTarget:self action:@selector(bigButtonTapped:)];
    [_profileImage addGestureRecognizer:tapRecognizer];
   // [_coverImage addGestureRecognizer:tapRecognizer1];

    
    UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc] init];
    [tapRecognizer2 addTarget:self action:@selector(friendsPressed:)];
    [_friendsLbl addGestureRecognizer:tapRecognizer2];
    playerViewController = [[AVPlayerViewController alloc] init];

    //_friendsBlockBack.layer.borderColor = [UIColor blackColor].CGColor;
    //_friendsBlockBack.layer.borderWidth = 1;
    isReload=YES;

}

-(void)viewDidAppear:(BOOL)animated
{
    if (isReload==YES)
    {
        [self callGetProfile];
        [self callGetProfilePosts];
        
    }
    isReload=YES;
    
}

- (void)friendsPressed:(UITapGestureRecognizer*)sender
{
    UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    
    UITabBarController *tabBarController = [st instantiateViewControllerWithIdentifier:@"MainTabControllerID"];
    tabBarController.selectedIndex=1;
    
    [KAppdelegate.window setRootViewController:tabBarController];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)bigButtonTapped:(UITapGestureRecognizer*)sender
{
    isReload=NO;

    
    
    
    UIImageView*seletedImage;
    if (sender.view==_profileImage)
    {
        seletedImage=_profileImage;
    }
    else
    {
        seletedImage=_coverImage;
        
    }
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
   // imageInfo.image = seletedImage.image;
    
    imageInfo.imageURL=[NSURL URLWithString:[profileInfo1 valueForKey:@"profile_pic"]];
    imageInfo.referenceRect = seletedImage.frame;
    imageInfo.referenceView = seletedImage.superview;
    imageInfo.referenceContentMode = seletedImage.contentMode;
    imageInfo.referenceCornerRadius = seletedImage.layer.cornerRadius;
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc] initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
    
}




- (IBAction)messageBtnPressed:(id)sender
{
   

}
- (IBAction)settingsBtnPressed:(id)sender
{
    SettingsViewController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewControllerID"];
    [self.navigationController pushViewController:tabBarController animated:YES];
}

-(void)setInitials:(NSDictionary*)dict
{

//    if ([[dict valueForKey:@"cover_image"]length]>0)
//    {
//      
//        [_coverImage sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"cover_image"]] placeholderImage:[UIImage imageNamed:@"cover_picBack"] options:SDWebImageRefreshCached];
//            
//    }
//    else
//    {
//        _coverImage.image=[UIImage imageNamed:@"cover_picBack"];
//        
//    }
//    _profileImage.layer.cornerRadius = 2;
//    _profileImage.layer.borderWidth = 1;
//    _profileImage.layer.borderColor = [UIColor blueColor].CGColor;

    if ([[dict valueForKey:@"profile_pic"]length]>0)
    {
        
        [_profileImage sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"profile_pic"]] placeholderImage:[UIImage imageNamed:@"maleBack"] options:SDWebImageRefreshCached];
    }
    else
    {
        _profileImage.image=[UIImage imageNamed:@"maleBack"];
        
    }
    
    if ([[dict valueForKey:@"description"]length]>0)
    {
        
        CGSize maximumLabelSize = CGSizeMake(100, 100);
        
        CGSize expectedLabelSize = [[dict valueForKey:@"description"] sizeWithFont:_descriptionLbl.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
        
        _descriptionLbl.text=[dict valueForKey:@"description"];
        _descriptionLbl.textColor=[UIColor blackColor];
        CGRect newFrame = _descriptionLbl.frame;
        newFrame.size.height = expectedLabelSize.height;
        _descriptionConstant.constant=newFrame.size.height;
        
    }
    else
    {
        
        _descriptionConstant.constant=20;
        _descriptionLbl.text=@"";
        _descriptionLbl.textColor=[UIColor lightGrayColor];

    }

    if ([[dict valueForKey:@"name"]length]>0)
    {
        _nameLbl.text=[dict valueForKey:@"name"];
    }
    else
    {
        _nameLbl.text=@"";
        
    }
    if ([dict valueForKey:@"points_count"])
    {
        _pointsLbl.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"points_count"]];
    }
    else
    {
        _pointsLbl.text=@"0";
    }
    if ([dict valueForKey:@"posts_count"])
    {
        _postsLbl.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"posts_count"]];
    }
    else
    {
        _postsLbl.text=@"0";
    }
    if ([dict valueForKey:@"friends_count"])
    {
        _friendsLbl.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"friends_count"]];
        
    }
    else
    {
        _friendsLbl.text=@"0";
    }

}
-(void)callGetProfile
{
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken]
                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallToGetUserProfile:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    
                    [self setInitials :[resultArray valueForKey:@"data"]];
                    profileInfo1=[resultArray valueForKey:@"data"];
                    
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

-(void)callGetProfilePosts
{
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken]
                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallToGetUserProfilePosts:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {

                    if ([[resultArray valueForKey:@"data"] count]>3)
                    {
                        _collectionViewConstant.constant=280;

                    }
                    else
                    {
                        _collectionViewConstant.constant=140;

                    }
                    
                    profilePosts=[resultArray valueForKey:@"data"];
                    [_postsCollections reloadData];
                }
                else
                {
                    _collectionViewConstant.constant=0;
                    
                    if ([[resultArray valueForKey:@"code"]integerValue]==201)
                    {
                        _collectionViewConstant.constant=0;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark
#pragma mark- UITableView
#pragma mark


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [profilePosts count];
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        if (reusableview==nil) {
            reusableview=[[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        }
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, reusableview.frame.size.width, 44)];
        label.text=@"User Media";
        label.textAlignment=NSTextAlignmentCenter;
        [reusableview addSubview:label];
        return reusableview;
    }
    return nil;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    groupMediaCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"groupMediaCollectionCellID" forIndexPath:indexPath];
    cell.mediaCell.tag=indexPath.item;

    NSDictionary*dict=[profilePosts objectAtIndex:indexPath.row];
       
    if ([[dict valueForKey:@"medias"]count]>0)
    {
        if ([[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_type"]isEqualToString:@"image"])
        {
            
            [cell.playImage setHidden:YES];
            if ([[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_path"] length]>0)
            {
                 [cell.mediaCell sd_setBackgroundImageWithURL:[NSURL URLWithString:[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_thumb"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"postBackSmall"] options:SDWebImageRefreshCached];
            }
            else
            {
                [cell.mediaCell setBackgroundImage:[UIImage imageNamed:@"postBackSmall"] forState:UIControlStateNormal];
            }
            
        }
        else
        {
            [cell.playImage setHidden:NO];

            if ([[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_thumb"] length]>0)
            {
                
                [cell.mediaCell sd_setBackgroundImageWithURL:[NSURL URLWithString:[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_thumb"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"postBackSmall"] options:SDWebImageRefreshCached];

            }
            else
            {
                [cell.mediaCell setBackgroundImage:[UIImage imageNamed:@"postBackSmall"] forState:UIControlStateNormal];
            }
            
        }
        
    }
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(130, 130);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
}
- (IBAction)mediaBtnPressed:(UIButton*)sender
{
    

        [FTPopOverMenuConfiguration defaultConfiguration ].menuWidth=150;
        [FTPopOverMenu showForSender:sender
                            withMenu:@[@"View Media",@"Delete Media"]
                      imageNameArray:nil
                           doneBlock:^(NSInteger selectedIndex) {
                               if (selectedIndex==0)
                               {
                                   isReload=NO;

                                   if ([[[[[profilePosts objectAtIndex:sender.tag] valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_type"]isEqualToString:@"video"])
                                   {
                                       NSURL *url = [NSURL URLWithString:[[[[profilePosts objectAtIndex:sender.tag] valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_path"]];
                                       [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                                       
                                       AVURLAsset *asset = [AVURLAsset assetWithURL: url];
                                       AVPlayerItem *item = [AVPlayerItem playerItemWithAsset: asset];
                                       
                                       AVPlayer * player = [[AVPlayer alloc] initWithPlayerItem: item];
                                       playerViewController.player = player;
                                       playerViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
                                       playerViewController.showsPlaybackControls = YES;
                                       [self presentViewController:playerViewController animated:YES completion:nil];
                                       [player play];

                                   
                                   }
                                   else
                                   {
                                       // Create image info
                                       JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
                                       // imageInfo.image = [sender backgroundImageForState:UIControlStateNormal];
                                       
                                       
                                       imageInfo.imageURL=[NSURL URLWithString:[[[[profilePosts objectAtIndex:sender.tag] valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_path"]];
                                       imageInfo.referenceRect = sender.frame;
                                       
                                       imageInfo.referenceView = sender.superview;
                                       imageInfo.referenceContentMode = sender.contentMode;
                                       imageInfo.referenceCornerRadius = sender.layer.cornerRadius;
                                       
                                       // Setup view controller
                                       JTSImageViewController *imageViewer = [[JTSImageViewController alloc] initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
                                       
                                       // Present the view controller.
                                       [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
                                   }

                                  
    
    
                               }
                               else if (selectedIndex==1)
                               {
                                   UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@""  message:@"Are you sure you want to Delete Media Post?"  preferredStyle:UIAlertControllerStyleAlert];
    
                                   UIAlertAction* Yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       
                                      [self callDeletePost:[[profilePosts objectAtIndex:sender.tag]valueForKey:@"id"]];
    
    
                                   }];
                                   UIAlertAction* Cancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    
                                       [alert dismissViewControllerAnimated:YES completion:nil];
    
                                   }];
                                   [alert addAction:Yes];
                                   [alert addAction:Cancel];
    
                                   [self presentViewController:alert animated:YES completion:nil];
    
                               }
    
                               
                           } dismissBlock:^{
                               
                               NSLog(@"user canceled. do nothing.");
                               
                           }];

}

-(void)callDeletePost :(NSString*)postID
{
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"post_id":postID

                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallToDeletePost:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    
                    [self callGetProfilePosts];
                }
                else
                {
                    if ([[resultArray valueForKey:@"code"]integerValue]==201)
                    {
                        NSDictionary *options = @{
                                                  kCRToastTextKey : [resultArray valueForKey:@"message"],
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
