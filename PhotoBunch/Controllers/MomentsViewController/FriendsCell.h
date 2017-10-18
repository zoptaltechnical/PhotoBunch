//
//  FriendsCell.h
//  PhotoBunch
//
//  Created by Gorav Grover on 29/05/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *friendIcon;
@property (strong, nonatomic) IBOutlet UILabel *friendName;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;
@property (strong, nonatomic) IBOutlet UILabel *postCaption;

@property (strong, nonatomic) IBOutlet UIImageView *postImage;
@end
