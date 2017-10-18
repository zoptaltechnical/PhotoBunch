//
//  KSPhotoBrowser.m
//  KSPhotoBrowser
//
//  Created by Kyle Sun on 12/25/16.
//  Copyright © 2016 Kyle Sun. All rights reserved.
//

#import "KSPhotoBrowser.h"
#import "KSPhotoView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "Constant.h"
#import "FTPopOverMenu.h"

#if __has_include(<YYWebImage/YYWebImage.h>)
#import <YYWebImage/YYWebImage.h>
#else
#import "YYWebImage.h"
#endif
@import AVFoundation;
@import AVKit;
static const NSTimeInterval kAnimationDuration = 0.3;
static const NSTimeInterval kSpringAnimationDuration = 0.5;
static Class imageManagerClass = nil;

@interface KSPhotoBrowser () <UIScrollViewDelegate, UIViewControllerTransitioningDelegate, CAAnimationDelegate> {
    CGPoint _startLocation;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *photoItems;
@property (nonatomic, strong) NSMutableArray *photoItemsTypes;
@property (nonatomic, strong) NSMutableArray *mediaPaths;
@property (nonatomic, strong) NSMutableArray *allDicts;

@property (nonatomic, strong) NSMutableSet *reusableItemViews;
@property (nonatomic, strong) NSMutableArray *visibleItemViews;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, assign) BOOL presented;
@property (nonatomic, strong) id<KSImageManager> imageManager;
@property (nonatomic, strong, readonly) UIImageView *playImage;

@end

@implementation KSPhotoBrowser
{
    AVPlayerViewController *playerViewController;

}

// MAKR: - Initializer

+ (instancetype)browserWithPhotoItems:(NSArray<KSPhotoItem *> *)photoItems selectedIndex:(NSUInteger)selectedIndex typesArray:(NSArray*)typesArray  mediaPaths:(NSArray*)mediaPaths allDataDicts:(NSArray*)allDataDicts
{
    KSPhotoBrowser *browser = [[KSPhotoBrowser alloc] initWithPhotoItems:photoItems selectedIndex:selectedIndex typesArray:typesArray mediaPaths:mediaPaths allDataDicts:allDataDicts];
    return browser;
}

- (instancetype)init {
    NSAssert(NO, @"Use initWithMediaItems: instead.");
    return nil;
}

- (instancetype)initWithPhotoItems:(NSArray<KSPhotoItem *> *)photoItems selectedIndex:(NSUInteger)selectedIndex typesArray:(NSArray*)typesArray mediaPaths:(NSArray*)mediaPaths allDataDicts:(NSArray*)allDataDicts {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        _photoItemsTypes=[NSMutableArray arrayWithArray:typesArray];
        _mediaPaths=[NSMutableArray arrayWithArray:mediaPaths];
        _allDicts=[NSMutableArray arrayWithArray:allDataDicts];

        _photoItems = [NSMutableArray arrayWithArray:photoItems];
        _currentPage = selectedIndex;
        
        _dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleRotation;
        _pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleDot;
        _backgroundStyle = KSPhotoBrowserBackgroundStyleBlurPhoto;
        _loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
        
        _reusableItemViews = [[NSMutableSet alloc] init];
        _visibleItemViews = [[NSMutableArray alloc] init];
        
        if (imageManagerClass == nil) {
            imageManagerClass = KSYYImageManager.class;
        }
        _imageManager = [[imageManagerClass alloc] init];
    }
    return self;
}

