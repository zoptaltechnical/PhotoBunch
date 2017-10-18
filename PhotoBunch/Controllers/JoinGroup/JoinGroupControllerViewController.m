//
//  JoinGroupControllerViewController.m
//  PhotoBunch
//
//  Created by Gorav Grover on 14/06/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import "JoinGroupControllerViewController.h"
#import "Constant.h"
#import "postCell.h"
#import "QRCodeReaderViewController.h"


@interface JoinGroupControllerViewController ()<QRCodeReaderDelegate>
@property (strong, nonatomic) IBOutlet UITextView *groupDescription;
@property (strong, nonatomic) IBOutlet UIButton *groupTypeBtn;
@property (strong, nonatomic) IBOutlet UIButton *groupStartDateBtn;
@property (strong, nonatomic) IBOutlet UIButton *groupEndDateBtn;
@property (strong, nonatomic) IBOutlet UILabel *groupStartTime;
@property (strong, nonatomic) IBOutlet UILabel *groupEndTime;
@property (strong, nonatomic) IBOutlet UIImageView *groupLogo;
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@property (weak, nonatomic) IBOutlet UILabel *groupNameTittle;
@property (strong, nonatomic) IBOutlet UITableView *postTableView;
@property (strong, nonatomic) IBOutlet UIButton *joinGroupBtn;

@end

@implementation JoinGroupControllerViewController
{
    NSMutableArray*groupPostsArray;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.groupLogo.layer.cornerRadius = 10.0f;
    groupPostsArray=[[NSMutableArray alloc]init];
}
-(void)viewDidAppear:(BOOL)animated
{
    
    [self callGetGroupDetail];
    [self callGetGroupPosts];
}
-(void)setInitials :(NSDictionary*)dict
{
    
    
    if ([[dict valueForKey:@"is_member"] integerValue]==1)
    {
        [_joinGroupBtn setTitle:@"Unjoin Group" forState:UIControlStateNormal];
    }
    else
    {
        [_joinGroupBtn setTitle:@"join Group" forState:UIControlStateNormal];

    }
    if ([dict valueForKey:@"group_image"])
    {
        if ([[dict valueForKey:@"group_image"] length]>0) {
            [_groupLogo sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"group_image"]] placeholderImage:[UIImage imageNamed:@"groupBG"] options:SDWebImageRefreshCached];
            
        }
        else
        {
            _groupLogo.image=[UIImage imageNamed:@"groupBG"];
        }
    }
    else
    {
        _groupLogo.image=[UIImage imageNamed:@"groupBG"];
        
    }
    if ([dict valueForKey:@"group_name"])
    {
        if ([[dict valueForKey:@"group_name"] length]>0) {
            
            _groupName.text=[dict valueForKey:@"group_name"];
            _groupNameTittle.text=[dict valueForKey:@"group_name"];
        }
        else
        {
            _groupName.text=@"";
            _groupNameTittle.text=@"";
        }
        
    }
    else
    {
        _groupName.text=@"";
        _groupNameTittle.text=@"";
    }
    if ([dict valueForKey:@"group_desc"])
    {
        if ([[dict valueForKey:@"group_desc"] length]>0) {
            
            _groupDescription.text=[dict valueForKey:@"group_desc"];
        }
        else
        {
            _groupName.text=@"";
        }
        
    }
    else
    {
        _groupName.text=@"";
        
    }
    
    if ([[dict valueForKey:@"privacy_type"]isEqualToString:@"1"])
    {
        [_groupTypeBtn setTitle:@"Open Group" forState:UIControlStateNormal];
    }
    else if ([[dict valueForKey:@"privacy_type"]isEqualToString:@"2"])
    {
        [_groupTypeBtn setTitle:@"Request to join." forState:UIControlStateNormal];

    }
    else if ([[dict valueForKey:@"privacy_type"]isEqualToString:@"3"])
    {
        [_groupTypeBtn setTitle:@"Password Protected." forState:UIControlStateNormal];

    }
    
    
    
    if ([dict valueForKey:@"created_on"])
    {
        if ([[dict valueForKey:@"created_on"] length]>0) {
            
            NSArray * arr = [[dict valueForKey:@"created_on"] componentsSeparatedByString:@" "];

            [_groupStartDateBtn setTitle:[arr objectAtIndex:0] forState:UIControlStateNormal];
            _groupStartTime.text=[arr objectAtIndex:1];
            
        }
        
    }
    
    if ([dict valueForKey:@"end_date"])
    {
        if ([[dict valueForKey:@"end_date"] length]>0) {
            
            NSArray * arr = [[dict valueForKey:@"end_date"] componentsSeparatedByString:@" "];
            
            [_groupEndDateBtn setTitle:[arr objectAtIndex:0] forState:UIControlStateNormal];
            _groupEndTime.text=[arr objectAtIndex:1];
            
        }
        
    }

}
-(void)callGetGroupDetail
{
    //access_token
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"group_id":_groupId

                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallToGetGroupDetail:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    _groupInfo=[resultArray valueForKey:@"data"];
                    [self setInitials :[resultArray valueForKey:@"data"]];

                    
                }
                else
                {
                    if ([[resultArray valueForKey:@"code"] integerValue]==201 ) {
                        
                        [[SingletonClass sharedInstance]showAlert:[resultArray valueForKey:@"message"] withDelegate:self withCancelTitle:@"OK" otherTitle:nil];
                        
                    }
                    else
                    {
                        [[SingletonClass sharedInstance]showAlert:kServiceFailure withDelegate:self withCancelTitle:@"OK" otherTitle:nil];
                    }

                }
            }];
            
        } failureBlock:^(BOOL succeeded, NSArray *failureArray)
         {
             
             [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                 
                 [KAppdelegate stopLoader:self.view];
                 [[SingletonClass sharedInstance]showAlert:kServiceFailure withDelegate:self withCancelTitle:@"OK" otherTitle:nil];
             }];
             
             
         }];
    }
    else
        [[SingletonClass sharedInstance]showAlert:kNetworkAlert withDelegate:self withCancelTitle:@"OK" otherTitle:nil];
    
    
}

