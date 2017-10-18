//
//  ReviewModeViewController.m
//  PhotoBunch
//
//  Created by Gorav Grover on 13/06/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import "ReviewModeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "Constant.h"
#import "CZPickerView.h"
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <MediaPlayer/MediaPlayer.h>
@interface ReviewModeViewController ()<CZPickerViewDataSource,CZPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageCaptured;
@property (strong, nonatomic) IBOutlet UITextField *addCaptionTxtFld;

@property CZPickerView *pickerWithImage;
@property (weak, nonatomic) IBOutlet UISwitch *profileSwitch;

@end

@implementation ReviewModeViewController
{
    NSMutableArray*groupsArray,*groupsArrayFiltered;
    
    NSMutableArray*selectedGroups;
    AVPlayerViewController *playerViewController;
    
    AVPlayer * player1;
    BOOL videoCompressed;
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    videoCompressed=NO;
    // Do any additional setup after loading the view.
    groupsArray=[[NSMutableArray alloc]init];
    groupsArrayFiltered=[[NSMutableArray alloc]init];
    selectedGroups=[[NSMutableArray alloc]init];

    NSData *imgData = UIImageJPEGRepresentation(_editImage, 1.0);
    NSLog(@"Size of Image(bytes):%d",[imgData length]);
    if ([_isImage isEqualToString:@"YES"]) {
        
        _imageCaptured.image=_editImage;
        [_imageCaptured setHidden:NO];

    }
    else
    {
        [_imageCaptured setHidden:YES];
        playerViewController = [[AVPlayerViewController alloc] init];
        [self playVideo];
    }

    
    [self callGroupsApi];
}

-(void)viewDidAppear:(BOOL)animated
{
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [player1 pause];
    player1 = nil;
    playerViewController=nil;
    
}
-(void)playVideo
{
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie57.mp4"];

   // BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:pathToMovie];
    
    NSURL *url= [NSURL fileURLWithPath:pathToMovie];
    AVURLAsset *asset = [AVURLAsset assetWithURL: url];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset: asset];
    
    player1 = [[AVPlayer alloc] initWithPlayerItem: item];
    playerViewController.player = player1;
    [playerViewController.view setFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    playerViewController.showsPlaybackControls = NO;
    
    
    player1.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[player1 currentItem]];
    
    [self.view addSubview:playerViewController.view];
    
    [self.view sendSubviewToBack:playerViewController.view];
    
    [player1 play];
    
    
    
}
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
     [player1 play];
}


//Get Groups