// MARK: - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    playerViewController = [[AVPlayerViewController alloc] init];

    
   
    
    self.view.backgroundColor = [UIColor clearColor];
    
    _backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    _backgroundView.alpha = 0;
    [self.view addSubview:_backgroundView];
    
    CGRect rect = self.view.bounds;
    rect.origin.x -= kKSPhotoViewPadding;
    rect.size.width += 2 * kKSPhotoViewPadding;
    _scrollView = [[UIScrollView alloc] initWithFrame:rect];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    if (_pageindicatorStyle == KSPhotoBrowserPageIndicatorStyleDot) {
        if (_photoItems.count > 1) {
            _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-40, self.view.bounds.size.width, 20)];
            _pageControl.numberOfPages = _photoItems.count;
            _pageControl.currentPage = _currentPage;
            [self.view addSubview:_pageControl];
        }
    } else {
        _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-40, self.view.bounds.size.width, 20)];
        _pageLabel.textColor = [UIColor whiteColor];
        _pageLabel.font = [UIFont systemFontOfSize:16];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        [self configPageLabelWithPage:_currentPage];
        [self.view addSubview:_pageLabel];
    }
    
    CGSize contentSize = CGSizeMake(rect.size.width * _photoItems.count, rect.size.height);
    _scrollView.contentSize = contentSize;
    
    [self addGestureRecognizer];
    
    CGPoint contentOffset = CGPointMake(_scrollView.frame.size.width*_currentPage, 0);
    [_scrollView setContentOffset:contentOffset animated:NO];
    if (contentOffset.x == 0) {
        [self scrollViewDidScroll:_scrollView];
    }
    
   
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    KSPhotoItem *item = [_photoItems objectAtIndex:_currentPage];
    KSPhotoView *photoView = [self photoViewForPage:_currentPage];
    
    if ([_imageManager imageFromMemoryForURL:item.imageUrl]) {
        [self configPhotoView:photoView withItem:item];
    } else {
        photoView.imageView.image = item.thumbImage;
        [photoView resizeImageView];
    }
    
    CGRect endRect = photoView.imageView.frame;
    CGRect sourceRect;
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 8.0 && systemVersion < 9.0) {
        sourceRect = [item.sourceView.superview convertRect:item.sourceView.frame toCoordinateSpace:photoView];
    } else {
        sourceRect = [item.sourceView.superview convertRect:item.sourceView.frame toView:photoView];
    }
    photoView.imageView.frame = sourceRect;
    
    if (_backgroundStyle == KSPhotoBrowserBackgroundStyleBlur) {
        [self blurBackgroundWithImage:[self screenshot] animated:NO];
    } else if (_backgroundStyle == KSPhotoBrowserBackgroundStyleBlurPhoto) {
        [self blurBackgroundWithImage:item.thumbImage animated:NO];
    }
    if (_bounces)
    {
        [UIView animateWithDuration:kSpringAnimationDuration delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:kNilOptions animations:^{
            photoView.imageView.frame = endRect;
            self.view.backgroundColor = [UIColor blackColor];
            _backgroundView.alpha = 1;
        } completion:^(BOOL finished) {
            [self configPhotoView:photoView withItem:item];
            _presented = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        }];
    } else {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            photoView.imageView.frame = endRect;
            self.view.backgroundColor = [UIColor blackColor];
            _backgroundView.alpha = 1;
        } completion:^(BOOL finished) {
            [self configPhotoView:photoView withItem:item];
            _presented = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        }];
    }
    
    UIButton*downLoadBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    downLoadBtn.frame=CGRectMake(self.view.frame.size.width-75,25,50, 50);
    [downLoadBtn setImage:[UIImage imageNamed:@"downlode_iconReview"] forState:UIControlStateNormal];
    [downLoadBtn addTarget:self action:@selector(downLoadImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downLoadBtn];

    
    UIButton*reportBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    reportBtn.frame=CGRectMake(10,25,150,40);
    [reportBtn setTitle:@"Report Content" forState:UIControlStateNormal];
    [[reportBtn layer] setBorderWidth:2.0f];
    reportBtn.layer.cornerRadius = 5.0f;
    [[reportBtn layer] setBorderColor:[UIColor whiteColor].CGColor];
    [reportBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reportBtn addTarget:self action:@selector(reportContent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reportBtn];

//    UIButton*blockUser=[UIButton buttonWithType:UIButtonTypeCustom];
//    blockUser.frame=CGRectMake(10,reportBtn.frame.origin.y+reportBtn.frame.size.height+5,150,40);
//    [blockUser setTitle:@"Block User" forState:UIControlStateNormal];
//    [[blockUser layer] setBorderWidth:2.0f];
//    blockUser.layer.cornerRadius = 5.0f;
//    [[blockUser layer] setBorderColor:[UIColor whiteColor].CGColor];
//    [blockUser setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [blockUser addTarget:self action:@selector(blockUser:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:blockUser];

    
    //_playImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-25, self.view.frame.size.height/2-25,50, 50)];
   // _playImage.backgroundColor = [UIColor clearColor];
    // _playImage.center = _imageView.center;
   // _playImage.image=[UIImage imageNamed:@"Play"];
    //[self.playImage setHidden:YES];
    
    //[self.view addSubview:_playImage];
    //[self.view bringSubviewToFront:_playImage];
    
}
-(void)blockUser:(UIButton*)sender
{

    UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Photobunch"  message:@"Are you sure you want to block the user of this content."  preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* Yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             
                             
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:Yes];

    UIAlertAction* No = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:No];
    
    [self presentViewController:alert animated:YES completion:nil];

    

}

