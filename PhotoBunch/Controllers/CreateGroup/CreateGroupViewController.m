//
//  CreateGroupViewController.m
//  PhotoBunch
//
//  Created by Gorav Grover on 31/05/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import "CreateGroupViewController.h"
#import "SelectDateViewController.h"
#import "PrivacySettingsViewController.h"
#import "InviteFriendsViewController.h"
#import "GroupInfoViewController.h"
#import "FSActionSheet.h"
#import "CustomTextView.h"
#import "inviteFriendsGroupCell.h"
#import "Constant.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "ActionSheetDatePicker.h"
#define kOFFSET_FOR_KEYBOARD 150.0


@interface CreateGroupViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *groupLogo;
@property (strong, nonatomic) IBOutlet CustomTextView *groupDescription;
@property (strong, nonatomic) IBOutlet UIView *privacyView;
@property (strong, nonatomic) IBOutlet UIView *dateView;
@property (strong, nonatomic) IBOutlet UIButton *startDateBtn;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLbl;
@property (strong, nonatomic) IBOutlet UIButton *endDateBtn;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLbl;
@property (strong, nonatomic) IBOutlet UIView *inviteFriendView;
@property (strong, nonatomic) IBOutlet UICollectionView *inviteFriendsCollectionView;
@property (strong, nonatomic) IBOutlet UISwitch *openGroupSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *reqToJoinSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *passSwitch;
@property (strong, nonatomic) IBOutlet UITextField *groupNameTxtFld;

@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *privacyScroolView;


@end

