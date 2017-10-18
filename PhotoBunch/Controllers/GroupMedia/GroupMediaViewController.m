//
//  GroupMediaViewController.m
//  PhotoBunch
//
//  Created by Gorav Grover on 28/06/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import "GroupMediaViewController.h"
#import "groupMediaCollectionCell.h"
#import "Constant.h"
#import "YBPopupMenu.h"
#import "FTPopOverMenu.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <AddressBook/AddressBook.h>
#import <Twitter/Twitter.h>

@interface GroupMediaViewController ()<UIDocumentInteractionControllerDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *mediaCollectionView;
@property (strong, nonatomic) IBOutlet UILabel *tittle;
@property (strong, nonatomic) IBOutlet UIView *qrCodeView;
@property (strong, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (strong, nonatomic) IBOutlet UIButton *groupQrCodeBtn;
@property (strong, nonatomic) UIImage *codeImage;
@property(nonatomic,retain) UIDocumentInteractionController *documentationInteractionController;
@property (weak, nonatomic) IBOutlet UIButton *reportGroupBtn;

@end

@implementation GroupMediaViewController
{
    __weak IBOutlet UIButton *deletemembersbtn;
    __weak IBOutlet UIButton *removePopUpbtn;
    IBOutlet UIImageView *emptyImage;
    NSMutableArray*groupPostsArray;
    IBOutlet UIView *groupInfoView;
    
    __weak IBOutlet UILabel *privateMediaLbl;
    IBOutlet UIView *groupInfoBackView;
    
    IBOutlet UIButton *joinBtn;
    IBOutlet UIImageView *groupLogo;
    IBOutlet UILabel *groupName;
    IBOutlet UILabel *groupDescription;
    NSMutableDictionary*groupInfo;
    __weak IBOutlet UILabel *groupMembersLbl;
    
    __weak IBOutlet NSLayoutConstraint *discriptionConstant;
    __weak IBOutlet UILabel *membersCount;
    __weak IBOutlet UILabel *timrLbl;
    
    __weak IBOutlet UIButton *activatedBtn;
    NSMutableArray*groupMembers;
    DropDownListView * Dropobj;
    NSMutableArray* listItems;
    NSString*isprivate;
    __weak IBOutlet UIButton *startDateBtn;

    __weak IBOutlet UIButton *endDateBtn;
    
    __weak IBOutlet UILabel *startTimeLbl;
    __weak IBOutlet UILabel *endTime;
    
    BOOL isReload;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_mediaCollectionView setHidden:YES];
    isprivate=@"YES";
    [emptyImage setHidden:YES];
    groupMembers=[[NSMutableArray alloc]init];
    
    if ([_PopUpStringID isEqualToString:@"0"])
    {
        groupInfoBackView.hidden=NO;
    }
    else{
          groupInfoBackView.hidden=YES;
    }
    
    groupInfoBackView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.9];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapRecognizer addTarget:self action:@selector(bigButtonTapped1:)];
    [groupLogo addGestureRecognizer:tapRecognizer];

    [_mediaCollectionView setHidden:YES];
    [self callGetGroupPosts];
    isReload=YES;

    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    if (isReload) {
        [self callGetGroupDetail];

    }
    isReload=YES;

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)removeGroupInfoView:(id)sender
{
    if ([_PopUpStringID isEqualToString:@"0"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
    [groupInfoBackView setHidden:YES];
    }

    
}
- (IBAction)membersPressed:(UIButton*)sender
{
    
    NSMutableArray* listItems1 = [[NSMutableArray alloc]init];
    
    for (int i=0; i<[groupMembers count]; i++)
    {
        NSDictionary*dict=[groupMembers objectAtIndex:i];
        [listItems1 addObject:[dict valueForKey:@"name"]];
        
    }
    
    [YBPopupMenu showRelyOnView:sender titles:listItems1 icons:nil menuWidth:150 otherSettings:^(YBPopupMenu *popupMenu) {
        

        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionLeft;
        popupMenu.borderWidth = 1;
        popupMenu.borderColor = [UIColor blackColor];
        popupMenu.delegate=self;
        
    }];


}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    
    
}

