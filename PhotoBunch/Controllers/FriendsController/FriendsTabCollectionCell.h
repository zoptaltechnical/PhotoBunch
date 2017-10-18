//
//  FriendsTabCollectionCell.h
//  PhotoBunch
//
//  Created by Gorav Grover on 30/05/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsTabCollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *profileName;
@property (strong, nonatomic) IBOutlet UIButton *messageBtn;
@property (strong, nonatomic) IBOutlet UIButton *linkBtn;
@property (strong, nonatomic) IBOutlet UIButton *acceptBtn;
@property (strong, nonatomic) IBOutlet UIButton *rejectBtn;
@property (strong, nonatomic) IBOutlet UIButton *unFavBtn;

@end
