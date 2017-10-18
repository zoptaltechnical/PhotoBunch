//
//  MainTabController.h
//  PhotoBunch
//
//  Created by Gorav Grover on 25/05/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabController : UITabBarController
@property(nonatomic, weak) IBOutlet UIViewController *plusController;
@property(nonatomic, weak) IBOutlet UIButton *centerButton;

@property(nonatomic, assign) BOOL tabBarHidden;

-(void)addCenterButtonWithImage:(UIImage *)buttonImage highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action;

@end