- (IBAction)joinGroupPressed:(id)sender
{
    
    if ([[groupInfo valueForKey:@"user_id"] integerValue]==[[[UserDefaultHandler getFullInfo] valueForKey:@"id"]integerValue])
    {
        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Photobunch"  message:@"Do you want to Delete the group?"  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* Ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                                 [self callDeleteGroup];
                                 
                             }];
        
        
        UIAlertAction* No = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                                 
                             }];
        
        [alert addAction:No];
        
        [alert addAction:Ok];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
    else
    {
        if ([[groupInfo valueForKey:@"is_member"]integerValue]!=1) {
            
            
            if ([[groupInfo valueForKey:@"privacy_type"]integerValue]==3)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter Password" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"Enter password";
                    textField.secureTextEntry = YES;
                }];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                {
                    NSLog(@"Current password %@", [[alertController textFields][0] text]);
                    //compare the current password and do action here
                    
                    if ([[[alertController textFields][0] text] isEqualToString:[groupInfo valueForKey:@"password"]])
                    {
                        
                        [self callRequestToJoinGroup:@"1"];
                        [alertController dismissViewControllerAnimated:YES completion:nil];

                    }
                    else
                    {
                        NSDictionary *options = @{
                                                  kCRToastTextKey : @"Wrong Password",
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
                [alertController addAction:confirmAction];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"Canelled");
                    [alertController dismissViewControllerAnimated:YES completion:nil];

                }];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];

                
            }
            else  if ([[groupInfo valueForKey:@"privacy_type"]integerValue]==2)
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
            UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Photobunch"  message:@"Do you want to leave the group?"  preferredStyle:UIAlertControllerStyleAlert];
            
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
    
    
}
-(void)callRequestToJoinGroup
{
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"group_id":_groupID,
                                   @"receiver_id":[groupInfo valueForKey:@"user_id"]
                                   
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
                    
                    NSDictionary *options = @{
                                              kCRToastTextKey :@"Request sent to group admin",
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
                    
                    if ([[resultArray valueForKey:@"code"] integerValue]==201) {
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

#pragma call geetil
-(void)callRequestToJoinGroup :(NSString*)status
{
    //access_token
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"group_id":_groupID,
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
                    if ([status isEqualToString:@"0"])
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"LeaveGroup" object:self userInfo:nil];

                    }
                    else if([status isEqualToString:@"1"])
                    {
                       // [self callGetGroupDetail];
                        [_delegate joinGroupNotification];
                    }
                    
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


-(void)callDeleteGroup
{
    
    //access_token
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"group_id":_groupID
                                   };
    NSLog(@"delete_group >> %@",registerInfo);
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallToDeleteGroup:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteGroup" object:self userInfo:nil];

                    [self.navigationController popViewControllerAnimated:YES];

                    
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


-(void)callGetGroupDetail
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
                                   @"group_id":_groupID,
                                   @"device_time":stringForNewDate
                                   
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
                    groupInfo=[resultArray valueForKey:@"data"];
                    
                    if ([[groupInfo valueForKey:@"members_count"] integerValue]>0)
                    {
                        groupMembers=[groupInfo valueForKey:@"group_members"];

                    }
                    
                    [self setInitials :[resultArray valueForKey:@"data"]];
                    
                    
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
             }];
             
             
         }];
    }
    else
    {
        
    }
    
    
}