-(void)callGroupsApi
{
    
    NSDate*date=[NSDate date];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDateFormatter *dateFormatterNew = [[NSDateFormatter alloc] init];
    [dateFormatterNew setLocale:enUSPOSIXLocale];
    [dateFormatterNew setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *stringForNewDate =[dateFormatterNew stringFromDate:date];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"device_time":stringForNewDate
                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsGetGroups:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    [groupsArrayFiltered removeAllObjects];
                    if ([[[resultArray valueForKey:@"data"] valueForKey:@"my_groups"]count]>0)
                    {
                        
                        [groupsArray addObjectsFromArray:[[resultArray valueForKey:@"data"] valueForKey:@"my_groups"]];
                    }

                    if ([[[resultArray valueForKey:@"data"] valueForKey:@"joined_groups"]count]>0)
                    {
                        NSArray*joinedArray=[[resultArray valueForKey:@"data"] valueForKey:@"joined_groups"];

                        [groupsArray addObjectsFromArray:joinedArray];

                    }
                    
                    for (int i=0; i<groupsArray.count; i++)
                    {
                    
                        if ([[[groupsArray objectAtIndex:i] valueForKey:@"group_status"]isEqualToString:@"Activated"])
                        {
                            [groupsArrayFiltered addObject:[groupsArray objectAtIndex:i]];
                        }
                        
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
        
        if ([_isImage isEqualToString:@"NO"])
        {
            [player1 pause];
            player1 = nil;
            playerViewController=nil;
        }
    }];
    
}
- (IBAction)sendBtnPressed:(id)sender {
    
    [self callCreatePost];
    
}
- (IBAction)addGroupsPressed:(id)sender
{
    
    self.pickerWithImage = [[CZPickerView alloc] initWithHeaderTitle:@"Select Groups" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Select"];
    self.pickerWithImage.delegate = self;
    self.pickerWithImage.dataSource = self;
    self.pickerWithImage.needFooterView = YES;
    self.pickerWithImage.allowMultipleSelection=YES;
    [self.pickerWithImage setSelectedRows:selectedGroups];
    [self.pickerWithImage show];

    
}
- (IBAction)downloadPressed:(id)sender
{
    if ([_isImage isEqualToString:@"NO"]) {
    
        
        
        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Photobunch"  message:@"Download the post to gallery"  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* Ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 
                                 NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie57.mp4"];
                                 NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];

                                 [KAppdelegate startLoader:self.view withTitle:@"Loading..."];

                                 ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                                 if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:movieURL])
                                 {
                                     [library writeVideoAtPathToSavedPhotosAlbum:movieURL completionBlock:^(NSURL *assetURL, NSError *error)
                                      {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              if (error)
                                              {
                                                  [KAppdelegate stopLoader:self.view];

                                                  NSDictionary *options = @{
                                                                            kCRToastTextKey : @"Error in downloading video.",
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
                                                  [KAppdelegate stopLoader:self.view];

                                                 
                                                 
                                                      NSDictionary *options = @{
                                                                                kCRToastTextKey : @"Video Downloded.",
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
                                          });
                                      }];
                                 }
                                 
                                 
//                                     NSURLSessionTask *download = [[NSURLSession sharedSession] downloadTaskWithURL:movieURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
//                                         if(error) {
//                                             NSLog(@"error saving: %@", error.localizedDescription);
//                                             return;
//                                         }
//                                         
//                                         NSURL *tempURL = movieURL;
//                                         
//                                         [[NSFileManager defaultManager] moveItemAtURL:location toURL:tempURL error:nil];
//                                         
//                                         [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//                                             PHAssetChangeRequest *changeRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:tempURL];
//                                             
//                                             NSLog(@"%@", changeRequest.description);
//                                         } completionHandler:^(BOOL success, NSError *error) {
//                                             if (success) {
//                                                 NSLog(@"saved down");
//                                                 [[NSFileManager defaultManager] removeItemAtURL:tempURL error:nil];
//                                             } else {
//                                                 NSLog(@"something wrong %@", error.localizedDescription);
//                                                 [[NSFileManager defaultManager] removeItemAtURL:tempURL error:nil];
//                                             }
//                                         }];
//                                  
//                                     [download resume];
//                                     }];
//                                 
                                 
                                 
                                 

                                 
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
        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Photobunch"  message:@"Download the post to gallery"  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* Ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                                 [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                                     PHAssetChangeRequest *changeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:_editImage];
                                     
                                 } completionHandler:^(BOOL success, NSError *error) {
                                     if (success) {
                                         
                                     }
                                     else {
                                         
                                     }
                                 }];
                                 
                                 
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
-(void)saveImageSuccess
{
    
}
- (IBAction)deletePressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}




#pragma mark CZPIcker Delegates

- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row{
    
    return [[groupsArrayFiltered objectAtIndex:row]valueForKey:@"group_name"];
    
}

