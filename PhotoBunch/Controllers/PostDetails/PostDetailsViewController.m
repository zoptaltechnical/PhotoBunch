//
//  PostDetailsViewController.m
//  PhotoBunch
//
//  Created by Gorav Grover on 15/06/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import "PostDetailsViewController.h"
#import "Constant.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "NSDate+NVTimeAgo.h"

#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import <MediaPlayer/MediaPlayer.h>
#import "HSPlayerView.h"
@interface PostDetailsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *postTittle;
@property (strong, nonatomic) IBOutlet UILabel *ownerName;
@property (strong, nonatomic) IBOutlet UILabel *postTiming;
@property (strong, nonatomic) IBOutlet UIImageView *ownerImage;
@property (strong, nonatomic) IBOutlet UIImageView *postImage;
@property (nonatomic, strong) HSPlayerView *playerView;
@property (strong, nonatomic) IBOutlet UIView *playerView1;


@end

@implementation PostDetailsViewController
{
    AVPlayer * player1;
    AVPlayerViewController *playerViewController;
    

}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.postImage.contentMode = UIViewContentModeScaleAspectFit;

    
}
-(void)viewDidAppear:(BOOL)animated
{
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapRecognizer addTarget:self action:@selector(bigButtonTapped:)];
    
    UITapGestureRecognizer *tapRecognizer1 = [[UITapGestureRecognizer alloc] init];
    [tapRecognizer1 addTarget:self action:@selector(bigButtonTapped:)];
    
    [_ownerImage addGestureRecognizer:tapRecognizer];
    [_postImage addGestureRecognizer:tapRecognizer1];

    
    [self callGetPostDetails];
    
    
}

-(void)playVideo :(NSString*)urlString
{
    
    
    [self setPlayerView:[[HSPlayerView alloc] initWithFrame:_playerView1.frame]];
    //[self.playerView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    
    NSURL *url= [NSURL URLWithString:urlString];
    [self.playerView setFullScreen:NO];
    self.playerView.controlsVisible=NO;
   // NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                               //          pathForResource:@"11" ofType:@"mp4"]];
    
    [self.playerView setURL:url];
    
    [self.view addSubview:self.playerView];

      [self.playerView setPlaying:YES];
    
//    NSURL *url= [NSURL URLWithString:urlString];
//    AVURLAsset *asset = [AVURLAsset assetWithURL: url];
//    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset: asset];
//    
//    player1 = [[AVPlayer alloc] initWithPlayerItem: item];
//    playerViewController.player = player1;
//    [playerViewController.view setFrame:CGRectMake(0,130, self.view.bounds.size.width,300)];
//    
//    playerViewController.showsPlaybackControls = NO;
//    
//    
//    player1.actionAtItemEnd = AVPlayerActionAtItemEndNone;
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(playerItemDidReachEnd:)
//                                                 name:AVPlayerItemDidPlayToEndTimeNotification
//                                               object:[player1 currentItem]];
//    playerViewController.view.backgroundColor=[UIColor blackColor];
//    [self.view addSubview:playerViewController.view];
//   // [self.view bringSubviewToFront:player1];
//
//    [self.view bringSubviewToFront:playerViewController.view];
//    
//    [player1 play];
//    
    
}
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
    [player1 play];
}

- (void)playVideo1:(UITapGestureRecognizer*)sender
{
    
    
}
- (void)bigButtonTapped:(UITapGestureRecognizer*)sender
{
    
    UIImageView*seletedImage;
    if (sender.view==_ownerImage)
    {
        seletedImage=_ownerImage;
    }
    else
    {
        seletedImage=_postImage;
        
    }
    
    
//    
//    if ([seletedImage.image isEqual:[UIImage imageNamed:@"male_Profile.png"]]||[seletedImage.image isEqual:[UIImage imageNamed:@"female_profile.png"]]||[seletedImage.image isEqual:[UIImage imageNamed:@"cover.png"]]) {
//        
//    }
//    else
//    {
        // Create image info
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
        
   // }
    
    
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    [playerViewController.view removeFromSuperview];
    playerViewController =nil;
    
}


-(void)setInitials :(NSDictionary*)dict
{
    if ([dict valueForKey:@"medias"])
    {
        if ([[dict valueForKey:@"medias"]count]>0) {
            
        
        if ([[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_path"])
        {
            
            
            if ([[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_path"] length]>0)
            {
                
                if ([[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_type"]isEqualToString:@"image"]) {
                    [_postImage sd_setImageWithURL:[NSURL URLWithString:[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_path"]] placeholderImage:nil options:SDWebImageRefreshCached];

                    [_postImage setHidden:NO];
                    [self.playerView1 setHidden:YES];
                }
                else
                {
                    [_postImage setHidden:YES];
                    [self.playerView1 setHidden:NO];

                    [self playVideo :[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_path"]];
                }

                
            }
            
        }
        if ([[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_name"])
        {
            if ([[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_name"] length]>0)
            {
                _postTittle.text=[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_name"];
            }
            
        }
        }
        
    }
    
    if ([dict valueForKey:@"post_time"])
    {
        if ([[dict valueForKey:@"post_time"] length]>0) {
            
            NSString *timeAgoFormattedDate = [NSDate mysqlDatetimeFormattedAsTimeAgo:[dict valueForKey:@"post_time"]];
            
            _postTiming.text=timeAgoFormattedDate;
            
        }
        else
        {
            _postTiming.text=@"";
        }
        
    }
    else
    {
        _postTiming.text=@"";
        
    }

    
//    if ([dict valueForKey:@"post_title"])
//    {
//        if ([[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_path"])
//        {
//            if ([[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_path"] length]>0)
//            {
//                [_postImage sd_setImageWithURL:[NSURL URLWithString:[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_path"]] placeholderImage:nil options:SDWebImageRefreshCached];
//            }
//            
//        }
//        
//    }
    
    
}


-(void)callGetPostDetails
{
    //access_token
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"post_id":_postID
                                   
                                   
                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsCallToGetPostDetail:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    
                    [self setInitials :[resultArray valueForKey:@"data"]];
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


- (IBAction)backBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
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
