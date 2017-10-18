//
//  groupsTableCell.h
//  PhotoBunch
//
//  Created by Gorav Grover on 30/05/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface GroupsPostsCollectionView1 : UICollectionView

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
@interface groupsTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *groupName;
@property (strong, nonatomic) IBOutlet UILabel *numberOfPosts;
@property (strong, nonatomic) IBOutlet UIImageView *groupImage;
@property (strong, nonatomic) IBOutlet UIButton *openGroupBtn;
@property (strong, nonatomic) IBOutlet UIButton *memberOne;
@property (strong, nonatomic) IBOutlet UIButton *memberTwo;
@property (strong, nonatomic) IBOutlet UIButton *memberThree;
@property (strong, nonatomic) IBOutlet UIButton *otherMembers;
@property (weak, nonatomic) IBOutlet UILabel *numberOfMembers;

@property (strong, nonatomic) IBOutlet GroupsPostsCollectionView1 *groupCollections;

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;


@end
