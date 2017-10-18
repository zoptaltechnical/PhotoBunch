//
//  NotificationCell.h
//  PhotoBunch
//
//  Created by Gorav Grover on 19/06/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *notificationText;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;

@end
