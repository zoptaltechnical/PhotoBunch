//
//  groupsCell.h
//  PhotoBunch
//
//  Created by Gorav Grover on 29/05/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface GroupsPostsCollectionView : UICollectionView

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
@interface groupsCell : UITableViewCell


- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;


@property (strong, nonatomic) IBOutlet UIImageView *groupIcon;
@property (strong, nonatomic) IBOutlet UILabel *groupName;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;

@property (strong, nonatomic) IBOutlet GroupsPostsCollectionView *groupCollections;

@property (strong, nonatomic) IBOutlet UIImageView *sampleImage;



@end
