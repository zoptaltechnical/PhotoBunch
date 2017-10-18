//
//  FriendsViewController.m
//  PhotoBunch
//
//  Created by Gorav Grover on 30/05/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendsTabCollectionCell.h"
#import "FavoriteViewController.h"
#import "Constant.h"
#import "FriendsProfileViewController.h"
#import "BlockListViewController.h"


@interface FriendsViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) bool isFiltered;
@property (strong, nonatomic) NSMutableArray* filteredTableData,*namesArray;



@end

@implementation FriendsViewController
{
    NSMutableArray*friendsIcons,*friendsArray;
    NSMutableArray*myFriends,*friendsRequestsArray,*sentRequestArray,*remaningUsers,*searchArray;
    
    int fromIntegerValue;
    
    BOOL isSearchBegin;
    BOOL isSearchResult;

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    friendsIcons=[[NSMutableArray alloc]init];
    _namesArray=[[NSMutableArray alloc]init];
    friendsArray=[[NSMutableArray alloc]init];
    
    myFriends=[[NSMutableArray alloc]init];
    friendsRequestsArray=[[NSMutableArray alloc]init];
    sentRequestArray=[[NSMutableArray alloc]init];
    remaningUsers=[[NSMutableArray alloc]init];
    searchArray=[[NSMutableArray alloc]init];

    _isFiltered=NO;
    
   
    
    
    
}
- (IBAction)blockListPressed:(id)sender {
    
    BlockListViewController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"BlockListViewController"];
    [self.navigationController pushViewController:tabBarController animated:YES];

    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidAppear:(BOOL)animated
{
    [friendsArray removeAllObjects];

    isSearchBegin=NO;
    isSearchResult=NO;
    [self callGetAllFriends];
    fromIntegerValue=1;

    [self callGetAllUsers];
    
}
-(void)callGetAllFriends
{
    //access_token
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken]
                                   };
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallToGetAllFriends:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                myFriends =nil;
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    
                    myFriends=[resultArray valueForKey:@"data"];
                    [_mainCollectionView reloadData];

                    [self callGetAllFriendReqs];
                }
                else
                {
                    
                    [self callGetAllFriendReqs];
                    [_mainCollectionView reloadData];
                   // [_mainCollectionView reloadData];


                }
            }];
            
        } failureBlock:^(BOOL succeeded, NSArray *failureArray)
         {
             
             [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                 
                 [KAppdelegate stopLoader:self.view];
                 
             }];
             
             
         }];
    }
    else
    {
        
    }
    
}

-(void)callGetAllFriendReqs
{
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken]
                                   };
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallToGetAllFriendReqs:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                friendsRequestsArray=nil;
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    
                    friendsRequestsArray=[resultArray valueForKey:@"Data"];
                    [_mainCollectionView reloadData];

                }
                else
                {
                    friendsRequestsArray=[[NSMutableArray alloc]init];
                    [_mainCollectionView reloadData];

                }
            }];
            
        } failureBlock:^(BOOL succeeded, NSArray *failureArray)
         {
             
             [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                 
                 [KAppdelegate stopLoader:self.view];
                 
             }];
             
             
         }];
    }
    else
    {
        
    }
    
}