-(void)calBlockUser
{
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"user_id":[[_allDicts objectAtIndex:_currentPage] valueForKey:@"id"],
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


-(void)reportContent:(UIButton*)sender
{
    [FTPopOverMenuConfiguration defaultConfiguration ].menuWidth=220;
    [FTPopOverMenu showForSender:sender
                        withMenu:@[@"Offensive Content",@"Spam/Scam",@"Child Exploitation"]
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
             [self callReportSpam:@"Spam/Scam"];

         }
         else if (selectedIndex==2)
         {
             [self callReportSpam:@"Child Exploitation"];

         }
         
     } dismissBlock:^{
         
         NSLog(@"user canceled. do nothing.");
         
     }];

    
}

-(void)callReportSpam :(NSString*)reportType
{
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"post_id":[[_allDicts objectAtIndex:_currentPage] valueForKey:@"id"],
                                   @"reason":reportType,
                                   @"report_type":@"post",

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


-(void)downLoadImage
{
    
    NSURL *url = [NSURL URLWithString:[_mediaPaths objectAtIndex:_currentPage]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    // Write it to cache directory
    NSString *path;
    if ([[_photoItemsTypes objectAtIndex:_currentPage]isEqualToString:@"video"])
    {
        path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"file.mov"];
        
        [data writeToFile:path atomically:YES];
        
        // After that use this path to save it to PhotoLibrary
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:path] completionBlock:^(NSURL *assetURL, NSError *error) {
            
            if (error) {
                NSLog(@"%@", error.description);
            }else {
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *filePath = path;
                NSError *error;
                BOOL success = [fileManager removeItemAtPath:filePath error:&error];
                if (success) {
                    
                }
                else
                {
                    NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
                }
                
            }
            
        }];

        
    }
    else
    {
        path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"file.jpeg"];
        
        UIImage* image = [UIImage imageWithData:data];

        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetChangeRequest *changeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            
        } completionHandler:^(BOOL success, NSError *error) {
            if (success) {
                
            }
            else {
                
            }
        }];
    }
    
}
- (void)dealloc {
    
}

// MARK: - Public

- (void)showFromViewController:(UIViewController *)vc {
    [vc presentViewController:self animated:NO completion:nil];
}

+ (void)setImageManagerClass:(Class<KSImageManager>)cls {
    imageManagerClass = cls;
}

// MARK: - Private

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (KSPhotoView *)photoViewForPage:(NSUInteger)page {
    for (KSPhotoView *photoView in _visibleItemViews) {
        if (photoView.tag == page) {
            return photoView;
        }
    }
    return nil;
}

- (KSPhotoView *)dequeueReusableItemView {
    KSPhotoView *photoView = [_reusableItemViews anyObject];
    if (photoView == nil) {
        photoView = [[KSPhotoView alloc] initWithFrame:_scrollView.bounds imageManager:_imageManager];
    } else {
        [_reusableItemViews removeObject:photoView];
    }
    photoView.tag = -1;
    return photoView;
}

