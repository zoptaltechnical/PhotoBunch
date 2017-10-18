//
//  groupsTableCell.m
//  PhotoBunch
//
//  Created by Gorav Grover on 30/05/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import "groupsTableCell.h"
@implementation GroupsPostsCollectionView1

@end
@implementation groupsTableCell

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
    _groupCollections.dataSource = dataSourceDelegate;
    _groupCollections.delegate = dataSourceDelegate;
    _groupCollections.indexPath = indexPath;
    [_groupCollections setContentOffset:_groupCollections.contentOffset animated:NO];
    
    [_groupCollections reloadData];
}


@end
