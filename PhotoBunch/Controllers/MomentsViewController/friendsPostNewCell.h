//
//  friendsPostNewCell.h
//  PhotoBunch
//
//  Created by Gorav Grover on 09/08/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface friendsPostsCollectionView : UICollectionView

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
@interface friendsPostNewCell : UITableViewCell


- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;


@property (strong, nonatomic) IBOutlet UIImageView *friendIcon;
@property (strong, nonatomic) IBOutlet UILabel *friendName;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;

@property (strong, nonatomic) IBOutlet friendsPostsCollectionView *friendCollections;

@property (strong, nonatomic) IBOutlet UIImageView *sampleImage;



@end
