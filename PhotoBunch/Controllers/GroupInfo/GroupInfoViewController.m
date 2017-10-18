//
//  GroupInfoViewController.m
//  PhotoBunch
//
//  Created by Gorav Grover on 05/06/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import "GroupInfoViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <AddressBook/AddressBook.h>
#import <Twitter/Twitter.h>
#import "Constant.h"
#import "UIButton+WebCache.h"

@interface GroupInfoViewController ()<UIDocumentInteractionControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *qrCodeView;
@property (strong, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (strong, nonatomic) IBOutlet UILabel *goupNameTopLbl;
@property (strong, nonatomic) IBOutlet UIImageView *groupIconBackground;
@property (strong, nonatomic) IBOutlet UITextView *groupDescriptionTxtView;
@property (strong, nonatomic) IBOutlet UIButton *groupQrCodeBtn;
@property (strong, nonatomic) IBOutlet UIButton *groupTypeBtn;
@property (strong, nonatomic) IBOutlet UIButton *groupStartDateBtn;
@property (strong, nonatomic) IBOutlet UIButton *groupEndDateBtn;
@property (strong, nonatomic) IBOutlet UILabel *groupStartTime;
@property (strong, nonatomic) IBOutlet UILabel *groupEndTime;
@property (strong, nonatomic) UIImage *codeImage;
@property(nonatomic,retain) UIDocumentInteractionController *documentationInteractionController;
@property (weak, nonatomic) IBOutlet UILabel *discriptionLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disHeightConstant;
@property (weak, nonatomic) IBOutlet UILabel *groupTittle;

@end

@implementation GroupInfoViewController


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.groupIconBackground.layer.cornerRadius = 10.0f;
    _qrCodeView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.9];
    
        [self setInitiala];
    
}
-(void)setInitiala
{
    
        [_groupQrCodeBtn setHidden:NO];
        if ([_groupInfo valueForKey:@"qr_image"])
        {
            if ([[_groupInfo valueForKey:@"qr_image"] length]>0)
            {
                
                
                [_groupQrCodeBtn sd_setImageWithURL:[NSURL URLWithString:[_groupInfo valueForKey:@"qr_image"]] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
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
        
  
    if ([_groupInfo valueForKey:@"group_image"])
    {
        if ([[_groupInfo valueForKey:@"group_image"] length]>0) {
            [_groupIconBackground sd_setImageWithURL:[NSURL URLWithString:[_groupInfo valueForKey:@"group_image"]] placeholderImage:[UIImage imageNamed:@"groupBG"] options:SDWebImageRefreshCached];
            
        }
        else
        {
            _groupIconBackground.image=[UIImage imageNamed:@"groupBG"];
        }
    }
    else
    {
        _groupIconBackground.image=[UIImage imageNamed:@"groupBG"];
        
    }
    
    
    if ([_groupInfo valueForKey:@"group_name"])
    {
        if ([[_groupInfo valueForKey:@"group_name"] length]>0) {
            
            
            _goupNameTopLbl.text=[_groupInfo valueForKey:@"group_name"];
            _groupTittle.text=[_groupInfo valueForKey:@"group_name"];
        }
        else
        {
            _goupNameTopLbl.text=@"";
             _groupTittle.text=@"";
        }
        
    }
    else
    {
        _goupNameTopLbl.text=@"";
        _groupTittle.text=@"";

        
    }
    
    
//    if ([[_groupInfo valueForKey:@"description"]length]>0)
//    {
//        
//        CGSize maximumLabelSize = CGSizeMake(100, 100);
//        
//        CGSize expectedLabelSize = [[_groupInfo valueForKey:@"description"] sizeWithFont:_discriptionLbl.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
//        
//        _discriptionLbl.text=[_groupInfo valueForKey:@"description"];
//        _discriptionLbl.textColor=[UIColor blackColor];
//        CGRect newFrame = _discriptionLbl.frame;
//        newFrame.size.height = expectedLabelSize.height;
//        _disHeightConstant.constant=newFrame.size.height;
//        
//    }
//    else
//    {
//        
//        _disHeightConstant.constant=20;
//        _discriptionLbl.text=@"";
//        _discriptionLbl.textColor=[UIColor lightGrayColor];
//        
//    }

    
    

    if ([_groupInfo valueForKey:@"group_desc"])
    {
        if ([[_groupInfo valueForKey:@"group_desc"] length]>0) {
            
            
            CGSize maximumLabelSize = CGSizeMake(100, 100);
            
            CGSize expectedLabelSize = [[_groupInfo valueForKey:@"group_desc"] sizeWithFont:_discriptionLbl.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
            
            _discriptionLbl.text=[_groupInfo valueForKey:@"group_desc"];
            _discriptionLbl.textColor=[UIColor blackColor];
            
            CGRect newFrame = _discriptionLbl.frame;
            newFrame.size.height = expectedLabelSize.height;
            
            _disHeightConstant.constant=newFrame.size.height;

        }
        else
        {
            _disHeightConstant.constant=10;
            _discriptionLbl.text=@"";
        }
        
    }
    else
    {
        _discriptionLbl.text=@"";
        
    }

    if ([[_groupInfo valueForKey:@"privacy_type"]isEqualToString:@"1"])
    {
        [_groupTypeBtn setTitle:@"Open Group" forState:UIControlStateNormal];
    }
    else if ([[_groupInfo valueForKey:@"privacy_type"]isEqualToString:@"2"])
    {
        [_groupTypeBtn setTitle:@"Request to join." forState:UIControlStateNormal];
        
    }
    else if ([[_groupInfo valueForKey:@"privacy_type"]isEqualToString:@"3"])
    {
        [_groupTypeBtn setTitle:@"Password Protected." forState:UIControlStateNormal];
        
    }
    
    if ([_groupInfo valueForKey:@"start_date"])
    {
        if ([[_groupInfo valueForKey:@"start_date"] length]>0) {
            
            NSArray * arr = [[_groupInfo valueForKey:@"start_date"] componentsSeparatedByString:@" "];
            
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy/MM/dd"];
            NSDate *date = [dateFormat dateFromString:[arr objectAtIndex:0]];
            
            // Convert date object to desired output format
            [dateFormat setDateFormat:@"dd/MM/yyyy"];
            NSString* dateStr = [dateFormat stringFromDate:date];

            
            
            [_groupStartDateBtn setTitle:dateStr forState:UIControlStateNormal];
            _groupStartTime.text=[arr objectAtIndex:1];
            
        }
        
    }
    
    if ([_groupInfo valueForKey:@"end_date"])
    {
        if ([[_groupInfo valueForKey:@"end_date"] length]>0) {
            
            NSArray * arr = [[_groupInfo valueForKey:@"end_date"] componentsSeparatedByString:@" "];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy/MM/dd"];
            NSDate *date = [dateFormat dateFromString:[arr objectAtIndex:0]];
            
            // Convert date object to desired output format
            [dateFormat setDateFormat:@"dd/MM/yyyy"];
            NSString* dateStr = [dateFormat stringFromDate:date];
            
            
            [_groupEndDateBtn setTitle:dateStr forState:UIControlStateNormal];
            _groupEndTime.text=[arr objectAtIndex:1];
            
        }
        
    }

    
    
    
}
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtnPressed:(id)sender
{
    
    NSArray *array = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[array objectAtIndex:[array count]-3] animated:NO];
        
}
- (IBAction)faceBookBtnPressed:(id)sender
{
    SLComposeViewController *faceBook=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [faceBook addImage:_codeImage];
    [faceBook setInitialText:[NSString stringWithFormat:@"Hey join %@ Group by scanning the this code.",[_groupInfo valueForKey:@"group_name"]]];
    
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
    [tweeter setInitialText:[NSString stringWithFormat:@"Hey join %@ Group by scanning the this code.",[_groupInfo valueForKey:@"group_name"]]];
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

- (IBAction)alertPressed:(id)sender
{
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








/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
