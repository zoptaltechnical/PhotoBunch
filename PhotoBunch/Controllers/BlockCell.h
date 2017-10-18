//
//  BlockCell.h
//  PhotoBunch
//
//  Created by Gorav Grover on 14/10/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UIButton *blockBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@end