@implementation CreateGroupViewController
{
    IBOutlet UIButton *starBtn;
    id btnClicked;
    ActionSheetDatePicker *actionSheetPicker;
    NSDate *selectedDate;
    NSMutableArray*allFriendsArray;
    NSMutableArray*inviteFriendsArray;
    NSString*passwordString;
    BOOL keyboardIsShown;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    passwordString=@"";
    allFriendsArray=[[NSMutableArray alloc]init];
    inviteFriendsArray=[[NSMutableArray alloc]init];
    [_inviteFriendsCollectionView setAllowsMultipleSelection:YES];
    

    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    self.groupNameTxtFld.leftView = paddingView;
    self.groupNameTxtFld.leftViewMode = UITextFieldViewModeAlways;
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    self.groupNameTxtFld.rightView = paddingView1;
    self.groupNameTxtFld.rightViewMode = UITextFieldViewModeAlways;
    
    [self callGetAllFriends];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
                    
                    [_inviteFriendsCollectionView reloadData];
                }
                else
                {
                    if ([[resultArray valueForKey:@"code"] integerValue]==201 ) {
                        
//                        NSDictionary *options = @{
//                                                  kCRToastTextKey : [resultArray valueForKey:@"message"],
//                                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
//                                                  kCRToastBackgroundColorKey : [UIColor redColor],
//                                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
//                                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
//                                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
//                                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
//                                                  };
//                        [CRToastManager showNotificationWithOptions:options
//                                                    completionBlock:^{
//                                                        NSLog(@"Completed");
//                                                    }];

                    }
                    else
                    {
//                        NSDictionary *options = @{
//                                                  kCRToastTextKey : kServiceFailure,
//                                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
//                                                  kCRToastBackgroundColorKey : [UIColor redColor],
//                                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
//                                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
//                                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
//                                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
//                                                  };
//                        [CRToastManager showNotificationWithOptions:options
//                                                    completionBlock:^{
//                                                        NSLog(@"Completed");
//                                                    }];

                    }
                    
                    
                }
            }];
            
        } failureBlock:^(BOOL succeeded, NSArray *failureArray)
         {
             
             [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                 
                 [KAppdelegate stopLoader:self.view];
//                 NSDictionary *options = @{
//                                           kCRToastTextKey : kServiceFailure,
//                                           kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
//                                           kCRToastBackgroundColorKey : [UIColor redColor],
//                                           kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
//                                           kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
//                                           kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
//                                           kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
//                                           };
//                 [CRToastManager showNotificationWithOptions:options
//                                             completionBlock:^{
//                                                 NSLog(@"Completed");
//                                             }];

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




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtnPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

    
}

#pragma mark - Selected Date Action
- (void)dateWasSelected:(NSDate *)selectedDate11 element:(id)element
{
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];

    UIButton *btn=(UIButton*)btnClicked;
    selectedDate = selectedDate11;
    NSDateFormatter *dateFormatterNew = [[NSDateFormatter alloc] init];
    [dateFormatterNew setLocale:enUSPOSIXLocale];

    [dateFormatterNew setDateFormat:@"dd/MM/yyyy"];
    NSString *stringForNewDate =[dateFormatterNew stringFromDate:selectedDate];
    
    [btn setTitle:stringForNewDate forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    

    if (btn==_startDateBtn)
    {
        NSDateFormatter *dateFormatterNew1 = [[NSDateFormatter alloc] init];
        [dateFormatterNew1 setLocale:enUSPOSIXLocale];

        [dateFormatterNew1 setDateFormat:@"HH:mm"];
   
        NSString *stringForNewDate1 = [dateFormatterNew1 stringFromDate:selectedDate];
        _startTimeLbl.text=stringForNewDate1;
    }
    
    
    NSTimeInterval secondsInEightHours = (24 * 60 * 60)-1;
    NSDate *dateEightHoursAhead = [selectedDate dateByAddingTimeInterval:secondsInEightHours];
    UIButton *btn1=(UIButton*)_endDateBtn;
    
    selectedDate = dateEightHoursAhead;
    NSDateFormatter *dateFormatterNew1 = [[NSDateFormatter alloc] init];
    [dateFormatterNew1 setLocale:enUSPOSIXLocale];

    [dateFormatterNew1 setDateFormat:@"dd/MM/yyyy"];
    NSString *stringForNewDate1 =[dateFormatterNew1 stringFromDate:selectedDate];
    
    
    [btn1 setTitle:stringForNewDate1 forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    

    NSDateFormatter *dateFormatterNew12 = [[NSDateFormatter alloc] init];
    [dateFormatterNew12 setDateFormat:@"HH:mm"];
    
    [dateFormatterNew12 setLocale:enUSPOSIXLocale];

    NSString *stringForNewDate11 = [dateFormatterNew12 stringFromDate:selectedDate];
    
    _endTimeLbl.text=stringForNewDate11;
    
    
}



- (IBAction)endDatePressed:(id)sender
{
   // [self.view endEditing:YES];
    
//    btnClicked = sender;
//    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"dd/MM/yyyy"];
//    NSDate *currentDate = [NSDate date];
//    actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDateAndTime selectedDate:currentDate target:self action:@selector(dateWasSelected:element:) origin:sender];
//    
//    actionSheetPicker.locale = [NSLocale localeWithLocaleIdentifier:@"en_GB"];
//    
//    actionSheetPicker.minimumDate=currentDate;
//    actionSheetPicker.hideCancel = NO;
//    [actionSheetPicker showActionSheetPicker];

}
- (IBAction)startDatePressed:(id)sender
{
    btnClicked = sender;
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSDate *currentDate = [NSDate date];
    actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDateAndTime selectedDate:currentDate target:self action:@selector(dateWasSelected:element:) origin:sender];
    
    actionSheetPicker.locale = [NSLocale localeWithLocaleIdentifier:@"en_GB"];
    
    actionSheetPicker.minimumDate=currentDate;
    actionSheetPicker.hideCancel = NO;
    [actionSheetPicker showActionSheetPicker];


}
- (IBAction)removePrivacySettings:(id)sender
{
    if ([_passSwitch isOn])
    {
        if ([_passwordField.text length]==0)
        {
            [[SingletonClass sharedInstance]showAlert:@"Please set group password." withDelegate:self withCancelTitle:@"OK" otherTitle:nil];
            return;

        }
        else
        {
            passwordString=_passwordField.text;
            [UIView transitionWithView:_privacyScroolView
                              duration:0.4
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [_privacyScroolView setHidden:YES];
                                
                            }
                            completion:NULL];

        }
        
    }
    else
    {
        [UIView transitionWithView:_privacyScroolView
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [_privacyScroolView setHidden:YES];
                            
                        }
                        completion:NULL];

    }
    
    
}
- (IBAction)removeInviteView:(id)sender
{
    [UIView transitionWithView:_inviteFriendView
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [_inviteFriendView setHidden:YES];
                        
                    }
                    completion:NULL];


}
- (IBAction)removeDateView:(id)sender
{
    [UIView transitionWithView:_dateView
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [_dateView setHidden:YES];
                        
                    }
                    completion:NULL];

}
- (IBAction)doneSelectDate:(id)sender
{
    
    [UIView transitionWithView:_dateView
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [_dateView setHidden:YES];
                        
                    }
                    completion:NULL];

}

