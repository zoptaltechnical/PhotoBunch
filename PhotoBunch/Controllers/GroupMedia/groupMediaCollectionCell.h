//
//  groupMediaCollectionCell.h
//  PhotoBunch
//
//  Created by Gorav Grover on 28/06/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface groupMediaCollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIButton *mediaCell;
@property (strong, nonatomic) IBOutlet UIImageView *mediaImage;
@property (weak, nonatomic) IBOutlet UIImageView *playImage;

@end
