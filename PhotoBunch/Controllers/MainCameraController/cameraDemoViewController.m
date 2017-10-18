//
//  cameraDemoViewController.m
//  PhotoBunch
//
//  Created by Gorav Grover on 31/05/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import "cameraDemoViewController.h"
#import "FTPopOverMenu.h"
#import "filterCell.h"

@interface cameraDemoViewController ()
@property (strong, nonatomic) IBOutlet UIButton *cameraModeBtn;
@property (strong, nonatomic) IBOutlet UIButton *flashBtn;
@property (strong, nonatomic) IBOutlet UIButton *activityBtn;
@property (strong, nonatomic) IBOutlet UIButton *snapShotBtn;
@property (strong, nonatomic) IBOutlet UIButton *filterBtn;
@property (strong, nonatomic) IBOutlet UIButton *pointsBtn;
@property (strong, nonatomic) IBOutlet UICollectionView *filterCollectionView;

@end

@implementation cameraDemoViewController
{
    NSMutableArray*sampleCollectionIcons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    sampleCollectionIcons=[[NSMutableArray alloc]init];
        
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [_filterCollectionView setHidden:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)flashPressed:(id)sender {
}
- (IBAction)filterPressed:(id)sender {
    
    [_filterCollectionView setHidden:NO];
    [_filterCollectionView reloadData];

    
}
- (IBAction)pointsPressed:(id)sender {
}
- (IBAction)cameraPressed:(id)sender {
}
- (IBAction)activityPressed:(id)sender {
    
    [FTPopOverMenu showForSender:sender
                        withMenu:@[@"",@"",@"",@""]
                  imageNameArray:@[@"MomentsTabInactive",@"FriendsTab_Inactive",@"GroupTabInactive",@"ProfileTabInactive"]
                       doneBlock:^(NSInteger selectedIndex) {
                     
                           
                           [self dismissViewControllerAnimated:YES completion:^{
                              
                               
                           }];
                           
                           
                           
                       } dismissBlock:^{
                           
                           NSLog(@"user canceled. do nothing.");
                           
                       }];
    
    
}
- (IBAction)cameraModePressed:(id)sender
{


}


#pragma mark
#pragma mark- CollectionView
#pragma mark

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   
    return 5;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
        filterCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"filterCellID" forIndexPath:indexPath];
        
    cell.filterImage.image=[sampleCollectionIcons objectAtIndex:indexPath.row];
    cell.filterName.text=@"Filter";

        return cell;
        
   
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
}
- (CGSize)collectionView:(UICollectionView* )collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath* )indexPath
{
    
    return CGSizeMake(80, 70);
    
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