- (void)updateReusableItemViews {
    NSMutableArray *itemsForRemove = @[].mutableCopy;
    for (KSPhotoView *photoView in _visibleItemViews) {
        if (photoView.frame.origin.x + photoView.frame.size.width < _scrollView.contentOffset.x - _scrollView.frame.size.width ||
            photoView.frame.origin.x > _scrollView.contentOffset.x + 2 * _scrollView.frame.size.width) {
            [photoView removeFromSuperview];
            [self configPhotoView:photoView withItem:nil];
            [itemsForRemove addObject:photoView];
            [_reusableItemViews addObject:photoView];
        }
    }
    [_visibleItemViews removeObjectsInArray:itemsForRemove];
}

- (void)configItemViews {
    NSInteger page = _scrollView.contentOffset.x / _scrollView.frame.size.width + 0.5;
    for (NSInteger i = page - 1; i <= page + 1; i++) {
        if (i < 0 || i >= _photoItems.count) {
            continue;
        }
        KSPhotoView *photoView = [self photoViewForPage:i];
        if (photoView == nil) {
            photoView = [self dequeueReusableItemView];
            CGRect rect = _scrollView.bounds;
            rect.origin.x = i * _scrollView.bounds.size.width;
            photoView.frame = rect;
            photoView.tag = i;
            
            if ([[_photoItemsTypes objectAtIndex:i]isEqualToString:@"video"]) {
                [_playImage setHidden:NO];
            }
            else
            {
                [_playImage setHidden:YES];

            }
            
            
            [_scrollView addSubview:photoView];
            [_visibleItemViews addObject:photoView];
            
            
            
            
        }
        if (photoView.item == nil && _presented) {
            KSPhotoItem *item = [_photoItems objectAtIndex:i];
            [self configPhotoView:photoView withItem:item];
        }
    }
    
    if (page != _currentPage && _presented && (page >= 0 && page < _photoItems.count)) {
        KSPhotoItem *item = [_photoItems objectAtIndex:page];
        if (_backgroundStyle == KSPhotoBrowserBackgroundStyleBlurPhoto) {
            [self blurBackgroundWithImage:item.thumbImage animated:YES];
        }
        _currentPage = page;
        if (_pageindicatorStyle == KSPhotoBrowserPageIndicatorStyleDot) {
            _pageControl.currentPage = page;
        } else {
            [self configPageLabelWithPage:_currentPage];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(ks_photoBrowser:didSelectItem:atIndex:)]) {
            [_delegate ks_photoBrowser:self didSelectItem:item atIndex:page];
        }
    }
}