//Switch Methods
- (IBAction)openGroupPressed:(UISwitch*)sender
{
    [sender setOn:YES];
    [_reqToJoinSwitch setOn:NO];
    [_passSwitch setOn:NO];
    [_passwordView setHidden:YES];
    _passwordField.text=@"";



}
- (IBAction)requestToJoinPressed:(UISwitch*)sender
{
    [sender setOn:YES];
    [_openGroupSwitch setOn:NO];
    [_passSwitch setOn:NO];
    [_passwordView setHidden:YES];
    _passwordField.text=@"";

}

- (IBAction)passwordPressed:(UISwitch*)sender
{
    [sender setOn:YES];
    [_reqToJoinSwitch setOn:NO];
    [_openGroupSwitch setOn:NO];
    [_passwordView setHidden:NO];
    //_passwordField.text=@"";

}

#pragma mark TextField delegates

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSInteger newLength = [textView.text length] + [text length] - range.length;
    
    if (textView==_groupDescription)
    {
        if (newLength>100)
            return NO;
    }
    
    
    return YES;
    
}
#pragma mark TextField delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}
//ADD A BRIEF DESCRIPTION

- (IBAction)addGroupLogo:(id)sender
{
    [self.view endEditing:YES];
    NSMutableArray *actionSheetItems = [@[FSActionSheetTitleWithImageItemMake(FSActionSheetTypeNormal, [UIImage imageNamed:@"camera"], @"Camera"),FSActionSheetTitleWithImageItemMake(FSActionSheetTypeNormal, [UIImage imageNamed:@"album"], @"Photo Album"),]mutableCopy];
    FSActionSheet *actionSheet = [[FSActionSheet alloc] initWithTitle:nil cancelTitle:@"Cancel" items:actionSheetItems];
    [actionSheet showWithSelectedCompletion:^(NSInteger selectedIndex)
     {
         
         UIImagePickerController *picker = [[UIImagePickerController alloc] init];
         
         picker.navigationBar.barStyle = UIBarStyleBlack; // Or whatever style.
         picker.navigationBar.tintColor = [UIColor whiteColor];
         
         picker.delegate  = self;
         picker.allowsEditing = YES;
         switch (selectedIndex) {
             case 0:
                 
                 if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                 {
                     UIAlertView*  myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     [myAlertView show];
                 }
                 else
                 {
                     
                     picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                     [self presentViewController:picker animated:YES completion:Nil];
                     
                 }
                 
                 break;
             case 1:
                 
                 picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                 
                 [self presentViewController:picker animated:YES completion:NULL];
                 
             default:
                 break;
         }
         
     }];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark IMAGE PICKER DELEGATES
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSData* data;
    
    data = UIImagePNGRepresentation(image);
    
    _groupLogo.image=image;
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}



