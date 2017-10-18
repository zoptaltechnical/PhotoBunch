//
//  InviteFriendsViewController.m
//  PhotoBunch
//
//  Created by Gorav Grover on 31/05/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "inviteFriendsGroupCell.h"

@interface InviteFriendsViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *mainCollectionView;

@end

@implementation InviteFriendsViewController
{
    NSMutableArray*friendsIcons,*friendsArray;

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    friendsIcons=[[NSMutableArray alloc]init];
    friendsArray=[[NSMutableArray alloc]init];
    [_mainCollectionView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtnPressed:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark- CollectionView
#pragma mark

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [friendsArray count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    inviteFriendsGroupCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"inviteFriendsGroupCellID" forIndexPath:indexPath];
    
    [cell.backImage setImage:[friendsIcons objectAtIndex:indexPath.row]];
    cell.profileName.text=[friendsArray objectAtIndex:indexPath.row];
    
    cell.backImage.layer.cornerRadius = cell.backImage.frame.size.height/2;
    cell.backImage.clipsToBounds = YES;
    
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
}
- (CGSize)collectionView:(UICollectionView* )collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath* )indexPath
{
    
    return CGSizeMake(173, 165);
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
