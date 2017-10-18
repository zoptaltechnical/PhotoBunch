//
//  BlockListViewController.m
//  PhotoBunch
//
//  Created by Gorav Grover on 14/10/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import "BlockListViewController.h"
#import "BlockCell.h"
#import "Constant.h"

@interface BlockListViewController ()
@property (weak, nonatomic) IBOutlet UIButton *blockbtn;
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectiNview;


@end

@implementation BlockListViewController
{
    NSArray*blockList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self callBlockList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)callBlockList
{
    //access_token
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken]
                                   };
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsGetBlockList:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    
                    blockList=[resultArray valueForKey:@"data"];
                    [_mainCollectiNview reloadData];
                    
                }
                else
                {
                    blockList=nil;
                    [_mainCollectiNview reloadData];
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


- (IBAction)blockBtnPressed:(UIButton*)sender
{
    UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Photobunch"  message:@"Do you want to Unblock User?"  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* Ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                             [self calBlockUser:[[blockList objectAtIndex:sender.tag] valueForKey:@"block_to"]];
                             
                         }];
    
    
    UIAlertAction* No = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                             
                             
                         }];
    
    [alert addAction:No];
    
    [alert addAction:Ok];
    
    [self presentViewController:alert animated:YES completion:nil];

    
}

-(void)calBlockUser:(NSString*)user_id
{
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"user_id":user_id,
                                   @"action":@"unblock",
                                   
                                   };
    
    // Parameters: access_token, post_id, reason, report_type
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsBlockUser:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [KAppdelegate stopLoader:self.view];
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    
                    NSDictionary *options = @{
                                              kCRToastTextKey : @"User Unblock Successfully",
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
                    
                    [self callBlockList];
                    
                    
                    
                }
                else
                {
                    
                }
            }];
            
        } failureBlock:^(BOOL succeeded, NSArray *failureArray)
         {
             [KAppdelegate stopLoader:self.view];
             
             [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                 
             }];
             
             
         }];
    }
    else
    {
        [KAppdelegate stopLoader:self.view];
        
    }
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        return [blockList count];
                
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    
    return 1;
    
}




- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BlockCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BlockCell" forIndexPath:indexPath];
    
    cell.blockBtn.tag=indexPath.item;
    
    cell.blockBtn.layer.borderWidth = 2.0f;
    cell.blockBtn.layer.borderColor = [UIColor blackColor].CGColor;
    cell.blockBtn.layer.cornerRadius = 5.0f;
    
    
   NSMutableDictionary* dict=[blockList objectAtIndex:indexPath.row];
    
    if ([dict valueForKey:@"profile_pic"])
    {
        if ([[dict valueForKey:@"profile_pic"]length]>0)
        {
            [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"profile_pic"]] placeholderImage:[UIImage imageNamed:@"maleBack"] options:SDWebImageRefreshCached];
                        
        }
        else
        {
                cell.profilePic.image=[UIImage imageNamed:@"maleBack"];
        }
                    
    }
    else
    {
        cell.profilePic.image=[UIImage imageNamed:@"maleBack"];
                    
    }
    
        if ([dict valueForKey:@"name"])
        {
            if ([[dict valueForKey:@"name"]length]>0)
            {
                cell.userName.text=[dict valueForKey:@"name"];
                        
            }
            else
            {
                cell.userName.text=@"";
            }
                    
        }
        else
        {
            cell.userName.text=@"";
                    
        }
                
                
    
    
    
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    
}
- (CGSize)collectionView:(UICollectionView* )collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath* )indexPath
{
    
    return CGSizeMake(180, 180);
    
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
