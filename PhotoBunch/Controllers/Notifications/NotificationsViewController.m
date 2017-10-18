//
//  NotificationsViewController.m
//  PhotoBunch
//
//  Created by Gorav Grover on 19/06/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import "NotificationsViewController.h"
#import "NotificationCell.h"
#import "Constant.h"
@interface NotificationsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *notificationTableView;
@property (strong, nonatomic) IBOutlet UIImageView *noNotifications;

@end

@implementation NotificationsViewController
{
    NSMutableArray*notificationArray;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _notificationTableView.tableFooterView=[UIView new];
    notificationArray=[[NSMutableArray alloc]init];
    
    [_noNotifications setHidden:YES];
    [_notificationTableView setHidden:NO];
    
    [self callGetAllNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark
#pragma mark- UITableView
#pragma mark


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
  
                
    return [notificationArray count];
                
    
    
    
}
- (UITableViewCell *)tableView:(UITableView *)TableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
        static NSString *MyIdentifier = @"NotificationCellID";
        
        NotificationCell *cell = [TableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            
            cell = [[NotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
            
        }
        
        NSDictionary*dict;
        
        
        dict=[notificationArray objectAtIndex:indexPath.row];
    
        cell.userImage.layer.cornerRadius = cell.userImage.frame.size.height/2;
        cell.userImage.clipsToBounds = YES;
        
        
        if ([dict valueForKey:@"sender_profile_pic"])
        {
            if ([[dict valueForKey:@"sender_profile_pic"] length]>0) {
                [cell.userImage sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"sender_profile_pic"]] placeholderImage:[UIImage imageNamed:@"maleBack"] options:SDWebImageRefreshCached];
                
            }
            else
            {
                cell.userImage.image=[UIImage imageNamed:@"maleBack"];
            }
        }
        else
        {
            cell.userImage.image=[UIImage imageNamed:@"maleBack"];
            
        }
        if ([dict valueForKey:@"sender_name"])
        {
            if ([[dict valueForKey:@"sender_name"] length]>0) {
                
                cell.userName.text=[dict valueForKey:@"sender_name"];
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
    
    if ([dict valueForKey:@"message"])
    {
        if ([[dict valueForKey:@"message"] length]>0) {
            
            cell.notificationText.text=[dict valueForKey:@"message"];
        }
        else
        {
            cell.notificationText.text=@"";
        }
        
    }
    else
    {
        cell.notificationText.text=@"";
        
    }

        return cell;
    
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary*notificationDict=[notificationArray objectAtIndex:indexPath.row];
    
        if ([[notificationDict valueForKey:@"type"]isEqualToString:@"group_join_invitation"])
        {
            UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            
            UITabBarController *tabBarController = [st instantiateViewControllerWithIdentifier:@"MainTabControllerID"];
            tabBarController.selectedIndex=3;
            KAppdelegate.notificationType=@"group_join_invitation";
            
            [KAppdelegate.window setRootViewController:tabBarController];
            
            
            
            
        }
        else if ([[notificationDict valueForKey:@"type"]isEqualToString:@"re_open_group"])
        {
            
        }
        else if ([[notificationDict valueForKey:@"type"]isEqualToString:@"new_post_in_group"])
        {
            UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            
            UITabBarController *tabBarController = [st instantiateViewControllerWithIdentifier:@"MainTabControllerID"];
            tabBarController.selectedIndex=0;
            
            [KAppdelegate.window setRootViewController:tabBarController];
            
            
        }
        else if ([[notificationDict valueForKey:@"type"]isEqualToString:@"friend_new_post"])
        {
            
            UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            
            UITabBarController *tabBarController = [st instantiateViewControllerWithIdentifier:@"MainTabControllerID"];
            tabBarController.selectedIndex=0;
            KAppdelegate.notificationType=@"friend_new_post";
            [KAppdelegate.window setRootViewController:tabBarController];
            
            
        }
        else if ([[notificationDict valueForKey:@"type"]isEqualToString:@"group_join_request"])
        {
            
            UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            
            UITabBarController *tabBarController = [st instantiateViewControllerWithIdentifier:@"MainTabControllerID"];
            tabBarController.selectedIndex=3;
           KAppdelegate.notificationType=@"group_join_request";
            
            [KAppdelegate.window setRootViewController:tabBarController];
            
           
            
            
            
            
        }
        else if ([[notificationDict valueForKey:@"type"]isEqualToString:@"friend_request_received"])
        {
            
            UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            
            UITabBarController *tabBarController = [st instantiateViewControllerWithIdentifier:@"MainTabControllerID"];
            tabBarController.selectedIndex=1;
            
            [KAppdelegate.window setRootViewController:tabBarController];
            
            
            
        }
        else if ([[notificationDict valueForKey:@"type"]isEqualToString:@"friend_request_accepted"])
        {
            UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            
            UITabBarController *tabBarController = [st instantiateViewControllerWithIdentifier:@"MainTabControllerID"];
            tabBarController.selectedIndex=1;
            
            [KAppdelegate.window setRootViewController:tabBarController];
            
        }
}


- (IBAction)backBtnPressed:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)callGetAllNotifications
{
    //access_token
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken]
                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallToGetNotificaions:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    notificationArray=[resultArray valueForKey:@"data"];
                    [_notificationTableView reloadData];
                    
                    [_noNotifications setHidden:YES];
                    [_notificationTableView setHidden:NO];

                    
                }
                else
                {
                    if ([[resultArray valueForKey:@"code"] integerValue]==201 )
                    {
                        
                        [_noNotifications setHidden:NO];
                        [_notificationTableView setHidden:YES];
                        
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