-(void)setInitials :(NSDictionary*)dict
{
    
    BOOL flag;
    {
        if ([[dict valueForKey:@"user_id"] integerValue]==[[[UserDefaultHandler getFullInfo] valueForKey:@"id"]integerValue])
        {
            flag=true;
            isprivate=@"NO";
          
        }
        else if ([[dict valueForKey:@"is_member"] integerValue]==1)
        {
            flag=true;
            isprivate=@"NO";

        }
        else
        {
            flag=false;
            isprivate=@"YES";

        }
        
    }
    if (flag)
    {
        [_mediaCollectionView setHidden:NO];
        [privateMediaLbl setHidden:YES];
        

    }
    else
    {
        [_mediaCollectionView setHidden:YES];
        
        [privateMediaLbl setHidden:NO];
        [emptyImage setHidden:YES];
        
    }
    
    
    if ([[dict valueForKey:@"user_id"] integerValue]==[[[UserDefaultHandler getFullInfo] valueForKey:@"id"]integerValue])
    {
        
        [_groupQrCodeBtn setHidden:NO];
        if ([dict valueForKey:@"qr_image"])
        {
            if ([[dict valueForKey:@"qr_image"] length]>0)
            {
                
                
                [_groupQrCodeBtn sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"qr_image"]] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    
                    _codeImage=image;
                    _qrCodeImageView.image=image;
                    
                    
                    NSData *pngData = UIImagePNGRepresentation(image);
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
                    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"codeimage.png"]; //Add the file name
                    [pngData writeToFile:filePath atomically:YES];
                    
                }];
                
            }
            
        }
        [_reportGroupBtn setHidden:YES];

        [deletemembersbtn setHidden:NO];
        [joinBtn setTitle:@"Delete group" forState:UIControlStateNormal];
        if ([[dict valueForKey:@"group_status"]isEqualToString:@"Activated"])
        {
            activatedBtn.enabled=NO;

            [activatedBtn setTitle:@"Active" forState:UIControlStateNormal];
            
            [activatedBtn setBackgroundColor:rGBColor(64, 128, 0)];
        }
        else
        {
            activatedBtn.enabled=YES;

            [activatedBtn setTitle:@"Reactivate" forState:UIControlStateNormal];
            
            [activatedBtn setBackgroundColor:rGBColor(255, 0, 0)];
            
        }
        
    }
    else
    {
        [deletemembersbtn setHidden:YES];
        [_reportGroupBtn setHidden:NO];

        activatedBtn.enabled=NO;

        if ([[dict valueForKey:@"group_status"]isEqualToString:@"Activated"])
        {
            [activatedBtn setTitle:@"Active" forState:UIControlStateNormal];
            [activatedBtn setBackgroundColor:rGBColor(64, 128, 0)];

        }
        else
        {
            [activatedBtn setTitle:@"Inactive" forState:UIControlStateNormal];
            [activatedBtn setBackgroundColor:rGBColor(255, 0, 0)];

            
        }


        if ([[dict valueForKey:@"is_member"] integerValue]==1)
        {
            [joinBtn setTitle:@"Leave group" forState:UIControlStateNormal];
        }
        else
        {
            [joinBtn setTitle:@"Join Group" forState:UIControlStateNormal];
            
        }
    }
    
    if ([dict valueForKey:@"group_image"])
    {
        if ([[dict valueForKey:@"group_image"] length]>0) {
            [groupLogo sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"group_image"]] placeholderImage:[UIImage imageNamed:@"groupSmallBack"] options:SDWebImageRefreshCached];
            
        }
        else
        {
            groupLogo.image=[UIImage imageNamed:@"groupSmallBack"];
        }
    }
    else
    {
        groupLogo.image=[UIImage imageNamed:@"groupSmallBack"];
        
    }
    if ([dict valueForKey:@"group_name"])
    {
        if ([[dict valueForKey:@"group_name"] length]>0) {
            
            groupName.text=[dict valueForKey:@"group_name"];
        }
        else
        {
            groupName.text=@"";
        }
        
    }
    else
    {
        groupName.text=@"";

    }
    if ([dict valueForKey:@"group_desc"])
    {
        if ([[dict valueForKey:@"group_desc"] length]>0) {
            
            groupDescription.text=[dict valueForKey:@"group_desc"];
        }
        else
        {
            groupDescription.text=@"";
        }
        
    }
    else
    {
        groupDescription.text=@"";
        
    }
    
    
    
    if ([dict valueForKey:@"members_count"])
    {
        if ([[dict valueForKey:@"privacy_type"]integerValue ]==1)
        {
            groupMembersLbl.text=[NSString stringWithFormat:@"Open Group : %@ Members",[dict valueForKey:@"members_count"]];

            
        }
        else if ([[dict valueForKey:@"privacy_type"]integerValue ]==2)
        {
            
            groupMembersLbl.text=[NSString stringWithFormat:@"Request To join group : %@ Members",[dict valueForKey:@"members_count"]];

        }
        else if ([[dict valueForKey:@"privacy_type"]integerValue ]==3)
        {
            
            groupMembersLbl.text=[NSString stringWithFormat:@"Password Protected Group : %@ Members",[dict valueForKey:@"members_count"]];

        }
        
    }
    else
    {
         groupMembersLbl.text=@"";
    }

    
    if ([dict valueForKey:@"start_date"])
    {
        if ([[dict valueForKey:@"start_date"] length]>0) {
            
            NSArray * arr = [[dict valueForKey:@"start_date"] componentsSeparatedByString:@" "];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy/MM/dd"];
            NSDate *date = [dateFormat dateFromString:[arr objectAtIndex:0]];
            
            // Convert date object to desired output format
            [dateFormat setDateFormat:@"dd/MM/yyyy"];
            NSString* dateStr = [dateFormat stringFromDate:date];
            
            [startDateBtn setTitle:dateStr forState:UIControlStateNormal];
            
            startTimeLbl.text=[arr objectAtIndex:1];
            
        }
        
    }
    
    if ([dict valueForKey:@"end_date"])
    {
        if ([[dict valueForKey:@"end_date"] length]>0) {
            
            NSArray * arr = [[dict valueForKey:@"end_date"] componentsSeparatedByString:@" "];
            
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy/MM/dd"];
            NSDate *date = [dateFormat dateFromString:[arr objectAtIndex:0]];
            
            // Convert date object to desired output format
            [dateFormat setDateFormat:@"dd/MM/yyyy"];
            NSString* dateStr = [dateFormat stringFromDate:date];

            
            
            [endDateBtn setTitle:dateStr forState:UIControlStateNormal];
            endTime.text=[arr objectAtIndex:1];
            
        }
    }

}