-(void)callGetGroupPosts
{
    //access_token
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"group_id":_groupId,
                                   @"page":@"1",
                                   @"limit":@"200"
                                   
                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallToGetGroupPosts:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    groupPostsArray=[resultArray valueForKey:@"data"];

                    [_postTableView reloadData];
                }
                else
                {
                    if ([[resultArray valueForKey:@"code"] integerValue]==201 ) {
                        
                        [[SingletonClass sharedInstance]showAlert:[resultArray valueForKey:@"message"] withDelegate:self withCancelTitle:@"OK" otherTitle:nil];
                        
                    }
                    else
                    {
                        [[SingletonClass sharedInstance]showAlert:kServiceFailure withDelegate:self withCancelTitle:@"OK" otherTitle:nil];
                    }

                    
                }
            }];
            
        } failureBlock:^(BOOL succeeded, NSArray *failureArray)
         {
             
             [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                 
                 [KAppdelegate stopLoader:self.view];
                 [[SingletonClass sharedInstance]showAlert:kServiceFailure withDelegate:self withCancelTitle:@"OK" otherTitle:nil];
             }];
             
             
         }];
    }
    else
        [[SingletonClass sharedInstance]showAlert:kNetworkAlert withDelegate:self withCancelTitle:@"OK" otherTitle:nil];
    
    
}

