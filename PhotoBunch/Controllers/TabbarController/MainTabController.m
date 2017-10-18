//
//  MainTabController.m
//  PhotoBunch
//
//  Created by Gorav Grover on 25/05/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import "MainTabController.h"
#import "cameraDemoViewController.h"

#import "WTCameraViewController.h"
const CGFloat kBarHeight = 80;

@interface MainTabController ()

@end

@implementation MainTabController
@synthesize plusController;
@synthesize centerButton;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addCenterButtonWithImage:[UIImage imageNamed:@"camera_iconTB"] highlightImage:[UIImage imageNamed:@"camera_iconWhTB"] target:self action:@selector(buttonPressed:)];
    
    UITabBar *tabBar = self.tabBar;
    
    if ([tabBar respondsToSelector:@selector(setBackgroundImage:)])
    {
        tabBar.backgroundImage = [UIImage imageNamed:@"backgroundTB"];
    }
    
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//- (void)viewWillLayoutSubviews {
//    
//    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
//    tabFrame.size.height = kBarHeight;
//    tabFrame.origin.y = self.view.frame.size.height - kBarHeight;
//    self.tabBar.frame = tabFrame;
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Create a custom UIButton and add it to the center of our tab bar
- (void)addCenterButtonWithImage:(UIImage *)buttonImage highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0,0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
     button.center = self.tabBar.center;
    button.frame=CGRectMake(button.frame.origin.x, button.frame.origin.y-35, button.frame.size.width, button.frame.size.height);
    
    
    
//    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
//    if (heightDifference < 0) {
//       
//    } else {
//        CGPoint center = self.tabBar.center;
//        center.y = center.y - heightDifference/2.0;
//        button.center = center;
//    }
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    self.centerButton = button;
}

- (void)buttonPressed:(id)sender
{
    WTCameraViewController *cameraViewController = [[WTCameraViewController alloc]init];
    [self presentViewController:cameraViewController animated:YES completion:^{
        
    }];
  //  [self setSelectedIndex:2];
   // [self performSelector:@selector(doHighlight:) withObject:sender afterDelay:0];
    
    
    
}

- (void)doHighlight:(UIButton*)b {
    [b setHighlighted:YES];
}

- (void)doNotHighlight:(UIButton*)b
{
    [b setHighlighted:NO];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(self.tabBarController.selectedIndex != 2)
    {
        [self performSelector:@selector(doNotHighlight:) withObject:centerButton afterDelay:0];
    }
    NSUInteger indexOfTab = [[tabBar items] indexOfObject:item];

    if (indexOfTab==2)
    {
        self.selectedIndex=1;
    }
}

- (BOOL)tabBarHidden {
    return self.centerButton.hidden && self.tabBar.hidden;
}

- (void)setTabBarHidden:(BOOL)tabBarHidden
{
    self.centerButton.hidden = tabBarHidden;
    self.tabBar.hidden = tabBarHidden;
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