-(void)callGetGroupPosts
{
    //access_token
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"group_id":_groupID,
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
                    if ([isprivate isEqualToString:@"YES"])
                    {
                        
                        [_mediaCollectionView setHidden:YES];

                    }
                    else
                    {
                        
                        [_mediaCollectionView setHidden:NO];

                    }
                    
                    
                    [emptyImage setHidden:YES];
                    groupPostsArray=[resultArray valueForKey:@"data"];
                    [_mediaCollectionView reloadData];
                    
                }
                else
                {
                    if ([[resultArray valueForKey:@"code"] integerValue]==201 ) {
                        
                        if ([isprivate isEqualToString:@"YES"])
                        {
                            
                        }
                        else
                        {
                            [emptyImage setHidden:NO];
                        }

                        [_mediaCollectionView setHidden:YES];
                        
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


#pragma mark
#pragma mark- Zoom Image
#pragma mark

- (void)bigButtonTapped1:(UITapGestureRecognizer*)sender
{
    isReload=NO;

    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    UIImageView*imageV=(UIImageView*)sender.view;
    imageInfo.image =imageV.image;
    
    imageInfo.referenceRect = imageV.frame;
    
    imageInfo.referenceView = imageV.superview;
    imageInfo.referenceContentMode = imageV.contentMode;
    imageInfo.referenceCornerRadius = imageV.layer.cornerRadius;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc] initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];

}
- (void)bigButtonTapped:(UITapGestureRecognizer*)sender
{
    
    
    // }
    
    isReload=NO;

    
    
    if ([[groupInfo valueForKey:@"user_id"] integerValue]==[[[UserDefaultHandler getFullInfo] valueForKey:@"id"]integerValue])
    {
        
        [FTPopOverMenuConfiguration defaultConfiguration ].menuWidth=150;
        [FTPopOverMenu showForSender:sender.view
                            withMenu:@[@"View Media",@"Delete Media"]
                      imageNameArray:nil
                           doneBlock:^(NSInteger selectedIndex)
         {
             if (selectedIndex==0)
             {
                 // Create image info
                 JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
                 UIImageView*imageV=(UIImageView*)sender.view;
                 imageInfo.image =imageV.image;
                 
                 imageInfo.referenceRect = imageV.frame;
                 
                 imageInfo.referenceView = imageV.superview;
                 imageInfo.referenceContentMode = imageV.contentMode;
                 imageInfo.referenceCornerRadius = imageV.layer.cornerRadius;
                 
                 // Setup view controller
                 JTSImageViewController *imageViewer = [[JTSImageViewController alloc] initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
                 
                 // Present the view controller.
                 [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
                 
                 
             }
             else if (selectedIndex==1)
             {
                 UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@""  message:@"Are you sure you want to Delete Media Post?"  preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* Yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                     
                     [alert dismissViewControllerAnimated:YES completion:nil];
                     
                     [self callDeletePost:[[groupPostsArray objectAtIndex:sender.view.tag]valueForKey:@"id"]];
                     
                     
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
    else
    {
        UIImageView*seletedImage;
        
        seletedImage=(UIImageView*)sender.view;
        
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
 
    }
    
    
}


-(void)callDeletePost :(NSString*)postID
{
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"post_id":postID,
                                   @"group_id":[groupInfo valueForKey:@"id"]

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
                    [self callGetGroupPosts];

                    //[self callGetProfilePosts];
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


- (IBAction)backBtnPresed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)infoBtnPressed:(id)sender
{
    [groupInfoBackView setHidden:NO];
    
}
- (IBAction)mediaBtnPressed:(UIButton*)sender
{
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [groupPostsArray count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    groupMediaCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"groupMediaCollectionCellID" forIndexPath:indexPath];
    cell.mediaImage.tag=indexPath.item;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapRecognizer addTarget:self action:@selector(bigButtonTapped:)];
    [cell.mediaImage addGestureRecognizer:tapRecognizer];
    NSDictionary*dict=[groupPostsArray objectAtIndex:indexPath.row];
    if ([[dict valueForKey:@"medias"]count]>0)
    {
        if ([[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_path"] length]>0)
        {
            [cell.mediaImage sd_setImageWithURL:[NSURL URLWithString:[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_thumb"]] placeholderImage:[UIImage imageNamed:@"postBackSmall"] options:SDWebImageRefreshCached];

        }
        else
        {
            cell.mediaImage.image=[UIImage imageNamed:@"postBackSmall"] ;
        }
        
    }
    else
    {
        cell.mediaImage.image=[UIImage imageNamed:@"postBackSmall"] ;
        
    }
    
    return cell;
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //    return UIEdgeInsetsMake(50, 20, 50, 20);
    return UIEdgeInsetsMake(5,5,5, 5);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (IBAction)activateGroupPressed:(UIButton*)sender
{
    
    UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Photobunch"  message:@"Do you want to Re-Activate the group?"  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* Ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                             [self callReactivateGroup];
                             
                         }];
    
    
    UIAlertAction* No = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                             
                             
                         }];
    
    [alert addAction:No];
    
    [alert addAction:Ok];
    
    [self presentViewController:alert animated:YES completion:nil];

}
-(void)callReactivateGroup
{
    
    NSDateFormatter *dateFormatterNew = [[NSDateFormatter alloc] init];
    [dateFormatterNew setLocale:[NSLocale localeWithLocaleIdentifier:@"en_GB"]];
    [dateFormatterNew setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *stringForNewDate =[dateFormatterNew stringFromDate:[NSDate date]];
    
    NSTimeInterval secondsInEightHours = (24 * 60 * 60)-1;
    NSDate *dateEightHoursAhead = [[NSDate date] dateByAddingTimeInterval:secondsInEightHours];
    
    NSDateFormatter *dateFormatterNew1 = [[NSDateFormatter alloc] init];
    [dateFormatterNew1 setLocale:[NSLocale localeWithLocaleIdentifier:@"en_GB"]];
    [dateFormatterNew1 setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *stringForNewDate1 =[dateFormatterNew1 stringFromDate:dateEightHoursAhead];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"group_id":_groupID,
                                   @"start_date":stringForNewDate,
                                   @"end_date":stringForNewDate1

                                   };
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallReactivateGroup:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteGroup" object:self userInfo:nil];
                    NSDictionary *options = @{
                                              kCRToastTextKey :@"Group Reactivated.",
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

                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                else
                {
                    
                    if ([[resultArray valueForKey:@"code"] integerValue]==201) {
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}


-(void)deleteGroupMembers :(NSString*)mambersIds
{
    if ([mambersIds length]!=0) {
        NSDictionary* registerInfo = @{
                                       @"access_token":[UserDefaultHandler getUserAccessToken],
                                       @"group_id":_groupID,
                                       @"member_ids":mambersIds,
                                       
                                       };
        
        NSLog(@"deletemember>> %@",registerInfo);
        if ([KAppdelegate hasInternetConnection])
        {
            
            [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
            
            [KSharedParsing wsCallToDeleteGroupMemberFromGroup:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
                
                [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                    
                    [KAppdelegate stopLoader:self.view];
                    
                    if ([[resultArray valueForKey:@"result"] integerValue]==1)
                    {
                        [self callGetGroupDetail];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"NewCreatedGroup" object:nil];

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
    
    
    
}
- (IBAction)reportGroup:(UIButton*)sender
{
    [FTPopOverMenuConfiguration defaultConfiguration ].menuWidth=220;
    [FTPopOverMenu showForSender:sender
                        withMenu:@[@"Report Spam",@"Leave Group",@"Block User"]
                  imageNameArray:nil
                       doneBlock:^(NSInteger selectedIndex)
     {
         if (selectedIndex==0)
         {
             // Create image info
             [self callReportSpam:@"Offensive Content"];
             
         }
         else if (selectedIndex==1)
         {
             UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Photobunch"  message:@"Do you want to leave the group?"  preferredStyle:UIAlertControllerStyleAlert];
             
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
         else if (selectedIndex==2)
         {
             UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Photobunch"  message:@"Do you want to block the group admin?"  preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* Ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                  {
                                      
                                      [alert dismissViewControllerAnimated:YES completion:nil];
                                      
                                      [self calBlockUser];
                                      
                                  }];
             
             
             UIAlertAction* No = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                  {
                                      
                                      [alert dismissViewControllerAnimated:YES completion:nil];
                                      
                                      
                                      
                                  }];
             
             [alert addAction:No];
             
             [alert addAction:Ok];
             
             [self presentViewController:alert animated:YES completion:nil];
             
         }

         
     } dismissBlock:^{
         
         NSLog(@"user canceled. do nothing.");
         
     }];
    
    
}

-(void)calBlockUser
{
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"user_id":[groupInfo valueForKey:@"user_id"],
                                   @"action":@"block",
                                   
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
                                              kCRToastTextKey : @"User Block Successfully",
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
                    
                    [self.navigationController popViewControllerAnimated:YES];

                    
                    
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


-(void)callReportSpam :(NSString*)reportType
{
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"post_id":_groupID,
                                   @"reason":reportType,
                                   @"report_type":@"group",
                                   
                                   };
    
    // Parameters: access_token, post_id, reason, report_type
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallReportSpam:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [KAppdelegate stopLoader:self.view];
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    
                    NSDictionary *options = @{
                                              kCRToastTextKey : @"Content successfully reported.",
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


- (IBAction)deleteMembers:(UIButton*)sender
{
    listItems=nil;
    listItems = [[NSMutableArray alloc]init];
    
    for (int i=0; i<[groupMembers count]; i++)
    {
        if ([[groupInfo valueForKey:@"user_id"] integerValue]!=[[[groupMembers objectAtIndex:i]valueForKey:@"id"] integerValue])
        {
            NSDictionary*dict=[groupMembers objectAtIndex:i];
            [listItems addObject:[dict valueForKey:@"name"]];
        }
       
        
    }
    [Dropobj fadeOut];
    [self showPopUpWithTitle:@"Select members to delete." withOption:listItems xy:CGPointMake(16, 58) size:CGSizeMake(287, 330) isMultiple:YES];
}


-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{
    
    
    Dropobj = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    Dropobj.delegate = self;
    [Dropobj showInView:self.view animated:YES];
    
    /*----------------Set DropDown backGroundColor-----------------*/
    [Dropobj SetBackGroundDropDown_R:0.0 G:108.0 B:194.0 alpha:0.70];
    
}
- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex
{
    
    
    
}
- (void)DropDownListView:(DropDownListView *)dropdownListView Datalist:(NSMutableArray*)ArryData
{
    NSMutableArray*arr=[[NSMutableArray alloc]init];
    for (int i=0; i<ArryData.count; i++)
    {
        NSString*str=[ArryData objectAtIndex:i];
        
        NSInteger anIndex=[listItems indexOfObject:str];
        
        if(NSNotFound != anIndex)
        {
            NSDictionary*dict=[groupMembers objectAtIndex:anIndex];
            [arr addObject:[dict valueForKey:@"id"]];

            
        }
    }
    NSString *joinedComponents = [arr componentsJoinedByString:@","];
    

    [self deleteGroupMembers:joinedComponents];
    
    
}
- (void)DropDownListViewDidCancel{
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[UIView class]]) {
        [Dropobj fadeOut];
    }
}


-(CGSize)GetHeightDyanamic:(UILabel*)lbl
{
    NSRange range = NSMakeRange(0, [lbl.text length]);
    CGSize constraint;
    constraint= CGSizeMake(288 ,MAXFLOAT);
    CGSize size;
    
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)) {
        NSDictionary *attributes = [lbl.attributedText attributesAtIndex:0 effectiveRange:&range];
        CGSize boundingBox = [lbl.text boundingRectWithSize:constraint options: NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    }
    else{
        
        
        size = [lbl.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    }
    return size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)removeScanQrCodeView:(id)sender {
    
    [UIView transitionWithView:_qrCodeView
                      duration:0.8
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [_qrCodeView setHidden:YES];
                    }
                    completion:NULL];
    
}
- (IBAction)openQRCodePressed:(id)sender {
    
    [self.view bringSubviewToFront:_qrCodeView];
    [UIView transitionWithView:_qrCodeView
                      duration:0.8
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [_qrCodeView setHidden:NO];
                    }
                    completion:NULL];
    
    
}


- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"returned back to app from facebook post");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Posted!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    NSLog(@"canceled!");
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"sharing error:%@", error);
    NSString *message = @"There was a problem sharing. Please try again!";
    [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (IBAction)faceBookBtnPressed:(id)sender
{
    SLComposeViewController *faceBook=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [faceBook addImage:_codeImage];
    [faceBook setInitialText:[NSString stringWithFormat:@"Hey join %@ Group by scanning the this code.",[groupInfo valueForKey:@"group_name"]]];
    
    faceBook.completionHandler = ^(SLComposeViewControllerResult result) {
        switch(result)
        {
                //  This means the user cancelled without sending the Tweet
            case SLComposeViewControllerResultCancelled:
            {
                UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Photobunch"  message:@"Tweet Canceled"  preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
                
                [alert addAction:ok];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
                
                break;
                //  This means the user hit 'Send'
            case SLComposeViewControllerResultDone:
                
            {
                UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Photobunch"  message:@"Tweet Posted."  preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                     {
                                         
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
                [alert addAction:ok];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
                
                break;
        }
    };
    
    [self presentViewController:faceBook animated:YES completion:^{
        
        NSLog(@"Hello");
        
    }];
    
    
    
    
}
- (IBAction)twitterPressed:(id)sender {
    
    SLComposeViewController *tweeter=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    tweeter.completionHandler = ^(SLComposeViewControllerResult result)
    {
        switch(result) {
                //  This means the user cancelled without sending the Tweet
            case SLComposeViewControllerResultCancelled:
            {
                UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Photobunch"  message:@"Tweet Canceled"  preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                     {
                                         
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
                [alert addAction:ok];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
                
                break;
                //  This means the user hit 'Send'
            case SLComposeViewControllerResultDone:
                
            {
                UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Photobunch"  message:@"Tweet Posted."  preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                     {
                                         
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
                [alert addAction:ok];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
                
                break;
        }
    };
    
    
    [tweeter addImage:_codeImage];
    [tweeter setInitialText:[NSString stringWithFormat:@"Hey join %@ Group by scanning the this code.",[groupInfo valueForKey:@"group_name"]]];
    [self presentViewController:tweeter animated:YES completion:^{
        
        
    }];
    
    
}
- (IBAction)instaGramPressed:(id)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"codeimage.png"]; //here i am fetched image path from document directory and convert it in to URL and use bellow
    
    
    NSURL *imageFileURL =[NSURL fileURLWithPath:getImagePath];
    NSLog(@"imag %@",imageFileURL);
    
    self.documentationInteractionController.delegate = self;
    self.documentationInteractionController.UTI = @"com.instagram.photo";
    self.documentationInteractionController = [self setupControllerWithURL:imageFileURL usingDelegate:self];
    [self.documentationInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    
    
}
- (IBAction)callBtnPressed:(id)sender {
    
    //    NSString * msg = @"whatsapp://send?text=Download and follow me on the City Local Life app! Here are the links :-\niOS :-https://itunes.apple.com/us/app/city-local-life/id986724674?ls=1&mt=8\nAndroid :-https://play.google.com/store/apps/details?id=com.mindbowser.citylocallife&hl=en";
    //
    //    //  NSString * msg = @"whatsapp://send?text=Download and follow me on the City Local Life app! Here are the links ";
    //
    //    NSString* webStringURL = [msg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //
    //    NSURL *whatsappURL = [NSURL URLWithString:webStringURL];
    //
    //    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
    //        //WhatsApp is installed in your device and you can use it.
    //        [[UIApplication sharedApplication] openURL: whatsappURL];
    //
    //    } else {
    //        //WhatsApp is not installed or is not available
    //    }
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"codeimage.png"]; //here i am fetched image path from document directory and convert it in to URL and use bellow
    
    
    NSURL *imageFileURL =[NSURL fileURLWithPath:getImagePath];
    NSLog(@"imag %@",imageFileURL);
    
    self.documentationInteractionController.delegate = self;
    self.documentationInteractionController.UTI = @"net.whatsapp.image";
    self.documentationInteractionController = [self setupControllerWithURL:imageFileURL usingDelegate:self];
    [self.documentationInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    
    
}


- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    
    self.documentationInteractionController =
    
    [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    
    self.documentationInteractionController.delegate = interactionDelegate;
    
    return self.documentationInteractionController;
    
}


@end