- (void)dismissAnimated:(BOOL)animated {
    for (KSPhotoView *photoView in _visibleItemViews) {
        [photoView cancelCurrentImageLoad];
    }
    KSPhotoItem *item = [_photoItems objectAtIndex:_currentPage];
    if (animated) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            item.sourceView.alpha = 1;
        }];
    } else {
        item.sourceView.alpha = 1;
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)performRotationWithPan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.view];
    CGPoint location = [pan locationInView:self.view];
    CGPoint velocity = [pan velocityInView:self.view];
    KSPhotoView *photoView = [self photoViewForPage:_currentPage];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            _startLocation = location;
            [self handlePanBegin];
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat angle = 0;
            if (_startLocation.x < self.view.frame.size.width/2) {
                angle = -(M_PI / 2) * (point.y / self.view.frame.size.height);
            } else {
                angle = (M_PI / 2) * (point.y / self.view.frame.size.height);
            }
            CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
            CGAffineTransform translation = CGAffineTransformMakeTranslation(0, point.y);
            CGAffineTransform transform = CGAffineTransformConcat(rotation, translation);
            photoView.imageView.transform = transform;
            
            double percent = 1 - fabs(point.y)/(self.view.frame.size.height/2);
            self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:percent];
            _backgroundView.alpha = percent;
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (fabs(point.y) > 200 || fabs(velocity.y) > 500) {
                [self showRotationCompletionAnimationFromPoint:point];
            } else {
                [self showCancellationAnimation];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)performScaleWithPan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.view];
    CGPoint location = [pan locationInView:self.view];
    CGPoint velocity = [pan velocityInView:self.view];
    KSPhotoView *photoView = [self photoViewForPage:_currentPage];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            _startLocation = location;
            [self handlePanBegin];
            break;
        case UIGestureRecognizerStateChanged: {
            double percent = 1 - fabs(point.y) / self.view.frame.size.height;
            percent = MAX(percent, 0);
            double s = MAX(percent, 0.5);
            CGAffineTransform translation = CGAffineTransformMakeTranslation(point.x/s, point.y/s);
            CGAffineTransform scale = CGAffineTransformMakeScale(s, s);
            photoView.imageView.transform = CGAffineTransformConcat(translation, scale);
            self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:percent];
            _backgroundView.alpha = percent;
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (fabs(point.y) > 100 || fabs(velocity.y) > 500) {
                [self showDismissalAnimation];
            } else {
                [self showCancellationAnimation];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)performSlideWithPan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.view];
    CGPoint location = [pan locationInView:self.view];
    CGPoint velocity = [pan velocityInView:self.view];
    KSPhotoView *photoView = [self photoViewForPage:_currentPage];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            _startLocation = location;
            [self handlePanBegin];
            break;
        case UIGestureRecognizerStateChanged: {
            photoView.imageView.transform = CGAffineTransformMakeTranslation(0, point.y);
            double percent = 1 - fabs(point.y)/(self.view.frame.size.height/2);
            self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:percent];
            _backgroundView.alpha = percent;
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (fabs(point.y) > 200 || fabs(velocity.y) > 500) {
                [self showSlideCompletionAnimationFromPoint:point];
            } else {
                [self showCancellationAnimation];
            }
        }
            break;
            
        default:
            break;
    }
}

- (UIImage *)screenshot {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, YES, [UIScreen mainScreen].scale);
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)blurBackgroundWithImage:(UIImage *)image animated:(BOOL)animated {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *blurImage = [image yy_imageByBlurDark];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (animated) {
                [UIView animateWithDuration:kAnimationDuration animations:^{
                    _backgroundView.alpha = 0;
                } completion:^(BOOL finished) {
                    _backgroundView.image = blurImage;
                    [UIView animateWithDuration:kAnimationDuration animations:^{
                        _backgroundView.alpha = 1;
                    } completion:nil];
                }];
            } else {
                _backgroundView.image = blurImage;
            }
        });
    });
}

- (void)configPhotoView:(KSPhotoView *)photoView withItem:(KSPhotoItem *)item {
    [photoView setItem:item determinate:(_loadingStyle == KSPhotoBrowserImageLoadingStyleDeterminate)];
}

- (void)configPageLabelWithPage:(NSUInteger)page {
    _pageLabel.text = [NSString stringWithFormat:@"%lu / %lu", page+1, _photoItems.count];
}

- (void)handlePanBegin {
    KSPhotoView *photoView = [self photoViewForPage:_currentPage];
    [photoView cancelCurrentImageLoad];
    KSPhotoItem *item = [_photoItems objectAtIndex:_currentPage];
    [UIApplication sharedApplication].statusBarHidden = NO;
    photoView.progressLayer.hidden = YES;
    item.sourceView.alpha = 0;
}

// MARK: - Gesture Recognizer

- (void)addGestureRecognizer {
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.view addGestureRecognizer:singleTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
    [self.view addGestureRecognizer:longPress];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self.view addGestureRecognizer:pan];
}

- (void)didSingleTap:(UITapGestureRecognizer *)tap
{
    
    [self showDismissalAnimation];
    
}