-(void)callGetAllUsers
{
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"page":[NSString stringWithFormat:@"%d",fromIntegerValue],
                                   @"limit":@"10"
                                   };
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallToGetAllUsers:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    [friendsArray addObjectsFromArray:[resultArray valueForKey:@"data"]];
                    [_mainCollectionView reloadData];
                }
                else
                {
                    if ([[resultArray valueForKey:@"code"] integerValue]==201 )
                    {
                        
                    }
                    else
                    {
                        
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

-(void)callGetSearchUsers :(NSString*)userString
{

    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"search_name":userString

                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallToSearchUser:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                   
                    isSearchResult=YES;
                    searchArray=[resultArray valueForKey:@"data"];
                    [_mainCollectionView reloadData];
                        
                }
                else
                {
                    if ([[resultArray valueForKey:@"code"] integerValue]==201 )
                    {
                        NSDictionary *options = @{
                                                  kCRToastTextKey : @"No User found.",
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
- (IBAction)favPressed:(id)sender
{

    FavoriteViewController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoriteViewControllerID"];
    [self.navigationController pushViewController:tabBarController animated:YES];

}


#pragma mark
#pragma mark- CollectionView
#pragma mark

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(isSearchResult)
    {
        return [searchArray count];
    }
    else
    {
        if (isSearchBegin)
        {
            return [friendsArray count];

        }
        else
        {
            
            if (section==0)
            {
                return [friendsRequestsArray count];

            }
            else
            {
                return [myFriends count];

            }

        }

    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
 
    if(isSearchResult)
    {
        return 1;
    }
    else
    {
        if (isSearchBegin)
        {
            return 1;
            
        }
        else
        {
            return 2;
            
        }
        
    }
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FriendsTabCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FriendsTabCollectionCellID" forIndexPath:indexPath];
    
    cell.linkBtn.tag=indexPath.item;
    [cell.linkBtn setAccessibilityIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
    
    cell.acceptBtn.tag=indexPath.item;
    [cell.acceptBtn setAccessibilityIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
    
    cell.rejectBtn.tag=indexPath.item;
    [cell.rejectBtn setAccessibilityIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
    
    cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.height/2;
    cell.profileImage.clipsToBounds = YES;
    
    cell.messageBtn.tag=indexPath.item;
    [cell.messageBtn setAccessibilityIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
    
    [cell.acceptBtn setHidden:YES];
    [cell.rejectBtn setHidden:YES];
    
    NSDictionary*dict;
    if(isSearchResult)
    {
        dict=[searchArray objectAtIndex:indexPath.row];
    }
    else
    {
        if (isSearchBegin)
        {
            dict=[friendsArray objectAtIndex:indexPath.row];
            
        }
        else
        {
            if (indexPath.section==0)
            {
                dict=[friendsRequestsArray objectAtIndex:indexPath.row];
                
                
            }
            else
            {
                
                dict=[myFriends objectAtIndex:indexPath.row];
                
            }
            
        }
        
    }
    
    NSString *friendStatus=[NSString stringWithFormat:@"%@",[dict valueForKey:@"is_friend"]];
    
    if ([friendStatus isEqualToString:@"1"])
    {
        
        [cell.linkBtn setImage:[UIImage imageNamed:@"disable_friends"] forState:UIControlStateNormal];
        [cell.linkBtn setEnabled:YES];
        
    }
    else if ([friendStatus isEqualToString:@"2"])
    {
        [cell.linkBtn setImage:[UIImage imageNamed:@"active_add"] forState:UIControlStateNormal];
        [cell.linkBtn setEnabled:NO];
        [cell.acceptBtn setHidden:NO];
        [cell.rejectBtn setHidden:NO];
        
    }
    else if ([friendStatus isEqualToString:@"0"])
    {
        [cell.linkBtn setImage:[UIImage imageNamed:@"disable_add"] forState:UIControlStateNormal];
        [cell.linkBtn setEnabled:YES];
        
    }
    else if ([friendStatus isEqualToString:@"3"])
    {
        [cell.linkBtn setImage:[UIImage imageNamed:@"active_add"] forState:UIControlStateNormal];
        [cell.linkBtn setEnabled:YES];
    }
    
    
    
    if (!isSearchResult)
    {
        if (!isSearchBegin)
        {
            if (indexPath.section==0)
            {
                [cell.linkBtn setImage:[UIImage imageNamed:@"plusFr"] forState:UIControlStateNormal];
                [cell.linkBtn setEnabled:NO];
                [cell.acceptBtn setHidden:NO];
                [cell.rejectBtn setHidden:NO];
                
                if ([dict valueForKey:@"sender_profile_pic"])
                {
                    if ([[dict valueForKey:@"sender_profile_pic"]length]>0) {
                        [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"sender_profile_pic"]] placeholderImage:[UIImage imageNamed:@"maleBack"] options:SDWebImageRefreshCached];
                        
                    }
                    else
                    {
                        cell.profileImage.image=[UIImage imageNamed:@"maleBack"];
                    }
                    
                }
                else
                {
                    cell.profileImage.image=[UIImage imageNamed:@"maleBack"];
                    
                }
                if ([dict valueForKey:@"sender_name"])
                {
                    if ([[dict valueForKey:@"sender_name"]length]>0) {
                        cell.profileName.text=[dict valueForKey:@"sender_name"];
                        
                    }
                    else
                    {
                        cell.profileName.text=@"";
                    }
                    
                }
                else
                {
                    cell.profileName.text=@"";
                    
                }
                
                
            }
            else
            {
                if ([dict valueForKey:@"profile_pic"])
                {
                    if ([[dict valueForKey:@"profile_pic"]length]>0) {
                        [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"profile_pic"]] placeholderImage:[UIImage imageNamed:@"maleBack"] options:SDWebImageRefreshCached];
                        
                    }
                    else
                    {
                        cell.profileImage.image=[UIImage imageNamed:@"maleBack"];
                    }
                    
                }
                else
                {
                    cell.profileImage.image=[UIImage imageNamed:@"maleBack"];
                    
                }
                if ([dict valueForKey:@"name"])
                {
                    if ([[dict valueForKey:@"name"]length]>0) {
                        cell.profileName.text=[dict valueForKey:@"name"];
                        
                    }
                    else
                    {
                        cell.profileName.text=@"";
                    }
                    
                }
                else
                {
                    cell.profileName.text=@"";
                    
                }
 
            }
            
        }
        else
        {
            if ([dict valueForKey:@"profile_pic"])
            {
                if ([[dict valueForKey:@"profile_pic"]length]>0) {
                    [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"profile_pic"]] placeholderImage:[UIImage imageNamed:@"maleBack"] options:SDWebImageRefreshCached];
                    
                }
                else
                {
                    cell.profileImage.image=[UIImage imageNamed:@"maleBack"];
                }
                
            }
            else
            {
                cell.profileImage.image=[UIImage imageNamed:@"maleBack"];
                
            }
            if ([dict valueForKey:@"name"])
            {
                if ([[dict valueForKey:@"name"]length]>0) {
                    cell.profileName.text=[dict valueForKey:@"name"];
                    
                }
                else
                {
                    cell.profileName.text=@"";
                }
                
            }
            else
            {
                cell.profileName.text=@"";
                
            }

        }
        
    }
    else
    {
        if ([dict valueForKey:@"profile_pic"])
        {
            if ([[dict valueForKey:@"profile_pic"]length]>0) {
                [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"profile_pic"]] placeholderImage:[UIImage imageNamed:@"maleBack"] options:SDWebImageRefreshCached];
                
            }
            else
            {
                cell.profileImage.image=[UIImage imageNamed:@"maleBack"];
            }
            
        }
        else
        {
            cell.profileImage.image=[UIImage imageNamed:@"maleBack"];
            
        }
        if ([dict valueForKey:@"name"])
        {
            if ([[dict valueForKey:@"name"]length]>0) {
                cell.profileName.text=[dict valueForKey:@"name"];
                
            }
            else
            {
                cell.profileName.text=@"";
            }
            
        }
        else
        {
            cell.profileName.text=@"";
            
        }
    }
    
    
 
    
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
//    NSString *nameSelected;
//    
//    if(isSearchResult)
//    {
//        nameSelected = [[searchArray objectAtIndex:indexPath.item]valueForKey:@"id"];
//    }
//    else
//    {
//        if (isSearchBegin)
//        {
//            nameSelected = [[friendsArray objectAtIndex:indexPath.item]valueForKey:@"id"];
//            
//        }
//        else
//        {
//            
//            if (indexPath.section==0)
//            {
//                nameSelected = [[friendsRequestsArray objectAtIndex:indexPath.item]valueForKey:@"sender_id"];
//
//            }
//            else
//            {
//                nameSelected = [[myFriends objectAtIndex:indexPath.item]valueForKey:@"id"];
//
//            }
//            
//        }
//        
//    }
//    
//    FriendsProfileViewController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendsProfileViewControllerID"];
//    tabBarController.friendID=nameSelected;
//    [self.navigationController pushViewController:tabBarController animated:YES];
    

    
}
- (CGSize)collectionView:(UICollectionView* )collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath* )indexPath
{
    
    return CGSizeMake(180, 180);
    
}



