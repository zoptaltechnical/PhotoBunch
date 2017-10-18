//
//  friendsPostNewCell.m
//  PhotoBunch
//
//  Created by Gorav Grover on 09/08/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import "friendsPostNewCell.h"
@implementation friendsPostsCollectionView

@end
@implementation friendsPostNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath
{
    _friendCollections.dataSource = dataSourceDelegate;
    _friendCollections.delegate = dataSourceDelegate;
    _friendCollections.indexPath = indexPath;
    [_friendCollections setContentOffset:_friendCollections.contentOffset animated:NO];
    
    [_friendCollections reloadData];
}

@end
