//
//  FriendsProfileViewController.m
//  PhotoBunch
//
//  Created by Gorav Grover on 16/06/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import "FriendsProfileViewController.h"
#import "ProfileCollectionCell.h"
#import "SettingsViewController.h"
#import "Constant.h"
#import "profilePostTableCell.h"
#import "groupMediaCollectionCell.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
@interface FriendsProfileViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UIImageView *coverImage;
@property (strong, nonatomic) IBOutlet UILabel *pointsLbl;
@property (strong, nonatomic) IBOutlet UILabel *postsLbl;
@property (strong, nonatomic) IBOutlet UILabel *friendsLbl;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *descriptionConstant;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (strong, nonatomic) IBOutlet UICollectionView *postsCollections;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewConstant;

@end

@implementation FriendsProfileViewController
{
    NSMutableArray*friendsIcons,*profilePosts;
    BOOL isReload;
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    profilePosts=[[NSMutableArray alloc]init];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapRecognizer addTarget:self action:@selector(bigButtonTapped:)];
    
    UITapGestureRecognizer *tapRecognizer1 = [[UITapGestureRecognizer alloc] init];
    [tapRecognizer1 addTarget:self action:@selector(bigButtonTapped:)];
    
    [_profileImage addGestureRecognizer:tapRecognizer];
    [_coverImage addGestureRecognizer:tapRecognizer1];

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
- (void)bigButtonTapped:(UITapGestureRecognizer*)sender
{
    
    UIImageView*seletedImage;
    if (sender.view==_profileImage)
    {
        seletedImage=_profileImage;
    }
    else
    {
        seletedImage=_coverImage;
        
    }
    
    //
    //    if ([seletedImage.image isEqual:[UIImage imageNamed:@"male_Profile.png"]]||[seletedImage.image isEqual:[UIImage imageNamed:@"female_profile.png"]]||[seletedImage.image isEqual:[UIImage imageNamed:@"cover.png"]]) {
    //
    //    }
    //    else
    //    {
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = seletedImage.image;
    
    imageInfo.referenceRect = seletedImage.frame;
    
    imageInfo.referenceView = seletedImage.superview;
    imageInfo.referenceContentMode = seletedImage.contentMode;
    imageInfo.referenceCornerRadius = seletedImage.layer.cornerRadius;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc] initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
    
    // }
    
    
    
    
}

- (IBAction)backBtnPressed:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setInitials:(NSDictionary*)dict
{
    
    if ([[dict valueForKey:@"cover_image"]length]>0)
    {
        
        [_coverImage sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"cover_image"]] placeholderImage:[UIImage imageNamed:@"postBack"] options:SDWebImageRefreshCached];
        
    }
    else
    {
        _coverImage.image=[UIImage imageNamed:@"postBack"];
        
    }
    if ([[dict valueForKey:@"profile_pic"]length]>0)
    {
        
        [_profileImage sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"profile_pic"]] placeholderImage:[UIImage imageNamed:@"male_Profile"] options:SDWebImageRefreshCached];
        
        
    }
    else
    {
        _coverImage.image=[UIImage imageNamed:@"male_Profile"];
        
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
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"user_id":_friendID

                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallToGetFriendProfile:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    
                    [self setInitials :[resultArray valueForKey:@"data"]];
                    
                }
                else
                {
                    if ([[resultArray valueForKey:@"code"] integerValue]==201 ) {
                        
                        
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

-(void)callGetProfilePosts
{
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"user_id":_friendID,
                                   @"limit":@"200",
                                   @"page":@"1"
                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallToGetUserFriendPosts:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
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
                    _collectionViewConstant.constant=10;
                    
                    if ([[resultArray valueForKey:@"code"]integerValue]==201)
                    {
                        _collectionViewConstant.constant=10;
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
#pragma mark- UicollectioView
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
@end
