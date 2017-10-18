//
//  postCell.h
//  PhotoBunch
//
//  Created by Gorav Grover on 15/06/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface postCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *postOwnerImage;
@property (strong, nonatomic) IBOutlet UILabel *ownerName;
@property (strong, nonatomic) IBOutlet UILabel *postTiming;
@property (strong, nonatomic) IBOutlet UIImageView *postImage;

@end