- (void)didDoubleTap:(UITapGestureRecognizer *)tap {
    
    
    if ([[_photoItemsTypes objectAtIndex:_currentPage]isEqualToString:@"video"])
    {
     
    }
    else
    {
        KSPhotoView *photoView = [self photoViewForPage:_currentPage];
        KSPhotoItem *item = [_photoItems objectAtIndex:_currentPage];
        if (!item.finished) {
            return;
        }
        if (photoView.zoomScale > 1) {
            [photoView setZoomScale:1 animated:YES];
        } else {
            CGPoint location = [tap locationInView:self.view];
            CGFloat maxZoomScale = photoView.maximumZoomScale;
            CGFloat width = self.view.bounds.size.width / maxZoomScale;
            CGFloat height = self.view.bounds.size.height / maxZoomScale;
            [photoView zoomToRect:CGRectMake(location.x - width/2, location.y - height/2, width, height) animated:YES];
        }

        
    }
    
}

- (void)didLongPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state != UIGestureRecognizerStateBegan) {
        return;
    }
    KSPhotoView *photoView = [self photoViewForPage:_currentPage];
    UIImage *image = photoView.imageView.image;
    if (!image) {
        return;
    }
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        activityViewController.popoverPresentationController.sourceView = longPress.view;
        CGPoint point = [longPress locationInView:longPress.view];
        activityViewController.popoverPresentationController.sourceRect = CGRectMake(point.x, point.y, 1, 1);
    }
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)didPan:(UIPanGestureRecognizer *)pan {
    KSPhotoView *photoView = [self photoViewForPage:_currentPage];
    if (photoView.zoomScale > 1.1) {
        return;
    }
    
    switch (_dismissalStyle) {
        case KSPhotoBrowserInteractiveDismissalStyleRotation:
            [self performRotationWithPan:pan];
            break;
        case KSPhotoBrowserInteractiveDismissalStyleScale:
            [self performScaleWithPan:pan];
            break;
        case KSPhotoBrowserInteractiveDismissalStyleSlide:
            [self performSlideWithPan:pan];
            break;
        default:
            break;
    }
}

// MARK: - Animation

- (void)showCancellationAnimation {
    KSPhotoView *photoView = [self photoViewForPage:_currentPage];
    KSPhotoItem *item = [_photoItems objectAtIndex:_currentPage];
    item.sourceView.alpha = 1;
    if (!item.finished) {
        photoView.progressLayer.hidden = NO;
    }
    if (_bounces && _dismissalStyle == KSPhotoBrowserInteractiveDismissalStyleScale) {
        [UIView animateWithDuration:kSpringAnimationDuration delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:kNilOptions animations:^{
            photoView.imageView.transform = CGAffineTransformIdentity;
            self.view.backgroundColor = [UIColor blackColor];
            _backgroundView.alpha = 1;
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            [self configPhotoView:photoView withItem:item];
        }];
    } else {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            photoView.imageView.transform = CGAffineTransformIdentity;
            self.view.backgroundColor = [UIColor blackColor];
            _backgroundView.alpha = 1;
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            [self configPhotoView:photoView withItem:item];
        }];
    }
}

- (void)showRotationCompletionAnimationFromPoint:(CGPoint)point {
    KSPhotoView *photoView = [self photoViewForPage:_currentPage];
    BOOL startFromLeft = _startLocation.x < self.view.frame.size.width / 2;
    BOOL throwToTop = point.y < 0;
    CGFloat angle, toTranslationY;
    if (throwToTop) {
        angle = startFromLeft ? (M_PI / 2) : -(M_PI / 2);
        toTranslationY = -self.view.frame.size.height;
    } else {
        angle = startFromLeft ? -(M_PI / 2) : (M_PI / 2);
        toTranslationY = self.view.frame.size.height;
    }
    
    CGFloat angle0 = 0;
    if (_startLocation.x < self.view.frame.size.width/2) {
        angle0 = -(M_PI / 2) * (point.y / self.view.frame.size.height);
    } else {
        angle0 = (M_PI / 2) * (point.y / self.view.frame.size.height);
    }
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @(angle0);
    rotationAnimation.toValue = @(angle);
    CABasicAnimation *translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    translationAnimation.fromValue = @(point.y);
    translationAnimation.toValue = @(toTranslationY);
    CAAnimationGroup *throwAnimation = [CAAnimationGroup animation];
    throwAnimation.duration = kAnimationDuration;
    throwAnimation.delegate = self;
    throwAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    throwAnimation.animations = @[rotationAnimation, translationAnimation];
    [throwAnimation setValue:@"throwAnimation" forKey:@"id"];
    [photoView.imageView.layer addAnimation:throwAnimation forKey:@"throwAnimation"];
    
    CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
    CGAffineTransform translation = CGAffineTransformMakeTranslation(0, toTranslationY);
    CGAffineTransform transform = CGAffineTransformConcat(rotation, translation);
    photoView.imageView.transform = transform;
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.view.backgroundColor = [UIColor clearColor];
        _backgroundView.alpha = 0;
    } completion:nil];
}