- (UIImage *)czpickerView:(CZPickerView *)pickerView imageForRow:(NSInteger)row
{
 
    return nil;
    
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row
{
    
    // [selectPaymentGateBtn setTitle:paymentGateways[row] forState:UIControlStateNormal];
    
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemsAtRows:(NSArray *)rows
{
    selectedGroups=rows;
    
}

#pragma mark CZPickerView delegates
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView
{
    return [groupsArrayFiltered count];
    
}



#pragma mark TextField delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    [textField resignFirstResponder];
    return YES;
    
}


-(UIImage *)getThumbNail:(NSString*)stringPath
{
    NSURL *videoURL = [NSURL fileURLWithPath:stringPath];
    
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    
    UIImage *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    //Player autoplays audio on init
    [player stop];
    return thumbnail;
}

-(UIImage *)compressImage:(UIImage *)image  maxWidth:(int) maxWidth maxHeight:(int) maxHeight
{
    
    NSData *imgData = UIImageJPEGRepresentation(image, 1); //1 it represents the quality of the image.
    NSLog(@"Size of Image(bytes):%ld",(unsigned long)[imgData length]);
    
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
   // float maxHeight = 600.0;
   // float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 1.0;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    NSLog(@"Size of Image(bytes):%ld",(unsigned long)[imageData length]);
    
    return [UIImage imageWithData:imageData];
}


-(void)callCreatePost
{
    [player1 pause];
    //NSDateFormatter *dateFormatterNew = [[NSDateFormatter alloc] init];
   // [dateFormatterNew setLocale:[NSLocale localeWithLocaleIdentifier:@"en_GB"]];
   // [dateFormatterNew setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
   // NSString *stringForNewDate =[dateFormatterNew stringFromDate:[NSDate date]];
    
    NSDate*date=[NSDate date];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDateFormatter *dateFormatterNew = [[NSDateFormatter alloc] init];
    [dateFormatterNew setLocale:enUSPOSIXLocale];
    [dateFormatterNew setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *stringForNewDate =[dateFormatterNew stringFromDate:date];
    
    NSString *captionString =@"";


    NSMutableArray*idArray=[NSMutableArray arrayWithObjects:captionString, nil];
    NSString *usersIds = [idArray componentsJoinedByString:@","];
    NSMutableArray*idArray1;
    
    NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
    
    [dict setValue:[UserDefaultHandler getUserAccessToken] forKey:@"access_token"];
    [dict setValue:@"Tittle" forKey:@"post_title"];
    [dict setValue:stringForNewDate forKey:@"post_time"];
    [dict setValue:stringForNewDate forKey:@"created_on"];

    
    if ([_isImage isEqualToString:@"YES"])
    {
        [dict setValue:@"Image" forKey:@"media_type"];
        
        //NSLog(@"Size of Image(bytes):%ld",(unsigned long)[UIImageJPEGRepresentation((_editImage),1.0) length]);
       // UIImage*orignalImage=[ImageCompress scaleImage:_editImage toSize:CGSizeMake(700,700)];
        UIImage*orignalImage=[ImageCompress scaleImage:_editImage maxWidth:400 maxHeight:700];
       // NSLog(@"Size of Image(bytes):%ld",(unsigned long)[UIImageJPEGRepresentation((orignalImage),1.0) length]);
        //UIImage*thumbImage=[ImageCompress scaleImage:_editImage toSize:CGSizeMake(250, 250)];
        UIImage*thumbImage=[ImageCompress scaleImage:_editImage maxWidth:200 maxHeight:200];
        idArray1=[NSMutableArray arrayWithObjects:orignalImage,thumbImage, nil];

    }
    else
    {
        [dict setValue:@"Video" forKey:@"media_type"];
        NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie57.mp4"];
        UIImage*thumb=[self getThumbNail:pathToMovie];
        NSData*data=[NSData dataWithContentsOfFile:pathToMovie];
        idArray1=[NSMutableArray arrayWithObjects:data,thumb, nil];
        
    }
    
    [dict setValue:usersIds forKey:@"media_captions"];

    if ([selectedGroups count]>0)
    {
        NSMutableArray*arr=[[NSMutableArray alloc]init];
        
        for (int i=0 ; i<[selectedGroups count];i++)
        {
            [arr addObject:[[groupsArrayFiltered objectAtIndex:[[selectedGroups objectAtIndex:i]integerValue]] valueForKey:@"id"]];
            
        }
        
        NSString *groupsIds = [arr componentsJoinedByString:@","];
        

        [dict setValue:groupsIds forKey:@"group_ids"];

    }
    NSString*isProfile=@"";
    if ([_profileSwitch isOn])
    {
    isProfile=@"0";
    }
    else
    {
       
        
        if (selectedGroups.count==0)
        {
            NSDictionary *options = @{
                                      kCRToastTextKey : @"Please Select any Group or Profile to post",
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
            
            return;
            

        }
        else
        {
            isProfile=@"1";

        }

    }
  
    [dict setValue:isProfile forKey:@"only_group"];

    
    
    NSMutableDictionary*dict1=[[NSMutableDictionary alloc]init];
    [dict1 setObject:idArray1 forKey:@"profile_pic"];
    
    [dict1 setObject:dict forKey:@"parameters"];
    
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCreatePost:dict1 successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }
                else
                {
                    if ([[resultArray valueForKey:@"code"] integerValue]==201 )
                    {
                        NSDictionary *options = @{
                                                  kCRToastTextKey :[resultArray valueForKey:@"message"] ,
                                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                                  kCRToastBackgroundColorKey : [UIColor redColor],
                                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight),
                                                  kCRToastNotificationPreferredHeightKey : @"40"

                                                  
                                                  };
                        [CRToastManager showNotificationWithOptions:options
                                                    completionBlock:^{
                                                        NSLog(@"Completed");
                                                    }];

                        
                    }
                    else
                    { NSDictionary *options = @{
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


- (void)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL
                                   outputURL:(NSURL*)outputURL
                                     handler:(void (^)(AVAssetExportSession*))handler
{
    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetLowQuality];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         handler(exportSession);
     }];
}


- (IBAction)viewInProfileSwitch:(id)sender
{
}

-(UIImage *)scaleImage:(UIImage *)image maxWidth:(int) maxWidth maxHeight:(int) maxHeight
{
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    if (width <= maxWidth && height <= maxHeight)
    {
        return image;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    if (width > maxWidth || height > maxHeight)
    {
        CGFloat ratio = width/height;
        
        if (ratio > 1)
        {
            bounds.size.width = maxWidth;
            bounds.size.height = bounds.size.width / ratio;
        }
        else
        {
            bounds.size.height = maxHeight;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);
    CGContextTranslateCTM(context, 0, -height);
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
    
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