-(void)callRequestToJoinGroup
{
    //access_token
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"group_id":_groupId,
                                   @"receiver_id":[_groupInfo valueForKey:@"user_id"]

                                   
                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallSendJoinGroupReq:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    [self.navigationController popViewControllerAnimated:YES];

                    [[SingletonClass sharedInstance]showAlert:@"Request send to group admin." withDelegate:self withCancelTitle:@"OK" otherTitle:nil];

                }
                else
                {
                    
                    if ([[resultArray valueForKey:@"code"] integerValue]==201) {
                        [[SingletonClass sharedInstance]showAlert:[resultArray valueForKey:@"message"] withDelegate:self withCancelTitle:@"OK" otherTitle:nil];

                    }
                    else
                    {
                        [[SingletonClass sharedInstance]showAlert:kServiceFailure withDelegate:self withCancelTitle:@"OK" otherTitle:nil];

                    }
                    
                }
            }];
            
        } failureBlock:^(BOOL succeeded, NSArray *failureArray)
         {
             
             [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                 
                 [KAppdelegate stopLoader:self.view];
                 [[SingletonClass sharedInstance]showAlert:kServiceFailure withDelegate:self withCancelTitle:@"OK" otherTitle:nil];
             }];
             
             
         }];
    }
    else
        [[SingletonClass sharedInstance]showAlert:kNetworkAlert withDelegate:self withCancelTitle:@"OK" otherTitle:nil];
    
    
}
-(void)callRequestToJoinGroup :(NSString*)status
{
    //access_token
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"group_id":_groupId,
                                   @"status":status
                                   
                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallToJoinOrUnJoinGroup:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {

                    
                    [self.navigationController popViewControllerAnimated:YES];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)joinGroupPressed:(id)sender
{
    
    if ([[_groupInfo valueForKey:@"is_member"]integerValue]!=1) {
    
        
        if ([[_groupInfo valueForKey:@"privacy_type"]integerValue]==3)
        {
        
            QRCodeReaderViewController *reader = [QRCodeReaderViewController new];
            reader.modalPresentationStyle = UIModalPresentationFormSheet;
            reader.delegate = self;
            
            __weak typeof (self) wSelf = self;
            [reader setCompletionWithBlock:^(NSString *resultAsString)
            {
                
                [wSelf dismissViewControllerAnimated:YES completion:^{
                    
                }];
                if ([resultAsString isEqualToString:[_groupInfo valueForKey:@"qr_code"]])
                {
                    
                    [self callRequestToJoinGroup:@"1"];
                }
                else
                {
                    UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Photobunch"  message:@"Invalid QR Code. Please try again."  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* Ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                         {
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             
                                         }];
                    
                    [alert addAction:Ok];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }
                
                
               
                
            }];
            
            [self presentViewController:reader animated:YES completion:^{
                
            }];;
            
        }
        else  if ([[_groupInfo valueForKey:@"privacy_type"]integerValue]==2)
        {
            [self callRequestToJoinGroup];

        }
        else
        {
             [self callRequestToJoinGroup:@"1"];
        }

    }
    else
    {
        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Photobunch"  message:@" Do You want to UnJoin Group?"  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* Ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                                 [self callRequestToJoinGroup:@"0"];
                                 
                             }];
        
        
        UIAlertAction* No = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                                 
                                 
                             }];
        
        [alert addAction:No];
        
        [alert addAction:Ok];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
    
    
   
}



- (void)reader:(QRCodeReaderViewController*)reader didScanResult:(NSString*)result
{
//    [self dismissViewControllerAnimated:YES completion:^{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QRCodeReader" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
   // [self.navigationController popViewControllerAnimated:YES];
    
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
}




#pragma mark
#pragma mark- UITableView
#pragma mark


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [groupPostsArray count];
    
}
- (UITableViewCell *)tableView:(UITableView *)TableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    

        static NSString *MyIdentifier = @"postCellID";
        postCell *cell = [TableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[postCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        }
        
        cell.postOwnerImage.layer.cornerRadius = cell.postOwnerImage.frame.size.height/2;
        cell.postOwnerImage.clipsToBounds = YES;
        
        NSDictionary*dict=[groupPostsArray objectAtIndex:indexPath.row];
        if ([[dict valueForKey:@"medias"]count]>0)
        {
            if ([[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_path"] length]>0)
            {
                [cell.postImage sd_setImageWithURL:[NSURL URLWithString:[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_path"]] placeholderImage:[UIImage imageNamed:@"postBack"] options:SDWebImageRefreshCached];
                
            }
            else
            {
                cell.postImage.image=[UIImage imageNamed:@"postBack"];
            }
            
        }
        else
        {
            cell.postImage.image=[UIImage imageNamed:@"postBack"];
            
        }
    
        if ([dict valueForKey:@"profile_pic"])
        {
            if ([[dict valueForKey:@"profile_pic"] length]>0) {
                [cell.postOwnerImage sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"profile_pic"]] placeholderImage:[UIImage imageNamed:@"male_Profile"] options:SDWebImageRefreshCached];
                
            }
            else
            {
                cell.postOwnerImage.image=[UIImage imageNamed:@"male_Profile"];
            }
            
        }
        else
        {
            cell.postOwnerImage.image=[UIImage imageNamed:@"male_Profile"];
            
        }
        
        
        if ([dict valueForKey:@"name"])
        {
            if ([[dict valueForKey:@"name"] length]>0) {
                
                cell.ownerName.text=[dict valueForKey:@"name"];
                
            }
            else
            {
                cell.ownerName.text=@"";
            }
            
        }
        else
        {
            cell.ownerName.text=@"";
            
        }
    if ([dict valueForKey:@"post_time"])
    {
        if ([[dict valueForKey:@"post_time"] length]>0) {
            
            cell.postTiming.text=[dict valueForKey:@"post_time"];
            
        }
        else
        {
            cell.postTiming.text=@"";
        }
        
    }
    else
    {
        cell.postTiming.text=@"";
        
    }
    
        return cell;
    
 
    
    
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

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