- (IBAction)selectDatePressed:(id)sender
{
    
    [self.view endEditing:YES];

    [UIView transitionWithView:_dateView
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [_dateView setHidden:NO];
                        
                    }
                    completion:NULL];

    [self.view bringSubviewToFront:_dateView];
    
    
}
- (IBAction)privacySettingsPressed:(id)sender
{
    [self.view endEditing:YES];

    [UIView transitionWithView:_privacyScroolView
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [_privacyScroolView setHidden:NO];
                        
                    }
                    completion:NULL];

    [self.view bringSubviewToFront:_privacyScroolView];

}
- (IBAction)inviteFriendsPressed:(id)sender
{
    [self.view endEditing:YES];

    [UIView transitionWithView:_inviteFriendView
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [_inviteFriendView setHidden:NO];
                        
                    }
                    completion:NULL];
    [self.view bringSubviewToFront:_inviteFriendView];
    
}
- (IBAction)saveGroup:(id)sender
{
    if ([self signupValidations])
    {
        [self callCreateGroup];
        
    }
}

#pragma mark signup new charity
-(BOOL)signupValidations
{
    if (![_groupNameTxtFld.text isValid])
    {
        [[SingletonClass sharedInstance]showAlert:@"Please enter Group Name" withDelegate:self withCancelTitle:@"OK" otherTitle:nil];
        return NO;
    }
    if (![_groupDescription.text isValid])
    {
        [[SingletonClass sharedInstance]showAlert:@"Please enter Group description." withDelegate:self withCancelTitle:@"OK" otherTitle:nil];
        return NO;
    }
    else if ([_startDateBtn.titleLabel.text isEqualToString:@"Select date"])
    {
        [[SingletonClass sharedInstance]showAlert:@"Please Select Start date of group" withDelegate:self withCancelTitle:@"OK" otherTitle:nil];
        return NO;
    }
    else if ([_endDateBtn.titleLabel.text isEqualToString:@"Select date"])
    {
        [[SingletonClass sharedInstance]showAlert:@"Please Select End date of group" withDelegate:self withCancelTitle:@"OK" otherTitle:nil];
        return NO;
    }
    else if (_groupLogo.image ==nil || [_groupLogo.image isEqual:[UIImage imageNamed:@"cover_picBack"]])
    {
        [[SingletonClass sharedInstance]showAlert:@"Please Add Group logo." withDelegate:self withCancelTitle:@"OK" otherTitle:nil];
        return NO;
    }
    else if ([_passSwitch isOn])
    {
        if ([passwordString length]==0)
        {
            [[SingletonClass sharedInstance]showAlert:@"Please enter group password" withDelegate:self withCancelTitle:@"OK" otherTitle:nil];
            return NO;
        }
        else
        {
            return YES;
        }
        
    }
    
    
    return YES;
}


-(NSString *) randomStringWithLength: (int) len
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}

