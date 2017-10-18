//
//  FavoriteViewController.m
//  PhotoBunch
//
//  Created by Gorav Grover on 30/05/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import "FavoriteViewController.h"
#import "FriendsTabCollectionCell.h"
#import "Constant.h"
#import "CZPickerView.h"
#import "FriendsProfileViewController.h"

@interface FavoriteViewController ()<CZPickerViewDataSource,CZPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property CZPickerView *pickerWithImage;


@end

@implementation FavoriteViewController
{
    IBOutlet UILabel *nofavLbl;
    NSMutableArray*friendsIcons,*friendsArray,*allFriendsArray,*selectedindexes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    friendsArray=[[NSMutableArray alloc]init];
    allFriendsArray=[[NSMutableArray alloc]init];
    selectedindexes=[[NSMutableArray alloc]init];
    
    [nofavLbl setHidden:YES];
    [_mainCollectionView setHidden:YES];
    
    //[_mainCollectionView reloadData];
    [self callGetAllFriends];
    
    [self callGetAllFavs];
    
}
- (IBAction)unFavPressed:(UIButton*)sender
{
    
    NSString*friendID=[[friendsArray objectAtIndex:sender.tag] valueForKey:@"id"];
    [self callMakeUnFav:friendID];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtnPressed:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addFavPressed:(id)sender
{
    [selectedindexes removeAllObjects];
    
    if (friendsArray.count>0) {
        
        NSArray*idArray=[friendsArray valueForKey:@"id"];
        NSArray*totalIdArray=[allFriendsArray valueForKey:@"id"];
        for (int i=0; i<friendsArray.count; i++)
        {
            
            NSInteger anIndex=[totalIdArray indexOfObject:[idArray objectAtIndex:i]];
            
            if(NSNotFound != anIndex)
            {
                [selectedindexes addObject:[NSNumber numberWithInteger:anIndex]];
            }
        }

    }
    
    self.pickerWithImage = [[CZPickerView alloc] initWithHeaderTitle:@"Select friends to make favourite." cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Select"];
    self.pickerWithImage.delegate = self;
    self.pickerWithImage.dataSource = self;
    self.pickerWithImage.needFooterView = YES;
    self.pickerWithImage.allowMultipleSelection=YES;
    [self.pickerWithImage setSelectedRows:selectedindexes];
    [self.pickerWithImage show];
    
}

-(void)callGetAllFavs
{
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken]
                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallToGetAllFav:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            friendsArray=nil;
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    
                    [nofavLbl setHidden:YES];
                    [_mainCollectionView setHidden:NO];
                    
                    friendsArray=[resultArray valueForKey:@"data"];
                    [_mainCollectionView reloadData];
                    
                }
                else
                {
                    if ([[resultArray valueForKey:@"code"]integerValue ]==201)
                    {
                        [nofavLbl setHidden:NO];
                        [_mainCollectionView setHidden:YES];
                    }
                    else
                    {
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
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    
                    allFriendsArray=[resultArray valueForKey:@"data"];
                    
                }
                else
                {
                    
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

-(void)callMakeFav :(NSString*)friendID
{
    //access_token
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"friend_ids":friendID
                                   
                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallToMakeFav:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    [self callGetAllFavs];
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
-(void)callMakeUnFav :(NSString*)friendID
{
    //access_token
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"friend_id":friendID
                                   
                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallToMakeUNFav:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    
                    [self callGetAllFavs];
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


#pragma mark CZPIcker Delegates

- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row{
    
    return [[allFriendsArray objectAtIndex:row]valueForKey:@"name"];
    
}

- (UIImage *)czpickerView:(CZPickerView *)pickerView imageForRow:(NSInteger)row
{
    
    return nil;
    
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row
{
    
    
    
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemsAtRows:(NSArray *)rows
{
    
    NSMutableArray*array=[[NSMutableArray alloc]init];
    
    for (int i=0; i<rows.count; i++)
    {
        [array addObject:[[allFriendsArray objectAtIndex:[[rows objectAtIndex:i] integerValue]] valueForKey:@"id"]];
        
    }
    NSString *joinedComponents = [array componentsJoinedByString:@","];
    
    
    [self callMakeFav:joinedComponents];
    
    
}

#pragma mark CZPickerView delegates
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView
{
    return [allFriendsArray count];
    
}





#pragma mark
#pragma mark- CollectionView
#pragma mark

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [friendsArray count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    FriendsTabCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FriendsTabCollectionCellID" forIndexPath:indexPath];
    
    cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.height/2;
    cell.profileImage.clipsToBounds = YES;
    cell.unFavBtn.tag=indexPath.item;
    cell.messageBtn.tag=indexPath.item;
    
    
    NSMutableDictionary*dict=[friendsArray objectAtIndex:indexPath.item];
    
    if ([dict valueForKey:@"profile_pic"])
    {
        if ([[dict valueForKey:@"profile_pic"]length]>0) {
            [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"profile_pic"]] placeholderImage:nil options:SDWebImageRefreshCached];
            
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
    
    
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
//    FriendsProfileViewController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendsProfileViewControllerID"];
//    tabBarController.friendID=[[friendsArray objectAtIndex:indexPath.item]valueForKey:@"id"];
//    [self.navigationController pushViewController:tabBarController animated:YES];
    
}
- (CGSize)collectionView:(UICollectionView* )collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath* )indexPath
{
    
    return CGSizeMake(180, 180);
    
}
- (IBAction)messageBtnPressed:(UIButton*)sender {
    
    
    [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
    
    NSString *userid;;
    
    
    
       
    
    
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