- (void)showDismissalAnimation
{
    
    if ([[_photoItemsTypes objectAtIndex:_currentPage]isEqualToString:@"video"])
    {
        NSURL *url = [NSURL URLWithString:[_mediaPaths objectAtIndex:_currentPage]];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];

        AVURLAsset *asset = [AVURLAsset assetWithURL: url];
        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset: asset];
        
        AVPlayer * player = [[AVPlayer alloc] initWithPlayerItem: item];
        playerViewController.player = player;
        playerViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        playerViewController.showsPlaybackControls = YES;
        [self presentViewController:playerViewController animated:YES completion:nil];
        [player play];
    }
    else
    {
        KSPhotoItem *item = [_photoItems objectAtIndex:_currentPage];
        KSPhotoView *photoView = [self photoViewForPage:_currentPage];
        [photoView cancelCurrentImageLoad];
        [UIApplication sharedApplication].statusBarHidden = NO;
        
        if (item.sourceView == nil) {
            [UIView animateWithDuration:kAnimationDuration animations:^{
                self.view.alpha = 0;
            } completion:^(BOOL finished) {
                [self dismissAnimated:NO];
            }];
            return;
        }
        
        photoView.progressLayer.hidden = YES;
        item.sourceView.alpha = 0;
        CGRect sourceRect;
        float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (systemVersion >= 8.0 && systemVersion < 9.0) {
            sourceRect = [item.sourceView.superview convertRect:item.sourceView.frame toCoordinateSpace:photoView];
        } else {
            sourceRect = [item.sourceView.superview convertRect:item.sourceView.frame toView:photoView];
        }
        if (_bounces) {
            [UIView animateWithDuration:kSpringAnimationDuration delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:kNilOptions animations:^{
                photoView.imageView.frame = sourceRect;
                self.view.backgroundColor = [UIColor clearColor];
                _backgroundView.alpha = 0;
            } completion:^(BOOL finished) {
                [self dismissAnimated:NO];
            }];
        } else {
            [UIView animateWithDuration:kAnimationDuration animations:^{
                photoView.imageView.frame = sourceRect;
                self.view.backgroundColor = [UIColor clearColor];
                _backgroundView.alpha = 0;
            } completion:^(BOOL finished) {
                [self dismissAnimated:NO];
            }];
        }
 
    }
}

- (void)showSlideCompletionAnimationFromPoint:(CGPoint)point {
    KSPhotoView *photoView = [self photoViewForPage:_currentPage];
    BOOL throwToTop = point.y < 0;
    CGFloat toTranslationY = 0;
    if (throwToTop) {
        toTranslationY = -self.view.frame.size.height;
    } else {
        toTranslationY = self.view.frame.size.height;
    }
    [UIView animateWithDuration:kAnimationDuration animations:^{
        photoView.imageView.transform = CGAffineTransformMakeTranslation(0, toTranslationY);
        self.view.backgroundColor = [UIColor clearColor];
        _backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissAnimated:YES];
    }];
}

// MARK: - Animation Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:@"id"] isEqualToString:@"throwAnimation"]) {
        [self dismissAnimated:YES];
    }
}

// MARK: - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateReusableItemViews];
    [self configItemViews];
}

@end