-(void)callCreateGroup
{
    //access_token
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSDate *date2 = [dateFormat dateFromString:_startDateBtn.titleLabel.text];
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    NSString* dateStr = [dateFormat stringFromDate:date2];
    
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    
    NSDate *date1 = [dateFormat dateFromString:_endDateBtn.titleLabel.text];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    NSString* dateStr1 = [dateFormat stringFromDate:date1];

    NSString*stsrtDate=[dateStr stringByAppendingString:[NSString stringWithFormat:@" %@",_startTimeLbl.text]];
    NSString*endDate=[dateStr1 stringByAppendingString:[NSString stringWithFormat:@" %@",_endTimeLbl.text]];

    NSString*groupType=@"";
    if ([_openGroupSwitch isOn])
    {
        groupType=@"1";
    }
    else if ([_reqToJoinSwitch isOn])
    {
        groupType=@"2";

    }
    else if ([_passSwitch isOn])
    {
        groupType=@"3";
    }
    
    NSString*discover=@"1";
    if (starBtn.selected) {
        discover=@"1";
    }
    else
    {
        discover=@"0";
    }
    
    NSString*qrCode=[self randomStringWithLength:10];
    NSMutableArray*idArray=[[NSMutableArray alloc]init];
    for (int i=0; i<[inviteFriendsArray count]; i++)
    {
        NSIndexPath*ip=[inviteFriendsArray objectAtIndex:i];
        [idArray addObject:[[allFriendsArray objectAtIndex:ip.row] valueForKey:@"id"]];
    }
    NSString *usersIds = [idArray componentsJoinedByString:@","];
    
    
    NSDate*date=[NSDate date];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDateFormatter *dateFormatterNew = [[NSDateFormatter alloc] init];
    [dateFormatterNew setLocale:enUSPOSIXLocale];
    [dateFormatterNew setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *stringForNewDate =[dateFormatterNew stringFromDate:date];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"group_name":_groupNameTxtFld.text,
                                   @"group_desc":_groupDescription.text,
                                   @"start_date":stsrtDate,
                                   @"end_date":endDate,
                                   @"privacy_type":groupType,
                                   @"discoverable":discover,
                                   @"invite_users":usersIds,
                                   @"password":passwordString,
                                   @"created_on":stringForNewDate

                                   };
    
    UIImage*orignalImage=[ImageCompress scaleImage:_groupLogo.image maxWidth:400 maxHeight:700];

    NSMutableDictionary*dict1=[[NSMutableDictionary alloc]init];
    [dict1 setObject:orignalImage forKey:@"profile_pic"];

    [dict1 setObject:registerInfo forKey:@"parameters"];
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCreateGroup:dict1 successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"NewCreatedGroup" object:nil];

                    GroupInfoViewController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"GroupInfoViewControllerID"];
                    tabBarController.groupInfo=[resultArray valueForKey:@"data"];
                    [self.navigationController pushViewController:tabBarController animated:YES];
                    
//                   //                    [self.navigationController popViewControllerAnimated:YES];

                    
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


#pragma mark
#pragma mark- CollectionView
#pragma mark

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [allFriendsArray count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    inviteFriendsGroupCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"inviteFriendsGroupCellID" forIndexPath:indexPath];
    NSDictionary*dict=[allFriendsArray objectAtIndex:indexPath.row];
    
    if ([dict valueForKey:@"profile_pic"])
    {
        if ([[dict valueForKey:@"profile_pic"]length]>0) {
            [cell.backImage sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"profile_pic"]] placeholderImage:[UIImage imageNamed:@"maleBack"] options:SDWebImageRefreshCached];
            
        }
        else
        {
            cell.backImage.image=[UIImage imageNamed:@"maleBack"];
        }
        
    }
    else
    {
        cell.backImage.image=[UIImage imageNamed:@"maleBack"];
        
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
    
    cell.backImage.layer.cornerRadius = cell.backImage.frame.size.height/2;
    cell.backImage.clipsToBounds = YES;
    
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    inviteFriendsGroupCell *cell = (inviteFriendsGroupCell*)[_inviteFriendsCollectionView cellForItemAtIndexPath:indexPath];

    [cell.selectedTic setHidden:NO];
    [inviteFriendsArray addObject:indexPath];
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    inviteFriendsGroupCell *cell = (inviteFriendsGroupCell*)[_inviteFriendsCollectionView cellForItemAtIndexPath:indexPath];
    
    [cell.selectedTic setHidden:YES];
    [inviteFriendsArray removeObject:indexPath];

}
- (CGSize)collectionView:(UICollectionView* )collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath* )indexPath
{
    
    return CGSizeMake(173, 165);
    
}

- (IBAction)starSelection:(UIButton *)sender
{
    
    if (sender.selected) {
        sender.selected=NO;
    }
    else
    {
        sender.selected=YES;
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