//Add Friend

- (IBAction)AddOrLinkFriend:(UIButton*)sender
{
    NSString *friendStatus;
    NSDictionary*dict;
    NSIndexPath*ip1=[NSIndexPath indexPathForRow:sender.tag inSection:[sender.accessibilityIdentifier integerValue]];

    if(isSearchResult)
    {
        dict=[searchArray objectAtIndex:sender.tag];
    }
    else
    {
        if (isSearchBegin)
        {
            dict=[friendsArray objectAtIndex:sender.tag];
            
        }
        else
        {
            
            if (ip1.section==0)
            {
                dict=[friendsRequestsArray objectAtIndex:sender.tag];

            }
            else
            {
                dict=[myFriends objectAtIndex:sender.tag];

            }
            
        }
        
    }

    friendStatus=[NSString stringWithFormat:@"%@",[dict valueForKey:@"is_friend"]];


    if ([friendStatus isEqualToString:@"0"])
    {
        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Photobunch"  message:@"Do you want to send friend request?"  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* Ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                                 [self callAddFriend:[dict valueForKey:@"id"]];
                                 
                             }];
        
        
        UIAlertAction* No = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                                 
                                 
                             }];
        
        [alert addAction:No];
        
        [alert addAction:Ok];
        
        [self presentViewController:alert animated:YES completion:nil];


        
    }
    else if ([friendStatus isEqualToString:@"1"])
    {
        
        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Photobunch"  message:@"Unfriend?"  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* Ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                                 [self callUnfriend:[dict valueForKey:@"id"]];
                                 
                             }];
        
        
        UIAlertAction* No = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                                 
                                 
                             }];
        
        [alert addAction:No];
        
        [alert addAction:Ok];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
    else if ([friendStatus isEqualToString:@"2"])
    {
        
        //[[SingletonClass sharedInstance]showAlert:@"Friend Request Recieved from the user selected please accept." withDelegate:self withCancelTitle:@"OK" otherTitle:nil];
        

    }

    else if ([friendStatus isEqualToString:@"3"])
    {
        
        NSDictionary *options = @{
                                  kCRToastTextKey : @"Friend Request Already Sent.",
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
-(void)callUnfriend :(NSString*)friendsID
{
    //access_token
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"friend_id":friendsID
                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallSendUnfriendRequest:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    
                    isSearchBegin=NO;
                    isSearchResult=NO;
                    [self callGetAllFriends];
                    fromIntegerValue=1;
                    [friendsArray removeAllObjects];

                    [self callGetAllUsers];

                    
                    
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

-(void)callAddFriend :(NSString*)friendsID
{
    //access_token
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"receiver_id":friendsID
                                   
                                   
                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallSendFriendRequest:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    [friendsArray removeAllObjects];

                    isSearchBegin=NO;
                    isSearchResult=NO;
                    [self callGetAllFriends];
                    fromIntegerValue=1;
                    
                    [self callGetAllUsers];

                    
                }
                else
                {
                    if ([[resultArray valueForKey:@"code"] integerValue]==201 ) {
                        
                        
                        NSDictionary *options = @{
                                                  kCRToastTextKey : [resultArray valueForKey:@"message"],
                                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                                  kCRToastBackgroundColorKey : [UIColor greenColor],
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


- (IBAction)messageFriend:(UIButton*)sender
{
//    NSIndexPath*ip1=[NSIndexPath indexPathForRow:sender.tag inSection:[sender.accessibilityIdentifier integerValue]];
//
//    [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
//
//    NSString *userid;;
//    
//    if(isSearchResult)
//    {
//        [self callGetProfile:[[searchArray objectAtIndex:sender.tag] valueForKey:@"id"]];
//        
//        userid=[[searchArray objectAtIndex:sender.tag] valueForKey:@"quickbox_id"];
//    }
//    else
//    {
//        if (isSearchBegin)
//        {
//            userid=[[friendsArray objectAtIndex:sender.tag] valueForKey:@"quickbox_id"];
//            
//        }
//        else
//        {
//            if (ip1.section==0)
//            {
//                userid=[[friendsRequestsArray objectAtIndex:sender.tag] valueForKey:@"sender_quickbox_id"];
//                
//            }
//            else
//            {
//                userid=[[myFriends objectAtIndex:sender.tag] valueForKey:@"quickbox_id"];
//
//            }
//            
//        }
//        
//    }
//    
//    [QBRequest userWithID:[userid integerValue] successBlock:^(QBResponse *response, QBUUser *user)
//     {
//         [ServicesManager.instance.chatService createPrivateChatDialogWithOpponent:user completion:^(QBResponse *response, QBChatDialog *createdDialog)
//          {
//              
//              
//              if (createdDialog  !=nil)
//              {
//                  [KAppdelegate stopLoader:self.view];
//
//                  
//                  ChatViewController *chat = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
//                  // chat.hidesBottomBarWhenPushed = YES;
//                  // chat.view.frame=CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-80);
//                  
//                  chat.userName=user.login;
//                  chat.dialog=createdDialog;
//                  [self presentViewController:chat animated:YES completion:^{
//                      
//                  }];
//                  // [self.navigationController pushViewController:chat animated:YES];
//                  
//              }
//              else {
//                  [KAppdelegate stopLoader:self.view];
//
//              }
//          }];
//         
//         
//     } errorBlock:^(QBResponse *response)
//     {
//         
//         [KAppdelegate stopLoader:self.view];
//
//     }];

    
    
    
}

-(void)callGetProfile :(NSString*)friendID
{
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"user_id":friendID
                                   
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
                    
                    
                    if (KAppdelegate.hasInternetConnection)
                    {
                        
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



- (IBAction)acceptRequest:(UIButton*)sender
{
    
    NSIndexPath*ip1=[NSIndexPath indexPathForRow:sender.tag inSection:[sender.accessibilityIdentifier integerValue]];

    if(isSearchResult)
    {
        [self callAcceptOrReject:[[searchArray objectAtIndex:sender.tag]valueForKey:@"id"] Status:@"1"];
    }
    else
    {
        if (isSearchBegin)
        {
            [self callAcceptOrReject:[[friendsArray objectAtIndex:sender.tag]valueForKey:@"id"] Status:@"1"];
            
        }
        else
        {
            
            if (ip1.section==0)
            {
                [self callAcceptOrReject:[[friendsRequestsArray objectAtIndex:sender.tag]valueForKey:@"sender_id"] Status:@"1"];
                
            }
            else
            {
                [self callAcceptOrReject:[[myFriends objectAtIndex:sender.tag]valueForKey:@"sender_id"] Status:@"1"];
                
            }
        }
    }
  
}
- (IBAction)rejectRequest:(UIButton*)sender
{
    NSIndexPath*ip1=[NSIndexPath indexPathForRow:sender.tag inSection:[sender.accessibilityIdentifier integerValue]];

    if(isSearchResult)
    {
        [self callAcceptOrReject:[[searchArray objectAtIndex:sender.tag]valueForKey:@"id"] Status:@"2"];
    }
    else
    {
        if (isSearchBegin)
        {
            [self callAcceptOrReject:[[friendsArray objectAtIndex:sender.tag]valueForKey:@"id"] Status:@"2"];
            
        }
        else
        {
            if (ip1.section==0)
            {
                [self callAcceptOrReject:[[friendsRequestsArray objectAtIndex:sender.tag]valueForKey:@"sender_id"] Status:@"2"];
                
            }
            else
            {
                [self callAcceptOrReject:[[myFriends objectAtIndex:sender.tag]valueForKey:@"id"] Status:@"2"];
                
            }
        }
        
        
        
    }

}

-(void)callAcceptOrReject :(NSString*)friendsID Status:(NSString*)ststus
{
    //access_token
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"sender_id":friendsID,
                                   @"status":ststus
                                   
                                   };
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallAcceptRejectRequest:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    [friendsArray removeAllObjects];

                    isSearchBegin=NO;
                    isSearchResult=NO;
                    [self callGetAllFriends];
                    fromIntegerValue=1;
                    
                    [self callGetAllFriends];

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


//*****************
// SEARCH BAR
//*****************

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    //NSLog(@"searchBar ... text.length: %d", text.length);
    
    if(text.length == 0)
    {
        isSearchResult=NO;
        isSearchBegin=NO;
        [_mainCollectionView reloadData];

    }
    else
    {
        
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //User hit Search button on Keyboard
    isSearchResult=YES;
    [self callGetSearchUsers:searchBar.text];
    [searchBar resignFirstResponder];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    isSearchBegin=YES;
    [_mainCollectionView reloadData];

    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isSearchBegin=NO;
    isSearchResult=NO;
   // [self callGetAllUsers];
    searchBar.text=@"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    
    [_mainCollectionView reloadData];
}



#pragma  mark serverCall Load MoreRows
- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
                  willDecelerate:(BOOL)decelerate{
    if([[NSUserDefaults  standardUserDefaults]boolForKey:@"AppliedJobClick"])
    {
    }
    else{
        CGPoint offset = aScrollView.contentOffset;
        CGRect bounds = aScrollView.bounds;
        CGSize size = aScrollView.contentSize;
        UIEdgeInsets inset = aScrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        float reload_distance = 10;
        if(y > h + reload_distance)
        {
        fromIntegerValue++;

        [self callGetAllUsers];
            
            
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
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
