//
//  SettingsViewController.m
//  PhotoBunch
//
//  Created by Gorav Grover on 30/05/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import "SettingsViewController.h"
#import "Constant.h"
#import "FSActionSheet.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface SettingsViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UIImageView *coverImage;
@property (strong, nonatomic) IBOutlet UITextField *nameTxtFld;
@property (strong, nonatomic) IBOutlet UIButton *editNameBtn;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTxtView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *decConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *decBackConstant;

@end

@implementation SettingsViewController
{
    IBOutlet TPKeyboardAvoidingScrollView *mainScroolView;
    NSString*isFromImagePicker;
    BOOL isProfileImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isFromImagePicker=@"NO";
    isProfileImage=YES;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [mainScroolView addGestureRecognizer:recognizer];
    
}

#pragma mark TextField delegates

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSInteger newLength = [textView.text length] + [text length] - range.length;
    
    if (textView==_descriptionTxtView)
    {
        if (newLength>50)
            return NO;
    }
    
    
    return YES;
    
}

-(void)touch
{
    [self.view endEditing:YES];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidAppear:(BOOL)animated
{
    if ([isFromImagePicker isEqualToString:@"NO"]) {
        [self callGetProfile];

    }
    isFromImagePicker=@"NO";

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



-(void)setInitials:(NSDictionary*)dict
{
    
    if ([[dict valueForKey:@"cover_image"]length]>0)
    {
        
        [_coverImage sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"cover_image"]] placeholderImage:[UIImage imageNamed:@"cover_picBack"] options:SDWebImageRefreshCached];
        
    }
    else
    {
        _coverImage.image=[UIImage imageNamed:@"postBack"];
        
    }
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
        CGSize maximumLabelSize = CGSizeMake(100, 150);
        CGSize expectedLabelSize = [[dict valueForKey:@"description"] sizeWithFont:_descriptionTxtView.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
        
        _descriptionTxtView.text=[dict valueForKey:@"description"];
        _descriptionTxtView.textColor=[UIColor blackColor];
        CGRect newFrame = _descriptionTxtView.frame;
        newFrame.size.height = expectedLabelSize.height;
        _decConstant.constant=newFrame.size.height;
        _decBackConstant.constant=_decConstant.constant+100;
        
        
    }
    else
    {
        _descriptionTxtView.text=@"";
        
    }
    
    if ([[dict valueForKey:@"name"]length]>0)
    {
        
        _nameTxtFld.text=[dict valueForKey:@"name"];
        
        
    }
    else
    {
        _nameTxtFld.text=@"";
        
    }
}

    


- (IBAction)editName:(id)sender
{
}
- (IBAction)addProfileImage:(id)sender
{
    isProfileImage=YES;

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
- (IBAction)addCoverImage:(id)sender
{
//    isProfileImage=NO;
//
//    [self.view endEditing:YES];
//    NSMutableArray *actionSheetItems = [@[FSActionSheetTitleWithImageItemMake(FSActionSheetTypeNormal, [UIImage imageNamed:@"camera"], @"Camera"),FSActionSheetTitleWithImageItemMake(FSActionSheetTypeNormal, [UIImage imageNamed:@"album"], @"Photo Album"),]mutableCopy];
//    FSActionSheet *actionSheet = [[FSActionSheet alloc] initWithTitle:nil cancelTitle:@"Cancel" items:actionSheetItems];
//    [actionSheet showWithSelectedCompletion:^(NSInteger selectedIndex)
//     {
//         
//         UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//         
//         picker.navigationBar.barStyle = UIBarStyleBlack; // Or whatever style.
//         picker.navigationBar.tintColor = [UIColor whiteColor];
//         
//         picker.delegate  = self;
//         picker.allowsEditing = YES;
//         switch (selectedIndex) {
//             case 0:
//                 
//                 if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//                 {
//                     UIAlertView*  myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                     [myAlertView show];
//                 }
//                 else
//                 {
//                     
//                     picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//                     [self presentViewController:picker animated:YES completion:Nil];
//                     
//                 }
//                 
//                 break;
//             case 1:
//                 
//                 picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                 
//                 [self presentViewController:picker animated:YES completion:NULL];
//                 
//             default:
//                 break;
//         }
//         
//         
//     }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark IMAGE PICKER DELEGATES
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    isFromImagePicker=@"YES";

    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSData* data;
    
    data = UIImagePNGRepresentation(image);
    
    if (isProfileImage)
    {
        _profileImage.image=image;

    }
    else
    {
        _coverImage.image=image;

    }
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (IBAction)backBtnPressed:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)saveChagesBtn:(id)sender
{
    [self callUpdateProfile];
    
}


-(void)callUpdateProfile
{
    
    NSMutableDictionary*registerInfo=[[NSMutableDictionary alloc]init];
    [registerInfo setValue:[UserDefaultHandler getUserAccessToken] forKey:@"access_token"];
    [registerInfo setValue:_nameTxtFld.text forKey:@"name"];
   [registerInfo setValue:_descriptionTxtView.text forKey:@"description"];

    NSMutableDictionary*dict1=[[NSMutableDictionary alloc]init];
    [dict1 setObject:_profileImage.image forKey:@"profile_pic"];
  //  [dict1 setObject:_coverImage.image forKey:@"cover_pic"];
    [dict1 setObject:registerInfo forKey:@"parameters"];
    NSLog(@"dd%@",dict1);

    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallUpdateProfile:dict1 successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    NSDictionary *options = @{
                                              kCRToastTextKey :@"Profile Updated.",
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
                    if ([[resultArray valueForKey:@"code"] integerValue]==201 ) {
                        
                        NSDictionary *options = @{
                                                  kCRToastTextKey :[resultArray valueForKey:@"message"],
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
                                                  kCRToastTextKey :kServiceFailure,
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
                                           kCRToastTextKey :kServiceFailure,
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
                                  kCRToastTextKey :kNetworkAlert,
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








- (IBAction)logOutPressed:(id)sender {
    UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Photobunch"  message:@"Are you sure to logout?"  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* Ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             [self callLogout];
                             
                         }];
    
    
    UIAlertAction* No = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                             
                             
                         }];
    
    [alert addAction:No];
    
    [alert addAction:Ok];
    
    [self presentViewController:alert animated:YES completion:nil];

    
}


-(void)callLogout
{
    //access_token
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   
                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallLogOut:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    
                    NSDictionary*dict=[UserDefaultHandler getUserInfo];
                    
                    if ([[dict valueForKey:@"login_type"]isEqualToString:@"Facebook"])
                    {
                        [FBSDKAccessToken setCurrentAccessToken:nil];
                    }
                    else
                    {
                        [[GIDSignIn sharedInstance] signOut];
                    }
                    
                    
                                       
                    [UserDefaultHandler removeAccessToken];
                    [UserDefaultHandler removeUserInfo];

                    UINavigationController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavID"];
                    [KAppdelegate.window setRootViewController:tabBarController];
                    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
