//
//  SYTabBarController.m
//  自定义IUTabBar
//
//  Created by 刘一峰 on 2016/12/18.
//  Copyright © 2016年 刘一峰. All rights reserved.
//

#import "SYTabBarController.h"


#import "MomentsViewController.h"
#import "FriendsViewController.h"
#import "GroupsViewController.h"
#import "ProfileViewController.h"


#import "SYTabBar.h"
@interface SYTabBarController ()<SYTabBarDelegate,UITabBarDelegate>
@end

@implementation SYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    SYTabBar *tabbar = [[SYTabBar alloc]init];
    tabbar.SYDelegate = self;
    tabbar.delegate = self;

    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }
                                             forState:UIControlStateSelected];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
    tabbar.backgroundImage = [UIImage imageNamed:@"backgroundTB"];

    [self.tabBar addSubview:tabbar];
    [self setValue:tabbar forKey:@"tabBar"];
   // self.view.backgroundColor = [UIColor whiteColor];
    [self setupChildController];
    // Do any additional setup after loading the view.
}

- (void)setupChildController {
    
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    MomentsViewController *momentsViewController = [mystoryboard instantiateViewControllerWithIdentifier:@"MomentsViewControllerID"];
    momentsViewController.tabBarItem.title = @"MOMENTS";
    
    FriendsViewController *friendsViewController = [mystoryboard instantiateViewControllerWithIdentifier:@"FriendsViewControllerID"];
    momentsViewController.tabBarItem.title = @"FRIENDS";

    
    GroupsViewController *groupsViewController = [mystoryboard instantiateViewControllerWithIdentifier:@"GroupsViewControllerID"];
    momentsViewController.tabBarItem.title = @"GROUPS";

    ProfileViewController *profileViewController = [mystoryboard instantiateViewControllerWithIdentifier:@"ProfileViewControllerID"];
    momentsViewController.tabBarItem.title = @"PROFILE";

    //CameraViewController *cameraViewController = [mystoryboard instantiateViewControllerWithIdentifier:@"CameraViewControllerID"];
   // momentsViewController.tabBarItem.title = @"VC";

 
    [self addChildViewController:momentsViewController];
    [self addChildViewController:friendsViewController];
    [self addChildViewController:groupsViewController];
    [self addChildViewController:profileViewController];
}

- (void)tabBarDidClickPlusButton:(UIButton *)tabBar titleInfo:(UILabel *)titleLabel {
    [tabBar setImage:[UIImage imageNamed:@"camera_iconTB"] forState:UIControlStateNormal];
    [titleLabel setTextColor:[UIColor blueColor]];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (![item.title isEqualToString:@""]) {
        [(SYTabBar *)self.tabBar resetPlusBtnStyle];
    }else {
        [super tabBar:tabBar didSelectItem:item];
    }
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
