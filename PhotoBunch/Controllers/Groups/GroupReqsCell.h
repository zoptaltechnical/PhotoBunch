//
//  GroupReqsCell.h
//  PhotoBunch
//
//  Created by Gorav Grover on 16/06/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupReqsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *rejectBtn;
@property (strong, nonatomic) IBOutlet UIButton *acceptbtn;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;

@end
