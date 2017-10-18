//
//  SignUpViewController.m
//  PhotoBunch
//
//  Created by Gorav Grover on 30/05/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import "SignUpViewController.h"
#import "MainTabController.h"
#import "Constant.h"
#import "SYTabBarController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Constant.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import "Constant.h"
#import <SafariServices/SafariServices.h>


@interface SignUpViewController ()<GIDSignInUIDelegate,GIDSignInDelegate,SFSafariViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *chekBtn;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;

}
- (IBAction)acceptTerms:(UIButton*)sender
{
    
    if (sender.selected) {
        
        sender.selected=NO;
    }
    else
    {
        sender.selected=YES;

    }
}
- (IBAction)termsconditions:(id)sender
{
    NSURL*url=[NSURL URLWithString:@"https://photobunch121.com/terms"];
    
    
    if ([SFSafariViewController class] != nil)
    {
        // Use SFSafariViewController
        SFSafariViewController *svc = [[SFSafariViewController alloc] initWithURL:url];
        svc.delegate = self;
        [self presentViewController:svc animated:YES completion:nil];

    }
    else
    {
        
        if (![[UIApplication sharedApplication] openURL:url]) {
            NSLog(@"%@%@",@"Failed to open url:",[url description]);
        }
        
    }
    
    
    
    
}
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)fbBtnClickked:(id)sender
{
    
//    NSString*deviceToken=[UserDefaultHandler getDeviceToken];
//                                if (deviceToken==nil)
//                                {
//                                    deviceToken=@"12345";
//                                }
//
//    NSDictionary* registerInfo = @{
//                                   @"email":@"gorav2@yopmail.com",
//                                   @"login_type":@"Facebook",
//                                   @"device_token":deviceToken,
//                                   @"device_type":@"iPhone",
//                                   @"name":@"gorav2",
//                                   @"user_profile":@"https://scontent.xx.fbcdn.net/v/t1.0-1/p200x200/14470502_131335120662304_1030426235919563755_n.jpg?oh=901d60db0496850957ec3ac5dbba41b5&oe=59C753AB"
//                                   
//                                   };
//    
//    [self callForAddUser:registerInfo];

    

//    NSString*deviceToken=[UserDefaultHandler getDeviceToken];
//    if (deviceToken==nil)
//    {
//        deviceToken=@"12345";
//    }
//    
//    NSDictionary* registerInfo = @{
//                                   @"email":@"gorav10@yopmail.com",
//                                   @"login_type":@"Facebook",
//                                   @"device_token":deviceToken,
//                                   @"device_type":@"iPhone",
//                                   @"name":@"gorav10",
//                                   @"user_profile":@"https://scontent.xx.fbcdn.net/v/t1.0-1/p200x200/14470502_131335120662304_1030426235919563755_n.jpg?oh=901d60db0496850957ec3ac5dbba41b5&oe=59C753AB"
//                                   
//                                   };
//    
//    [self callForAddUser:registerInfo];
//
    
    if (_chekBtn.selected) {
        if ([KAppdelegate hasInternetConnection])
        {
            FBSDKLoginManager *loginManger = [[FBSDKLoginManager alloc] init];
            
            [loginManger logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
             {
                 if (error)
                 {
                     
                 }
                 
                 else if (result.isCancelled)
                 {
                     
                 }
                 else
                 {
                     if ([FBSDKAccessToken currentAccessToken])
                     {
                         [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday,location ,friends ,hometown , friendlists"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                          {
                              if (!error)
                              {
                                  NSLog(@"%@",result);
                                  
                                  NSString*picUrl=@"";
                                  if ([result valueForKey:@"picture"]) {
                                      
                                      if ([[result valueForKey:@"picture"]valueForKey:@"data"]) {
                                          
                                          if ([[[[result valueForKey:@"picture"]valueForKey:@"data"]valueForKey:@"url"]length]>0)
                                          {
                                              
                                              picUrl=[[[result valueForKey:@"picture"]valueForKey:@"data"]valueForKey:@"url"];
                                          }
                                      }
                                      
                                  }
                                  if (!error)
                                  {
                                      NSLog(@"%@",result);
                                      
                                      NSString*email=@"technical@zoptal.com";
                                      if ([result valueForKey:@"email"]) {
                                          
                                          if ([result valueForKey:@"email"]) {
                                              
                                              if ([[result valueForKey:@"email"]length]>0) {
                                                  
                                                  email=[result valueForKey:@"email"];
                                              }
                                          }
                                          
                                      }
                                      
                                      
                                      NSString*deviceToken=[UserDefaultHandler getDeviceToken];
                                      if (deviceToken==nil|| [result valueForKey:@"email"]==nil)
                                      {
                                          deviceToken=@"12345";
                                          
                                      }
                                      NSDictionary* registerInfo = @{
                                                                     @"email":email,
                                                                     @"login_type":@"Facebook",
                                                                     @"device_token":deviceToken,
                                                                     @"device_type":@"iPhone",
                                                                     @"name":[result valueForKey:@"first_name"],
                                                                     @"user_profile":picUrl
                                                                     
                                                                     };
                                      
                                      [self callForAddUser:registerInfo];
                                      
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
                                  
                                  
                                  return ;
                              }
                          }];
                     }
                 }
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
    else
    {
        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Photobunch"  message:@"Please select Terms of service."  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* Ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alert addAction:Ok];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
 


    
}


-(void)callForUpdateQuickBlox :(NSString*)quickBloxID
{
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"quickbox_id":quickBloxID
                                   
                                   };

        [KSharedParsing wsCallForUpdateQuickBlox:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray)
         {
            
         } failureBlock:^(BOOL succeeded, NSArray *failureArray)
         {
             
         }];
    

}



-(void)callForAddUser:(NSDictionary*)userProfile
{
    
    if ([KAppdelegate hasInternetConnection])
    {
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallForRegisterUser:userProfile successBlock:^(BOOL succeeded, NSArray *resultArray)
        {

                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    
                    [UserDefaultHandler setUserAccessToken:[[resultArray valueForKey:@"data"] valueForKey:@"access_token"]];
                    [UserDefaultHandler setUserInfo:[resultArray valueForKey:@"data"]];
                    
                    [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                        [KAppdelegate stopLoader:self.view];

                        UINavigationController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabControllerID"];
                        [KAppdelegate.window setRootViewController:tabBarController];

                        
                    }];

                    
                }
                else
                {
                     [KAppdelegate stopLoader:self.view];
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


- (IBAction)googleBtnClicked:(id)sender

{
    
    
    if (_chekBtn.selected)
    {
        if ([KAppdelegate hasInternetConnection])
        {
            [[GIDSignIn sharedInstance]signIn];
            
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
    else
    {
        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Photobunch"  message:@"Please select Terms of service."  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* Ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
        [alert addAction:Ok];
    
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}


#pragma mark - Google Sign IN Delegate
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error
{
    // Perform any operations on signed in user here.
    
    if (user)
    {
        NSString *userId = user.userID;                  // For client-side use only!
        NSString *idToken = user.authentication.idToken; // Safe to send to the server
        NSString *fullName = user.profile.name;
        NSString *givenName = user.profile.givenName;
        NSString *familyName = user.profile.familyName;
        NSString *email = user.profile.email;
        NSLog(@"%@ %@ %@ %@ %@ %@",userId,idToken,fullName,givenName,familyName,email);
        
        NSString*imageUrl=[user.profile imageURLWithDimension:500].absoluteString;
        
        if ([imageUrl length]==0)
        {
            imageUrl=@"";
        }
        
        NSDictionary* registerInfo = @{
                                       
                                       @"email":email,
                                       @"login_type":@"Google",
                                       @"device_token":@"123456",
                                       @"device_type":@"iPhone",
                                       @"name":fullName,
                                       @"user_profile":imageUrl,
                                       
                                       };
        
        
        [self callForAddUser:registerInfo];

        
        
    }
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
   // [self showAlert:@"Google SignIn Failure." withDelegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
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
    
}

// pressed the Sign In button
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];

}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
