//
//  GroupsViewController.m
//  PhotoBunch
//
//  Created by Gorav Grover on 30/05/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import "GroupsViewController.h"
#import "Constant.h"
#import "groupsTableCell.h"
#import "CreateGroupViewController.h"
#import "groupInCellCell.h"
#import "JoinGroupControllerViewController.h"
#import "PostDetailsViewController.h"
#import "GroupReqsCell.h"
#import "UIButton+WebCache.h"
#import "GroupMediaViewController.h"
#import "FriendsProfileViewController.h"
#import "QRCodeReaderViewController.h"

@interface GroupsViewController ()<joinGroupDelegate>
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UIButton *groupsBtn;
@property (strong, nonatomic) IBOutlet UIButton *openGroupsBtn;
@property (strong, nonatomic) IBOutlet UIButton *discoverBtn;
@property (strong, nonatomic) IBOutlet UIButton *groupsJoinedBtn;
@property (strong, nonatomic) IBOutlet UIButton *myGroupsBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopCons;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;

@property (nonatomic, strong) NSArray *myGroupsArray;
@property (nonatomic, strong) NSArray *myGroupsPostsArray;
@property (nonatomic, strong) NSMutableDictionary *myGroupsDict;

@property (nonatomic, strong) NSArray *myJoinedArray;
@property (nonatomic, strong) NSArray *myJoinedPostsArray;
@property (nonatomic, strong) NSMutableDictionary *myJoinedDict;

@property (nonatomic, strong) NSArray *openGroupArray;
@property (nonatomic, strong) NSArray *openGroupPostsArray;
@property (nonatomic, strong) NSMutableDictionary *openGroupDict;

@property (nonatomic, strong) NSArray *searchGroupArray;
@property (nonatomic, strong) NSArray *searchGroupPostsArray;
@property (nonatomic, strong) NSMutableDictionary *searchGroupDict;

@property (nonatomic, strong) NSArray *discoverGroupArray;
@property (nonatomic, strong) NSArray *discoverGroupPostsArray;
@property (nonatomic, strong) NSMutableDictionary *discoverGroupDict;
@property (strong, nonatomic) IBOutlet UIView *groupRequestView;
@property (strong, nonatomic) IBOutlet UITableView *groupReqTableView;

@property (strong, nonatomic) IBOutlet UIButton *crossGroupReq;


@property (strong, nonatomic) IBOutlet UIButton *openGroupReqsBtn;

@end

@implementation GroupsViewController
{
    

    NSString*selectionString;
    BOOL isMygroup;
    NSMutableArray*groupReqs,*joinReqs,*searchArray;
    
    __weak IBOutlet UIImageView *noGroupFoundAlert;
    IBOutlet UILabel *noGroupsFoundLbl;
    BOOL isSearchBegin;
    BOOL isSearchResult;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    selectionString=@"1";
    isMygroup=YES;
    [_openGroupReqsBtn setHidden:NO];
    [_openGroupReqsBtn setTitle:@"Group Request" forState:UIControlStateNormal];
  _topTitleLabel.text=@"Group Request";
    [_groupsJoinedBtn setBackgroundColor:rGBColor(235,239,242)];
    [_groupsJoinedBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_myGroupsBtn setBackgroundColor:rGBColor(21, 165, 230)];
    [_myGroupsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_groupsBtn setBackgroundColor:rGBColor(21, 165, 230)];
    [_groupsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_openGroupsBtn setBackgroundColor:rGBColor(235,239,242)];
    [_openGroupsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_discoverBtn setBackgroundColor:rGBColor(235,239,242)];
    [_discoverBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_groupsJoinedBtn setHidden:NO];
    [_myGroupsBtn setHidden:NO];
    _tableViewTopCons.constant=60;
    
    groupReqs=[[NSMutableArray alloc]init];
    joinReqs=[[NSMutableArray alloc]init];

    [_groupRequestView setHidden:YES];
    
   
    
    _groupReqTableView.tableFooterView=[UIView new];
    
    
    
    [noGroupsFoundLbl setHidden:YES];
    
    [noGroupFoundAlert setHidden:YES];
    
    [_mainTableView setHidden:YES];
    
    [self callMyGroupsApi];
    
    
    
    
   
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteGroup:)
                                                 name:@"DeleteGroup"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newCreateGroup:)
                                                 name:@"NewCreatedGroup"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(leaveGroup:)
                                                 name:@"LeaveGroup"
                                               object:nil];
    

}

-(void)newCreateGroup:(NSNotification*)obj
{
    
    [self myGroupsPressed:_myGroupsBtn];

}
-(void)deleteGroup:(NSNotification*)obj
{
    [self myGroupsPressed:_myGroupsBtn];
}
-(void)leaveGroup:(NSNotification*)obj
{
    
    [self groupsJoinedPressed:_groupsBtn];

//    [self callMyGroupsApi];
//    
//    isSearchBegin=NO;
//    isSearchResult=NO;
//    [_searchBar endEditing:YES];
//    _searchBar.text=@"";
//    
//    [_openGroupReqsBtn setHidden:NO];
//    [_openGroupReqsBtn setTitle:@"Invitations" forState:UIControlStateNormal];
//      _topTitleLabel.text=@"Invitations";
//    [_groupsJoinedBtn setBackgroundColor:rGBColor(21, 165, 230)];
//    [_groupsJoinedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_myGroupsBtn setBackgroundColor:rGBColor(235,239,242)];
//    [_myGroupsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    isMygroup=NO;
//    [_mainTableView reloadData];

}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Open Btn Pressed
- (IBAction)openBtnPressed:(UIButton*)sender
{
    if (isSearchBegin)
    {
        GroupMediaViewController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"GroupMediaViewControllerID"];
        tabBarController.groupID=[[_searchGroupPostsArray objectAtIndex:sender.tag]valueForKey:@"id"];
        tabBarController.delegate=self;
        
        
        
        if ([[[_searchGroupPostsArray objectAtIndex:sender.tag] valueForKey:@"user_id"] integerValue]==[[[UserDefaultHandler getFullInfo] valueForKey:@"id"]integerValue])
        {
            
            
        }
        else if ([[[_searchGroupPostsArray objectAtIndex:sender.tag] valueForKey:@"is_member"] integerValue]==1)
        {
            
            
        }
        else
        {
            tabBarController.PopUpStringID=@"0";
            
        }
        
        [self.navigationController pushViewController:tabBarController animated:YES];
    }
    else
    {
    if ([selectionString isEqualToString:@"1"])
    {
        if (isMygroup)
        {
       
            
            GroupMediaViewController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"GroupMediaViewControllerID"];
            tabBarController.groupID=[[_myGroupsPostsArray objectAtIndex:sender.tag]valueForKey:@"id"];
            tabBarController.delegate=self;

            [self.navigationController pushViewController:tabBarController animated:YES];


        }
        else
        {
            
            GroupMediaViewController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"GroupMediaViewControllerID"];
            tabBarController.groupID=[[_myJoinedPostsArray objectAtIndex:sender.tag]valueForKey:@"id"];
            tabBarController.delegate=self;
            
            
            if ([[[_myJoinedPostsArray objectAtIndex:sender.tag] valueForKey:@"user_id"] integerValue]==[[[UserDefaultHandler getFullInfo] valueForKey:@"id"]integerValue])
            {
                
                
            }
            else if ([[[_searchGroupPostsArray objectAtIndex:sender.tag] valueForKey:@"is_member"] integerValue]==1)
            {
                
                
            }
            else
            {
                tabBarController.PopUpStringID=@"0";
                
            }

            
            

            [self.navigationController pushViewController:tabBarController animated:YES];
            
        }
        
        
    }
    else if ([selectionString isEqualToString:@"2"])
        
    {
        
        GroupMediaViewController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"GroupMediaViewControllerID"];
        tabBarController.groupID=[[_openGroupPostsArray objectAtIndex:sender.tag]valueForKey:@"id"];
        tabBarController.PopUpStringID=@"0";
        tabBarController.delegate=self;

        [self.navigationController pushViewController:tabBarController animated:YES];

        
    }
    else if ([selectionString isEqualToString:@"3"])
    {
        GroupMediaViewController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"GroupMediaViewControllerID"];
        tabBarController.groupID=[[_discoverGroupPostsArray objectAtIndex:sender.tag]valueForKey:@"id"];
        tabBarController.PopUpStringID=@"0";

        tabBarController.delegate=self;

        [self.navigationController pushViewController:tabBarController animated:YES];

    }
    
    }
}
- (IBAction)createNewGroupPressed:(id)sender
{
    
    CreateGroupViewController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateGroupViewControllerID"];
    [self.navigationController pushViewController:tabBarController animated:YES];

    
}
-(void)joinGroupNotification
{
    [self groupsPressed:_groupsBtn];
}



- (IBAction)groupsPressed:(id)sender
{
    
    isSearchBegin=NO;
    isSearchResult=NO;
    [_searchBar endEditing:YES];
    _searchBar.text=@"";

    selectionString=@"1";

    [_openGroupReqsBtn setHidden:NO];

    [_groupsBtn setBackgroundColor:rGBColor(21, 165, 230)];
    [_groupsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_openGroupsBtn setBackgroundColor:rGBColor(235,239,242)];
    [_openGroupsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_discoverBtn setBackgroundColor:rGBColor(235,239,242)];
    [_discoverBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _tableViewTopCons.constant=60;
    [_groupsJoinedBtn setHidden:NO];
    [_myGroupsBtn setHidden:NO];
    [self callMyGroupsApi];

    
}
- (IBAction)openGroupPressed:(id)sender
{
    isSearchBegin=NO;
    isSearchResult=NO;
    [_searchBar endEditing:YES];
    _searchBar.text=@"";

    
    selectionString=@"2";
    [_openGroupReqsBtn setHidden:YES];

    [_groupsBtn setBackgroundColor:rGBColor(235,239,242)];
    [_groupsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_openGroupsBtn setBackgroundColor:rGBColor(21, 165, 230)];
    [_openGroupsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_discoverBtn setBackgroundColor:rGBColor(235,239,242)];
    [_discoverBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _tableViewTopCons.constant=15;
    [_groupsJoinedBtn setHidden:YES];
    [_myGroupsBtn setHidden:YES];
    
    [self callGetAllOpenGroups];

    
}
- (IBAction)discoverPressed:(id)sender
{
    
    isSearchBegin=NO;
    isSearchResult=NO;
    [_searchBar endEditing:YES];
    _searchBar.text=@"";

    selectionString=@"3";
    [_openGroupReqsBtn setHidden:YES];

    [_groupsBtn setBackgroundColor:rGBColor(235,239,242)];
    [_groupsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_openGroupsBtn setBackgroundColor:rGBColor(235,239,242)];
    [_openGroupsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_discoverBtn setBackgroundColor:rGBColor(21, 165, 230)];
    [_discoverBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _tableViewTopCons.constant=15;
    [_groupsJoinedBtn setHidden:YES];
    [_myGroupsBtn setHidden:YES];
    [self callGetAllDiscoverGroups];


}

- (IBAction)groupsJoinedPressed:(id)sender
{
    
    isSearchBegin=NO;
    isSearchResult=NO;
    [_searchBar endEditing:YES];
    _searchBar.text=@"";

    [_openGroupReqsBtn setHidden:NO];
    [_openGroupReqsBtn setTitle:@"Invitations" forState:UIControlStateNormal];
      _topTitleLabel.text=@"Invitations";
    [_groupsJoinedBtn setBackgroundColor:rGBColor(21, 165, 230)];
    [_groupsJoinedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myGroupsBtn setBackgroundColor:rGBColor(235,239,242)];
    [_myGroupsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    isMygroup=NO;
    [self callMyGroupsApi];

    [_mainTableView reloadData];

}


- (IBAction)myGroupsPressed:(id)sender
{
    [self callMyGroupsApi];

    isSearchBegin=NO;
    isSearchResult=NO;
    [_searchBar endEditing:YES];
    _searchBar.text=@"";

    [_groupsJoinedBtn setBackgroundColor:rGBColor(235,239,242)];
    [_groupsJoinedBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_myGroupsBtn setBackgroundColor:rGBColor(21, 165, 230)];
    [_myGroupsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_openGroupReqsBtn setHidden:NO];
    [_openGroupReqsBtn setTitle:@"Group Request" forState:UIControlStateNormal];
_topTitleLabel.text=@"Group Request";
    isMygroup=YES;
    [_mainTableView reloadData];


}

#pragma mark
#pragma mark- UITableView
#pragma mark


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    if (tableView==_groupReqTableView)
    {
        if (isMygroup)
        {
            return [groupReqs count];

        }
        else
        {
            return [joinReqs count];

        }
    }
    else
    {
        if (isSearchBegin)
        {
            return [_searchGroupPostsArray count];

        }
        else
        {
        if ([selectionString isEqualToString:@"1"])
        {
            
            if (isMygroup)
            {
                
                if (_myGroupsPostsArray.count==0) {
                    [noGroupFoundAlert setHidden:NO];

                    [noGroupsFoundLbl setHidden:NO];
                    noGroupsFoundLbl.text=@"No Groups created by you yet!!";
                    [_mainTableView setHidden:YES];
                }
                else
                {
                    [noGroupFoundAlert setHidden:YES];

                    [noGroupsFoundLbl setHidden:YES];
                    [_mainTableView setHidden:NO];
                }
                
                return [_myGroupsPostsArray count];
                
            }
            else
            {
                if (_myJoinedPostsArray.count==0)
                {
                    [noGroupFoundAlert setHidden:NO];

                    [noGroupsFoundLbl setHidden:NO];
                    noGroupsFoundLbl.text=@"You Haven't joined any group!!";
                    [_mainTableView setHidden:YES];
                }
                else
                {
                    [noGroupFoundAlert setHidden:YES];

                    [noGroupsFoundLbl setHidden:YES];
                    [_mainTableView setHidden:NO];
                }

                
                return [_myJoinedPostsArray count];
                
            }
            
        }
        else if ([selectionString isEqualToString:@"2"])
        {
            if (_openGroupPostsArray.count==0) {
                [noGroupFoundAlert setHidden:NO];

                [noGroupsFoundLbl setHidden:NO];
                noGroupsFoundLbl.text=@"No Open groups found!!";
                [_mainTableView setHidden:YES];
            }
            else
            {
                [noGroupFoundAlert setHidden:YES];

                [noGroupsFoundLbl setHidden:YES];
                [_mainTableView setHidden:NO];
            }
            

            return [_openGroupPostsArray count];
            
        }
        else if ([selectionString isEqualToString:@"3"])
        {
            if (_discoverGroupPostsArray.count==0) {
                [noGroupFoundAlert setHidden:NO];

                [noGroupsFoundLbl setHidden:NO];
                noGroupsFoundLbl.text=@"No Discover groups found!!";
                [_mainTableView setHidden:YES];
            }
            else
            {
                [noGroupFoundAlert setHidden:YES];

                [noGroupsFoundLbl setHidden:YES];
                [_mainTableView setHidden:NO];
            }
            
            
            return [_discoverGroupPostsArray count];
        }
        else
        {
            return 0;
        }

    }
        return 0;

    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)TableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if (TableView==_groupReqTableView)
    {
        static NSString *MyIdentifier = @"GroupReqsCellID";
        
        GroupReqsCell *cell = [TableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            
            cell = [[GroupReqsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
            
        }
        
        cell.acceptbtn.tag=indexPath.row;
        cell.rejectBtn.tag=indexPath.row;
        
    
       NSMutableDictionary*dict;
        
        if (isMygroup)
        {
             dict=[groupReqs objectAtIndex:indexPath.row];
            
        }
        else
        {
             dict=[joinReqs objectAtIndex:indexPath.row];
            
        }
        
        if ([dict valueForKey:@"sender_image"])
        {
            if ([[dict valueForKey:@"sender_image"] length]>0) {
                [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"sender_image"]] placeholderImage:[UIImage imageNamed:@"groupSmallBack"] options:SDWebImageRefreshCached];
                
            }
            else
            {
                cell.profileImage.image=[UIImage imageNamed:@"groupSmallBack"];
            }
        }
        else
        {
            cell.profileImage.image=[UIImage imageNamed:@"groupSmallBack"];
            
        }
        if ([dict valueForKey:@"sender_name"])
        {
            if ([[dict valueForKey:@"sender_name"] length]>0) {
                
                
                if (isMygroup)
                {
                    
                    NSString*string=[dict valueForKey:@"sender_name"];
                    NSString*string1=[dict valueForKey:@"group_name"];
                    
                    cell.nameLbl.text=[NSString stringWithFormat:@"%@ has requested to join %@",string,string1];

                }
                else
                {
                    NSString*string=[dict valueForKey:@"sender_name"];
                    NSString*string1=[dict valueForKey:@"group_name"];
                    
                    cell.nameLbl.text=[NSString stringWithFormat:@"%@ invites you to join %@",string,string1];

                }

                
                
        }
            else
            {
                cell.nameLbl.text=@"";
            }
            
        }
        else
        {
            cell.nameLbl.text=@"";
            
        }
        
        return cell;

    }
    else
    {
    static NSString *MyIdentifier = @"groupsTableCellID";
    
    groupsTableCell *cell = [TableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        
        cell = [[groupsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
   
    }
    
    cell.openGroupBtn.tag=indexPath.row;
    
    NSDictionary*dict;

    if (isSearchBegin)
    {
            dict=[_searchGroupPostsArray objectAtIndex:indexPath.row];
        
            if ([[dict valueForKey:@"user_id"] integerValue]==[[[UserDefaultHandler getFullInfo] valueForKey:@"id"]integerValue])
            {
                [cell.openGroupBtn setTitle:@"OPEN" forState:UIControlStateNormal];
                [cell.openGroupBtn setBackgroundColor:rGBColor(2, 148, 213)];

            }
            else if ([[dict valueForKey:@"is_member"] integerValue]==1)
            {
                [cell.openGroupBtn setTitle:@"OPEN" forState:UIControlStateNormal];
                [cell.openGroupBtn setBackgroundColor:rGBColor(2, 148, 213)];

            }
            else
            {
                [cell.openGroupBtn setTitle:@"+ Join" forState:UIControlStateNormal];
                [cell.openGroupBtn setBackgroundColor:[UIColor grayColor]];
            }
            
    }
    else
    {
        
        
    if ([selectionString isEqualToString:@"1"])
    {
        
        if (isMygroup)
        {
            dict=[_myGroupsPostsArray objectAtIndex:indexPath.row];
            
        }
        else
        {
            
            dict=[_myJoinedPostsArray objectAtIndex:indexPath.row];

            
        }
       
        //    if ([[dict valueForKey:@"user_id"] integerValue]==[[[UserDefaultHandler getFullInfo] valueForKey:@"id"]integerValue])
        //    {
                [cell.openGroupBtn setTitle:@"OPEN" forState:UIControlStateNormal];
                [cell.openGroupBtn setBackgroundColor:rGBColor(2, 148, 213)];
                
//            }
//            else if ([[dict valueForKey:@"is_member"] integerValue]==1)
//            {
//                [cell.openGroupBtn setTitle:@"OPEN" forState:UIControlStateNormal];
//                [cell.openGroupBtn setBackgroundColor:rGBColor(2, 148, 213)];
//                
//            }
//            else
//            {
//                [cell.openGroupBtn setTitle:@"+ Join" forState:UIControlStateNormal];
//                [cell.openGroupBtn setBackgroundColor:[UIColor grayColor]];
//            }
            
        
    

        
        
    }
    else if ([selectionString isEqualToString:@"2"])
        
    {
        
            dict=[_openGroupPostsArray objectAtIndex:indexPath.row];
        
            if ([[dict valueForKey:@"user_id"] integerValue]==[[[UserDefaultHandler getFullInfo] valueForKey:@"id"]integerValue])
            {
                [cell.openGroupBtn setTitle:@"OPEN" forState:UIControlStateNormal];
                [cell.openGroupBtn setBackgroundColor:rGBColor(2, 148, 213)];
                
            }
            else if ([[dict valueForKey:@"is_member"] integerValue]==1)
            {
                [cell.openGroupBtn setTitle:@"OPEN" forState:UIControlStateNormal];
                [cell.openGroupBtn setBackgroundColor:rGBColor(2, 148, 213)];
                
            }
            else
            {
                [cell.openGroupBtn setTitle:@"+ Join" forState:UIControlStateNormal];
                [cell.openGroupBtn setBackgroundColor:[UIColor grayColor]];
            }
            

    }
    else if ([selectionString isEqualToString:@"3"])
    {
        dict=[_discoverGroupPostsArray objectAtIndex:indexPath.row];
       
            if ([[dict valueForKey:@"user_id"] integerValue]==[[[UserDefaultHandler getFullInfo] valueForKey:@"id"]integerValue])
            {
                [cell.openGroupBtn setTitle:@"OPEN" forState:UIControlStateNormal];
                [cell.openGroupBtn setBackgroundColor:rGBColor(2, 148, 213)];
                
            }
            else if ([[dict valueForKey:@"is_member"] integerValue]==1)
            {
                [cell.openGroupBtn setTitle:@"OPEN" forState:UIControlStateNormal];
                [cell.openGroupBtn setBackgroundColor:rGBColor(2, 148, 213)];
                
            }
            else
            {
                [cell.openGroupBtn setTitle:@"+ Join" forState:UIControlStateNormal];
                [cell.openGroupBtn setBackgroundColor:[UIColor grayColor]];
            }
            
     

    }
    }
        
        
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.height/2;
        cell.profilePic.clipsToBounds = YES;
        
        
        if ([dict valueForKey:@"group_image"])
        {
            if ([[dict valueForKey:@"group_image"] length]>0) {
                [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"group_image"]] placeholderImage:[UIImage imageNamed:@"groupSmallBack"] options:SDWebImageRefreshCached];
                
            }
            else
            {
                cell.profilePic.image=[UIImage imageNamed:@"groupSmallBack"];
            }
        }
        else
        {
            cell.profilePic.image=[UIImage imageNamed:@"groupSmallBack"];
            
        }
        
        
        
        

    cell.groupImage.layer.cornerRadius = cell.groupImage.frame.size.height/2;
    cell.groupImage.clipsToBounds = YES;
    
    
    if ([dict valueForKey:@"group_image"])
    {
        if ([[dict valueForKey:@"group_image"] length]>0) {
            [cell.groupImage sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"group_image"]] placeholderImage:[UIImage imageNamed:@"groupSmallBack"] options:SDWebImageRefreshCached];
            
        }
        else
        {
            cell.groupImage.image=[UIImage imageNamed:@"groupSmallBack"];
        }
    }
    else
    {
        cell.groupImage.image=[UIImage imageNamed:@"groupSmallBack"];
        
    }
    if ([dict valueForKey:@"group_name"])
    {
        if ([[dict valueForKey:@"group_name"] length]>0) {
            
            cell.groupName.text=[dict valueForKey:@"group_name"];
        }
        else
        {
            cell.groupName.text=@"";
        }
        
    }
    else
    {
        cell.groupName.text=@"";
        
    }

        if ([dict valueForKey:@"posts_count"])
        {
            if ([dict valueForKey:@"posts_count"] )
            {
                
                cell.numberOfPosts.text=[NSString stringWithFormat:@"%@ Posts",[dict valueForKey:@"posts_count"]];
            }
            else
            {
                cell.numberOfPosts.text=@"";
            }
            
        }
        else
        {
            cell.numberOfPosts.text=@"";
            
        }
        if ([dict valueForKey:@"members_count"])
        {
            if ([dict valueForKey:@"members_count"] )
            {
                if ([[dict valueForKey:@"members_count"]integerValue]==1) {
                    cell.numberOfMembers.text=[NSString stringWithFormat:@"%@ Member",[dict valueForKey:@"members_count"]];

                }
                else
                {
                    cell.numberOfMembers.text=[NSString stringWithFormat:@"%@ Members",[dict valueForKey:@"members_count"]];

                }
            }
            else
            {
                cell.numberOfMembers.text=@"";
            }
            
        }
        else
        {
            cell.numberOfMembers.text=@"";
            
        }
        
        
        
        
        cell.memberOne.layer.cornerRadius = cell.memberOne.frame.size.height/2;
        cell.memberOne.clipsToBounds = YES;
        cell.memberOne.tag = indexPath.row;


        cell.memberTwo.layer.cornerRadius = cell.memberTwo.frame.size.height/2;
        cell.memberTwo.clipsToBounds = YES;
        cell.memberTwo.tag = indexPath.row;

        cell.memberThree.layer.cornerRadius = cell.memberThree.frame.size.height/2;
        cell.memberThree.clipsToBounds = YES;
        cell.memberThree.tag = indexPath.row;

        cell.otherMembers.layer.cornerRadius = cell.otherMembers.frame.size.height/2;
        cell.otherMembers.clipsToBounds = YES;
        cell.otherMembers.tag = indexPath.row;

        
        
        if ([dict valueForKey:@"group_members"])
        {
            if ([[dict valueForKey:@"group_members"] count]>0)
            {
                if ([[dict valueForKey:@"group_members"] count]==1)
                {
                        [cell.memberOne sd_setBackgroundImageWithURL:[NSURL URLWithString:[[[dict valueForKey:@"group_members"] objectAtIndex:0] valueForKey:@"profile_pic"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"maleBack"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                        {
                            
                        }];
                    [cell.memberOne setHidden:NO];
                    [cell.memberTwo setHidden:YES];
                    [cell.memberThree setHidden:YES];
                    [cell.otherMembers setHidden:YES];

                    
                }
                else if ([[dict valueForKey:@"group_members"] count]==2)
                {
                    [cell.memberOne sd_setBackgroundImageWithURL:[NSURL URLWithString:[[[dict valueForKey:@"group_members"] objectAtIndex:0] valueForKey:@"profile_pic"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"maleBack"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                     {
                         
                     }];
                    [cell.memberTwo sd_setBackgroundImageWithURL:[NSURL URLWithString:[[[dict valueForKey:@"group_members"] objectAtIndex:1] valueForKey:@"profile_pic"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"maleBack"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                     {
                         
                     }];
                    [cell.memberOne setHidden:NO];
                    [cell.memberTwo setHidden:NO];
                    [cell.memberThree setHidden:YES];
                    [cell.otherMembers setHidden:YES];


                }
                else if ([[dict valueForKey:@"group_members"] count]==3)
                {
                    [cell.memberOne sd_setBackgroundImageWithURL:[NSURL URLWithString:[[[dict valueForKey:@"group_members"] objectAtIndex:0] valueForKey:@"profile_pic"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"maleBack"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                     {
                         
                     }];
                    [cell.memberTwo sd_setBackgroundImageWithURL:[NSURL URLWithString:[[[dict valueForKey:@"group_members"] objectAtIndex:1] valueForKey:@"profile_pic"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"maleBack"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                     {
                         
                     }];
                    [cell.memberThree sd_setBackgroundImageWithURL:[NSURL URLWithString:[[[dict valueForKey:@"group_members"] objectAtIndex:2] valueForKey:@"profile_pic"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"maleBack"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                     {
                         
                     }];
                    
                    [cell.memberOne setHidden:NO];
                    [cell.memberTwo setHidden:NO];
                    [cell.memberThree setHidden:NO];
                    [cell.otherMembers setHidden:YES];

                    
                }
                if ([[dict valueForKey:@"members_count"] integerValue]>3)
                {
                    [cell.memberOne sd_setBackgroundImageWithURL:[NSURL URLWithString:[[[dict valueForKey:@"group_members"] objectAtIndex:0] valueForKey:@"profile_pic"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"maleBack"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                     {
                         
                     }];
                    [cell.memberTwo sd_setBackgroundImageWithURL:[NSURL URLWithString:[[[dict valueForKey:@"group_members"] objectAtIndex:1] valueForKey:@"profile_pic"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"maleBack"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                     {
                         
                     }];
                    [cell.memberThree sd_setBackgroundImageWithURL:[NSURL URLWithString:[[[dict valueForKey:@"group_members"] objectAtIndex:2] valueForKey:@"profile_pic"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"maleBack"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                     {
                         
                     }];
                    
                    [cell.otherMembers setTitle:[NSString stringWithFormat:@"+%d",[[dict valueForKey:@"members_count"]integerValue]-3] forState:UIControlStateNormal];
                    
                    [cell.memberOne setHidden:NO];
                    [cell.memberTwo setHidden:NO];
                    [cell.memberThree setHidden:NO];
                    [cell.otherMembers setHidden:NO];
                    
                }
                
            }

        }

                
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if (tableView==_groupReqTableView)
    {
        return 110;
    }
    else
    {
        
    if (isSearchBegin)
    {
        
        if ([[[_searchGroupPostsArray objectAtIndex:indexPath.row]valueForKey:@"group_posts"]count]>0)
        {
            
            if ([[[_searchGroupPostsArray objectAtIndex:indexPath.row]valueForKey:@"privacy_type"]integerValue]==3||[[[_searchGroupPostsArray objectAtIndex:indexPath.row]valueForKey:@"privacy_type"]integerValue]==2)
            {
                if ([[[_searchGroupPostsArray objectAtIndex:indexPath.row] valueForKey:@"user_id"] integerValue]==[[[UserDefaultHandler getFullInfo] valueForKey:@"id"]integerValue])
                {
                 
                    return 225.0;
                }
                else if ([[[_searchGroupPostsArray objectAtIndex:indexPath.row] valueForKey:@"is_member"] integerValue]==1)
                {
                    return 225.0;
                }
                else
                {
                    return 65.0;
                }
                
            }
            else
            {
               return 225.0;
            }
            
            
        
        
        }
        else
        {
            return 65.0;
        }
    }
    else
    {
    if ([selectionString isEqualToString:@"1"])
    {
        
        if (isMygroup)
        {
            if ([[[_myGroupsPostsArray objectAtIndex:indexPath.row]valueForKey:@"group_posts"]count]>0) {
                return 225.0;
            }
            else
            {
                 return 65.0;
            }
            
        }
        else
        {
            
            if ([[[_myJoinedArray objectAtIndex:indexPath.row]valueForKey:@"group_posts"]count]>0) {
                return 225.0;
            }
            else
            {
                return 65.0;
            }
            
        }
        
        
    }
    else if ([selectionString isEqualToString:@"2"])
        
    {
        
        if ([[[_openGroupPostsArray objectAtIndex:indexPath.row]valueForKey:@"group_posts"]count]>0) {
            return 225.0;
        }
        else
        {
            return 65.0;
        }
        
        
    }
    else if ([selectionString isEqualToString:@"3"])
    {
        
        if ([[[_discoverGroupPostsArray objectAtIndex:indexPath.row]valueForKey:@"group_posts"]count]>0) {
            return 225.0;
        }
        else
        {
            return 65.0;
        }
    }
    else
    {
        return 65.0;
    }
    }

    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(groupsTableCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==_groupReqTableView)
    {
    }
    else
    {
       
    if (isSearchBegin)
    {
        [cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
        NSInteger index = cell.groupCollections.indexPath.row;
        
        CGFloat horizontalOffset = [self.searchGroupDict[[@(index) stringValue]] floatValue];
        [cell.groupCollections setContentOffset:CGPointMake(horizontalOffset, 0)];
    }

    else
    {
    if ([selectionString isEqualToString:@"1"])
    {
        
        if (isMygroup)
        {
            
            [cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
            NSInteger index = cell.groupCollections.indexPath.row;
            
            CGFloat horizontalOffset = [self.myGroupsDict[[@(index) stringValue]] floatValue];
            [cell.groupCollections setContentOffset:CGPointMake(horizontalOffset, 0)];
            
        }
        else
        {
            
            [cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
            NSInteger index = cell.groupCollections.indexPath.row;
            
            CGFloat horizontalOffset = [self.myJoinedDict[[@(index) stringValue]] floatValue];
            [cell.groupCollections setContentOffset:CGPointMake(horizontalOffset, 0)];
            
        }
        
        
    }
    else if ([selectionString isEqualToString:@"2"])
        
    {
        [cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
        NSInteger index = cell.groupCollections.indexPath.row;
        
        CGFloat horizontalOffset = [self.openGroupDict[[@(index) stringValue]] floatValue];
        [cell.groupCollections setContentOffset:CGPointMake(horizontalOffset, 0)];
        
        
    }
    else if ([selectionString isEqualToString:@"3"])
    {
        [cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
        NSInteger index = cell.groupCollections.indexPath.row;
        
        CGFloat horizontalOffset = [self.discoverGroupDict[[@(index) stringValue]] floatValue];
        [cell.groupCollections setContentOffset:CGPointMake(horizontalOffset, 0)];
    }
    }
        
    }
   
}




- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    
}


-(void)callGetAllOpenGroups
{
    NSDate*date=[NSDate date];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDateFormatter *dateFormatterNew = [[NSDateFormatter alloc] init];
    [dateFormatterNew setLocale:enUSPOSIXLocale];
    [dateFormatterNew setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *stringForNewDate =[dateFormatterNew stringFromDate:date];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"device_time":stringForNewDate
                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsGetOpenGroups:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    [noGroupFoundAlert setHidden:YES];

                    [noGroupsFoundLbl setHidden:YES];
                    [_mainTableView setHidden:NO];
                    _openGroupPostsArray=[resultArray valueForKey:@"data"];
                    
                    
                    const NSInteger numberOfTableViewRows = [_openGroupPostsArray  count];
                    
                    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:numberOfTableViewRows];
                    
                    for (NSInteger tableViewRow = 0; tableViewRow < numberOfTableViewRows; tableViewRow++)
                    {
                        NSMutableArray *colorArray = [NSMutableArray arrayWithCapacity:[[[_openGroupPostsArray objectAtIndex:tableViewRow]valueForKey:@"group_posts"] count]];
                        
                        for (NSInteger collectionViewItem = 0; collectionViewItem < [[[_openGroupPostsArray objectAtIndex:tableViewRow]valueForKey:@"group_posts"] count]; collectionViewItem++)
                        {
                            [colorArray addObject:[[[_openGroupPostsArray objectAtIndex:tableViewRow]valueForKey:@"group_posts"] objectAtIndex:collectionViewItem]];
                        }
                        
                        [mutableArray addObject:colorArray];
                    }
                    
                    self.openGroupArray = [NSArray arrayWithArray:mutableArray];
                    self.openGroupDict = [NSMutableDictionary dictionary];
                    
                    [_mainTableView reloadData];
                }
                else
                {
                    if ([[resultArray valueForKey:@"code"] integerValue]==201 ) {
                        
                        [noGroupsFoundLbl setHidden:NO];
                        [noGroupFoundAlert setHidden:NO];

                        noGroupsFoundLbl.text=@"No Open groups found!!";
                        [_mainTableView setHidden:YES];
                        
                    }
                    else
                    {
                        NSDictionary *options = @{
                                                  kCRToastTextKey : kServiceFailure,
                                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                                  kCRToastBackgroundColorKey : [UIColor redColor],
                                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                                  };
                        [CRToastManager showNotificationWithOptions:options
                                                    completionBlock:^{
                                                        NSLog(@"Completed");
                                                    }];

                    }

                    
                }
            }];
            
        } failureBlock:^(BOOL succeeded, NSArray *failureArray)
         {
             
             [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                 
                 [KAppdelegate stopLoader:self.view];
                 NSDictionary *options = @{
                                           kCRToastTextKey : kServiceFailure,
                                           kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                           kCRToastBackgroundColorKey : [UIColor redColor],
                                           kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                           kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                           kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                           kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                           };
                 [CRToastManager showNotificationWithOptions:options
                                             completionBlock:^{
                                                 NSLog(@"Completed");
                                             }];

             }];
             
             
         }];
    }
    else
    {
        NSDictionary *options = @{
                                  kCRToastTextKey : kNetworkAlert,
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey : [UIColor redColor],
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                  };
        [CRToastManager showNotificationWithOptions:options
                                    completionBlock:^{
                                        NSLog(@"Completed");
                                    }];

    }
    
    
}







//Discover Groups
-(void)callGetAllDiscoverGroups
{
    NSDate*date=[NSDate date];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDateFormatter *dateFormatterNew = [[NSDateFormatter alloc] init];
    [dateFormatterNew setLocale:enUSPOSIXLocale];
    [dateFormatterNew setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *stringForNewDate =[dateFormatterNew stringFromDate:date];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"device_time":stringForNewDate
                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsGetDiscoverGroups:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    [noGroupFoundAlert setHidden:YES];

                    [noGroupsFoundLbl setHidden:YES];
                    [_mainTableView setHidden:NO];

                    _discoverGroupPostsArray=[resultArray valueForKey:@"data"];
                    const NSInteger numberOfTableViewRows = [_discoverGroupPostsArray  count];
                    
                    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:numberOfTableViewRows];
                    
                    for (NSInteger tableViewRow = 0; tableViewRow < numberOfTableViewRows; tableViewRow++)
                    {
                        NSMutableArray *colorArray = [NSMutableArray arrayWithCapacity:[[[_discoverGroupPostsArray objectAtIndex:tableViewRow]valueForKey:@"group_posts"] count]];
                        
                        for (NSInteger collectionViewItem = 0; collectionViewItem < [[[_discoverGroupPostsArray objectAtIndex:tableViewRow]valueForKey:@"group_posts"] count]; collectionViewItem++)
                        {
                            [colorArray addObject:[[[_discoverGroupPostsArray objectAtIndex:tableViewRow]valueForKey:@"group_posts"] objectAtIndex:collectionViewItem]];
                        }
                        
                        [mutableArray addObject:colorArray];
                    }
                    
                    self.discoverGroupArray = [NSArray arrayWithArray:mutableArray];
                    self.discoverGroupDict = [NSMutableDictionary dictionary];
                    
                    [_mainTableView reloadData];

                }
                else
                {
                    if ([[resultArray valueForKey:@"code"] integerValue]==201 ) {
                        
                        
                        [noGroupFoundAlert setHidden:NO];

                        [noGroupsFoundLbl setHidden:NO];
                        noGroupsFoundLbl.text=@"No Discover groups found!!";
                        [_mainTableView setHidden:YES];

                    }
                    else
                    {
                        NSDictionary *options = @{
                                                  kCRToastTextKey : kServiceFailure,
                                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                                  kCRToastBackgroundColorKey : [UIColor redColor],
                                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                                  };
                        [CRToastManager showNotificationWithOptions:options
                                                    completionBlock:^{
                                                        NSLog(@"Completed");
                                                    }];
                    }

                    
                }
            }];
            
        } failureBlock:^(BOOL succeeded, NSArray *failureArray)
         {
             
             [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                 
                 [KAppdelegate stopLoader:self.view];
                 NSDictionary *options = @{
                                           kCRToastTextKey : kServiceFailure,
                                           kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                           kCRToastBackgroundColorKey : [UIColor redColor],
                                           kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                           kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                           kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                           kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                           };
                 [CRToastManager showNotificationWithOptions:options
                                             completionBlock:^{
                                                 NSLog(@"Completed");
                                             }];
             }];
             
             
         }];
    }
    else
    {
        NSDictionary *options = @{
                                  kCRToastTextKey : kNetworkAlert,
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey : [UIColor redColor],
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                  };
        [CRToastManager showNotificationWithOptions:options
                                    completionBlock:^{
                                        NSLog(@"Completed");
                                    }];

    }
    
    
}


//Get My Groups

-(void)callMyGroupsApi
{
    
    NSDate*date=[NSDate date];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDateFormatter *dateFormatterNew = [[NSDateFormatter alloc] init];
    [dateFormatterNew setLocale:enUSPOSIXLocale];
    [dateFormatterNew setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *stringForNewDate =[dateFormatterNew stringFromDate:date];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"device_time":stringForNewDate
                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsGetGroups:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                _myGroupsPostsArray=nil;
                _myJoinedPostsArray=nil;
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    
                    if ([[[resultArray valueForKey:@"data"] valueForKey:@"my_groups"]count]>0)
                    {
                        [noGroupFoundAlert setHidden:YES];

                        [noGroupsFoundLbl setHidden:YES];
                        [_mainTableView setHidden:NO];
                        
                        _myGroupsPostsArray=[[resultArray valueForKey:@"data"] valueForKey:@"my_groups"];
                        
                        const NSInteger numberOfTableViewRows = [_myGroupsPostsArray  count];
                        
                        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:numberOfTableViewRows];
                        
                        for (NSInteger tableViewRow = 0; tableViewRow < numberOfTableViewRows; tableViewRow++)
                        {
                            NSMutableArray *colorArray = [NSMutableArray arrayWithCapacity:[[[_myGroupsPostsArray objectAtIndex:tableViewRow]valueForKey:@"group_posts"] count]];
                            
                            for (NSInteger collectionViewItem = 0; collectionViewItem < [[[_myGroupsPostsArray objectAtIndex:tableViewRow]valueForKey:@"group_posts"] count]; collectionViewItem++)
                            {
                                [colorArray addObject:[[[_myGroupsPostsArray objectAtIndex:tableViewRow]valueForKey:@"group_posts"] objectAtIndex:collectionViewItem]];
                            }
                            
                            [mutableArray addObject:colorArray];
                        }
                        
                        self.myGroupsArray = [NSArray arrayWithArray:mutableArray];
                        self.myGroupsDict = [NSMutableDictionary dictionary];
                        
                    }
                    else
                    {
                        [noGroupFoundAlert setHidden:NO];
                        
                        [_mainTableView setHidden:YES];
                    }
                  
                   
                    if ([[[resultArray valueForKey:@"data"] valueForKey:@"joined_groups"]count]>0)
                    {
                        
                        _myJoinedPostsArray=[[resultArray valueForKey:@"data"] valueForKey:@"joined_groups"];
                        
                        
                        const NSInteger numberOfTableViewRows = [_myJoinedPostsArray  count];
                        
                        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:numberOfTableViewRows];
                        
                        for (NSInteger tableViewRow = 0; tableViewRow < numberOfTableViewRows; tableViewRow++)
                        {
                            NSMutableArray *colorArray = [NSMutableArray arrayWithCapacity:[[[_myJoinedPostsArray objectAtIndex:tableViewRow]valueForKey:@"group_posts"] count]];
                            
                            for (NSInteger collectionViewItem = 0; collectionViewItem < [[[_myJoinedPostsArray objectAtIndex:tableViewRow]valueForKey:@"group_posts"] count]; collectionViewItem++)
                            {
                                [colorArray addObject:[[[_myJoinedPostsArray objectAtIndex:tableViewRow]valueForKey:@"group_posts"] objectAtIndex:collectionViewItem]];
                            }
                            
                            [mutableArray addObject:colorArray];
                        }
                        
                        self.myJoinedArray = [NSArray arrayWithArray:mutableArray];
                        self.myJoinedDict = [NSMutableDictionary dictionary];
                        
                    }
                    
                    if ([KAppdelegate.notificationType isEqualToString:@"group_join_invitation"])
                    {
                        
                        [_openGroupReqsBtn setHidden:NO];
                        [_openGroupReqsBtn setTitle:@"Invitation" forState:UIControlStateNormal];
                        _topTitleLabel.text=@"Invitations";
                        [_groupsJoinedBtn setBackgroundColor:rGBColor(21, 165, 230)];
                        [_groupsJoinedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [_myGroupsBtn setBackgroundColor:rGBColor(235,239,242)];
                        [_myGroupsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                        isMygroup=NO;
                        [_mainTableView reloadData];
                        
                        [_groupRequestView setHidden:NO];
                       
                        [self.view bringSubviewToFront:_groupRequestView];
                        [self callGetAllGroupsJoinReqs];
                        KAppdelegate.notificationType=@"NoNotification";
                    }
                    else if ([KAppdelegate.notificationType isEqualToString:@"group_join_request"])
                    {
                     
                        [_groupsJoinedBtn setBackgroundColor:rGBColor(235,239,242)];
                        [_groupsJoinedBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                        [_myGroupsBtn setBackgroundColor:rGBColor(21, 165, 230)];
                        [_myGroupsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [_openGroupReqsBtn setHidden:NO];
                        [_openGroupReqsBtn setTitle:@"Group Request" forState:UIControlStateNormal];
                        _topTitleLabel.text=@"Group Request";
                        isMygroup=YES;

                        KAppdelegate.notificationType=@"NoNotification";

                        [_groupRequestView setHidden:NO];
                         
                        
                        [self.view bringSubviewToFront:_groupRequestView];
                        [self callGetAllGroupReqs];
                            
                    }

                    [_mainTableView reloadData];
                    
                }
                else
                {
                    
                    NSDictionary *options = @{
                                              kCRToastTextKey : kServiceFailure,
                                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                              kCRToastBackgroundColorKey : [UIColor redColor],
                                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                              };
                    [CRToastManager showNotificationWithOptions:options
                                                completionBlock:^{
                                                    NSLog(@"Completed");
                                                }];

                }
            }];
            
        } failureBlock:^(BOOL succeeded, NSArray *failureArray)
         {
             
             [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                 
                 [KAppdelegate stopLoader:self.view];
                 NSDictionary *options = @{
                                           kCRToastTextKey : kServiceFailure,
                                           kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                           kCRToastBackgroundColorKey : [UIColor redColor],
                                           kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                           kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                           kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                           kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                           };
                 [CRToastManager showNotificationWithOptions:options
                                             completionBlock:^{
                                                 NSLog(@"Completed");
                                             }];

             }];
             
             
         }];
    }
    else
    {
        NSDictionary *options = @{
                                  kCRToastTextKey : kNetworkAlert,
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey : [UIColor redColor],
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                  };
        [CRToastManager showNotificationWithOptions:options
                                    completionBlock:^{
                                        NSLog(@"Completed");
                                    }];

    }
    
    
}





#pragma mark
#pragma mark- CollectionView
#pragma mark

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    

    if (isSearchBegin)
    {
        NSArray *collectionViewArray = self.searchGroupArray[[(GroupsPostsCollectionView1 *)collectionView indexPath].row];
        return collectionViewArray.count;
    }
    
    else
    {
    if ([selectionString isEqualToString:@"1"])
    {
        if (isMygroup)
        {
            NSArray *collectionViewArray = self.myGroupsArray[[(GroupsPostsCollectionView1 *)collectionView indexPath].row];
            return collectionViewArray.count;
        }
        else
        {
            NSArray *collectionViewArray = self.myJoinedArray[[(GroupsPostsCollectionView1 *)collectionView indexPath].row];
            return collectionViewArray.count;

        }
        
        
    }
    else if ([selectionString isEqualToString:@"2"])
    
    {
        NSArray *collectionViewArray = self.openGroupArray[[(GroupsPostsCollectionView1 *)collectionView indexPath].row];
        return collectionViewArray.count;

    }
    else if ([selectionString isEqualToString:@"3"])
    {
        NSArray *collectionViewArray = self.discoverGroupArray[[(GroupsPostsCollectionView1 *)collectionView indexPath].row];
        return collectionViewArray.count;

    }
    else
    {
        return 0;

    }
    }
   
}

- (void)membersPressed:(UIButton*)sender
{
    
//    NSMutableArray* listItems = [[NSMutableArray alloc]init];
//    
//    for (int i=0; i<[groupMembers count]; i++)
//    {
//        NSDictionary*dict=[groupMembers objectAtIndex:i];
//        [listItems addObject:[dict valueForKey:@"name"]];
//        
//    }
//    
//    [YBPopupMenu showRelyOnView:sender titles:listItems icons:nil menuWidth:150 otherSettings:^(YBPopupMenu *popupMenu) {
//        
//        
//        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionLeft;
//        popupMenu.borderWidth = 1;
//        popupMenu.borderColor = [UIColor blackColor];
//        popupMenu.delegate=self;
//    }];
    
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    groupInCellCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"groupInCellCellID" forIndexPath:indexPath];
    
    NSArray *collectionViewArray;
    

    
    if (isSearchBegin)
    {
        collectionViewArray = self.searchGroupArray[[(GroupsPostsCollectionView1 *)collectionView indexPath].row];

    }
    
    else
    {
    if ([selectionString isEqualToString:@"1"])
    {
        
        if (isMygroup)
        {
            
          collectionViewArray = self.myGroupsArray[[(GroupsPostsCollectionView1 *)collectionView indexPath].row];
            
        }
        else
        {
           
            collectionViewArray = self.myJoinedArray[[(GroupsPostsCollectionView1 *)collectionView indexPath].row];

        }
        
        
    }
    else if ([selectionString isEqualToString:@"2"])
        
    {
        collectionViewArray = self.openGroupArray[[(GroupsPostsCollectionView1 *)collectionView indexPath].row];

        
    }
    else if ([selectionString isEqualToString:@"3"])
    {
        collectionViewArray = self.discoverGroupArray[[(GroupsPostsCollectionView1 *)collectionView indexPath].row];
    }
    }
    
    NSIndexPath*ip=[(GroupsPostsCollectionView1 *)collectionView indexPath];
    NSIndexPath*ip1=[NSIndexPath indexPathForRow:indexPath.row inSection:ip.row];
    
    [cell.groupInCellImage setAccessibilityIdentifier:[NSString stringWithFormat:@"%ld",(long)ip1.section]];
    [cell.groupInCellImage setTag:ip1.row];
    
    NSDictionary*dict=[collectionViewArray objectAtIndex:indexPath.row];
    if ([[dict valueForKey:@"medias"]count]>0)
    {
        if ([[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_path"] length]>0)
        {
            [cell.groupInCellImage sd_setImageWithURL:[NSURL URLWithString:[[[dict valueForKey:@"medias"] objectAtIndex:0]valueForKey:@"media_thumb"]] placeholderImage:[UIImage imageNamed:@"postBackSmall"] options:SDWebImageRefreshCached];
            
        }
        else
        {
            cell.groupInCellImage.image=[UIImage imageNamed:@"postBackSmall"];
        }
        
    }
    else
    {
        cell.groupInCellImage.image=[UIImage imageNamed:@"postBackSmall"];
        
    }
    
        return cell;
    
    
}


//- (void)bigButtonTapped:(UITapGestureRecognizer*)sender
//{

    //    NSIndexPath*ip=[(GroupsPostsCollectionView1 *)collectionView indexPath];
    //    NSIndexPath*ip1=[NSIndexPath indexPathForRow:indexPath.row inSection:ip.row];
    //
    //    PostDetailsViewController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"PostDetailsViewControllerID"];
    //
    //    tabBarController.postDetails=[[_colorArray objectAtIndex:ip1.section] objectAtIndex:ip1.row];
    //    tabBarController.postID=[[[_colorArray objectAtIndex:ip1.section] objectAtIndex:ip1.row] valueForKey:@"id"];
    //
    //    [self.navigationController pushViewController:tabBarController animated:YES];


//}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    //NSString*groupId;
    groupInCellCell* cell = (groupInCellCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    NSIndexPath*ip=[(GroupsPostsCollectionView1 *)collectionView indexPath];
    NSIndexPath*ip1=[NSIndexPath indexPathForRow:indexPath.row inSection:ip.row];

    NSMutableArray*urlsArray=[[NSMutableArray alloc]init];
    NSMutableArray*typesArray=[[NSMutableArray alloc]init];
    NSMutableArray*mediaPaths=[[NSMutableArray alloc]init];

    NSArray*sampleArray;
    
    if (isSearchBegin)
    {
        sampleArray = self.searchGroupArray;
        
    }
    
    else
    {
    
    if ([selectionString isEqualToString:@"1"])
    {
        if (isMygroup)
        {
            sampleArray=_myGroupsArray;
        }
        else
        {
            sampleArray=_myJoinedArray;
        }
    }
    else if ([selectionString isEqualToString:@"2"])
    {
        sampleArray=_openGroupArray;
        
    }
    else if ([selectionString isEqualToString:@"3"])
    {
        sampleArray=_discoverGroupArray;
    }
    }
    
    for (NSDictionary*dict in [sampleArray objectAtIndex:ip1.section])
    {
        //KSPhotoItem *item = [KSPhotoItem itemWithSourceView:cell.groupInCellImage imageUrl:[NSURL URLWithString:[[[dict valueForKey:@"medias"] objectAtIndex:0] valueForKey:@"media_thumb"]]];
        
//        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:cell.groupInCellImage thumbImage:[UIImage imageNamed:@"cover_picBack"] imageUrl:[NSURL URLWithString:[[[dict valueForKey:@"medias"] objectAtIndex:0] valueForKey:@"media_thumb"]]];
//
//        [typesArray addObject:[[[dict valueForKey:@"medias"] objectAtIndex:0] valueForKey:@"media_type"]];
//        [mediaPaths addObject:[[[dict valueForKey:@"medias"] objectAtIndex:0] valueForKey:@"media_path"]];
//
//        [urlsArray addObject:item];
        
        KSPhotoItem *item;
        if ([[[[dict valueForKey:@"medias"] objectAtIndex:0] valueForKey:@"media_type"]isEqualToString:@"video"])
        {
            item = [KSPhotoItem itemWithSourceView:cell.groupInCellImage thumbImage:[UIImage imageNamed:@"cover_picBack"] imageUrl:[NSURL URLWithString:[[[dict valueForKey:@"medias"] objectAtIndex:0] valueForKey:@"media_thumb"]]];
        }
        else
        {
            item = [KSPhotoItem itemWithSourceView:cell.groupInCellImage thumbImage:[UIImage imageNamed:@"cover_picBack"] imageUrl:[NSURL URLWithString:[[[dict valueForKey:@"medias"] objectAtIndex:0] valueForKey:@"media_path"]]];
        }
        
        
        [urlsArray addObject:item];
        [typesArray addObject:[[[dict valueForKey:@"medias"] objectAtIndex:0] valueForKey:@"media_type"]];
        [mediaPaths addObject:[[[dict valueForKey:@"medias"] objectAtIndex:0] valueForKey:@"media_path"]];

        
        
        
    }
    
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:urlsArray selectedIndex:indexPath.row typesArray:typesArray mediaPaths:mediaPaths allDataDicts:sampleArray];
    browser.delegate = self;
    browser.dismissalStyle = _dismissalStyle;
    browser.backgroundStyle = _backgroundStyle;
    browser.loadingStyle = _loadingStyle;
    browser.pageindicatorStyle = _pageindicatorStyle;
    browser.bounces = _bounces;
    [browser showFromViewController:self];

}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    
    
}



// MARK: - KSPhotoBrowserDelegate

- (void)ks_photoBrowser:(KSPhotoBrowser *)browser didSelectItem:(KSPhotoItem *)item atIndex:(NSUInteger)index {
    NSLog(@"selected index: %ld", index);
}

- (CGSize)collectionView:(UICollectionView* )collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath* )indexPath
{
 
   
    return CGSizeMake(153,131);
    
}

-(void)callGetAllGroupReqs
{
    //access_token
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"sender_type":@"user"
                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsGetJoinGroupReqs:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    
                    groupReqs=[resultArray valueForKey:@"data"];
                               
                    [_groupReqTableView reloadData];
                    
                }
                else
                {
                    if ([[resultArray valueForKey:@"code"]integerValue]==201) {
                        groupReqs =nil;
                        [_groupReqTableView reloadData];

                    }
                    else
                    {
                        
                        NSDictionary *options = @{
                                                  
                                                  kCRToastTextKey : kServiceFailure,
                                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                                  kCRToastBackgroundColorKey : [UIColor redColor],
                                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                        
                                                  };
                        
                        [CRToastManager showNotificationWithOptions:options
                                                    completionBlock:^{
                                                        NSLog(@"Completed");
                                                    }];



                    }
                    
                }
            }];
            
        } failureBlock:^(BOOL succeeded, NSArray *failureArray)
         {
             
             [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                 
                 [KAppdelegate stopLoader:self.view];
                 NSDictionary *options = @{
                                           kCRToastTextKey : kServiceFailure,
                                           kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                           kCRToastBackgroundColorKey : [UIColor redColor],
                                           kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                           kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                           kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                           kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                           };
                 [CRToastManager showNotificationWithOptions:options
                                             completionBlock:^{
                                                 NSLog(@"Completed");
                                             }];

             }];
             
             
         }];
    }
    else
    {
        NSDictionary *options = @{
                                  kCRToastTextKey : kNetworkAlert,
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey : [UIColor redColor],
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                  };
        [CRToastManager showNotificationWithOptions:options
                                    completionBlock:^{
                                        NSLog(@"Completed");
                                    }];

    }
    
    
}
-(void)callGetAllGroupsJoinReqs
{
    //access_token
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"sender_type":@"group_admin"
                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsGetJoinGroupReqs:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    
                    joinReqs=[resultArray valueForKey:@"data"];
                    
                    [_groupReqTableView reloadData];
                    
                }
                else
                {
                    if ([[resultArray valueForKey:@"code"]integerValue]==201)
                    {
                        [_groupReqTableView reloadData];
                        
                    }
                    else
                    {
                        NSDictionary *options = @{
                                                   kCRToastTextKey : kServiceFailure,
                                                   kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                                   kCRToastBackgroundColorKey : [UIColor redColor],
                                                   kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                                   kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                                   kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                                   kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                                   };
                        [CRToastManager showNotificationWithOptions:options
                                                    completionBlock:^{
                                                        NSLog(@"Completed");
                                                    }];
                       

                        
                    }
                    
                }
            }];
            
        } failureBlock:^(BOOL succeeded, NSArray *failureArray)
         {
             
             [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                 
                 [KAppdelegate stopLoader:self.view];
                 NSDictionary *options = @{
                                           kCRToastTextKey : kServiceFailure,
                                           kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                           kCRToastBackgroundColorKey : [UIColor redColor],
                                           kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                           kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                           kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                           kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                           };
                 [CRToastManager showNotificationWithOptions:options
                                             completionBlock:^{
                                                 NSLog(@"Completed");
                                             }];

             }];
             
             
         }];
    }
    else
    {
        [KAppdelegate stopLoader:self.view];
        NSDictionary *options = @{
                                  kCRToastTextKey : kNetworkAlert,
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey : [UIColor redColor],
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                  };
        [CRToastManager showNotificationWithOptions:options
                                    completionBlock:^{
                                        NSLog(@"Completed");
                                    }];
    }
    
    
}



- (IBAction)removeGroupReqsView:(id)sender {
    
    [_groupRequestView setHidden:YES];

}


- (IBAction)openGroupReqs:(id)sender
{
    [_groupRequestView setHidden:NO];
    [self.view bringSubviewToFront:_groupRequestView];
    if (isMygroup) {
        [self callGetAllGroupReqs];

    }
    else
    {
        [self callGetAllGroupsJoinReqs];

    }

    
}

- (IBAction)acceptRejectGroupReq:(UIButton*)sender
{
 
    if (isMygroup)
    {
        [self callAcceptRejectReq:@"1" friendID:[[groupReqs objectAtIndex:sender.tag] valueForKey:@"sender_id"] groupID:[[groupReqs objectAtIndex:sender.tag] valueForKey:@"group_id"]];
        
    }
    else
    {
        [self callAcceptRejectReq:@"1" friendID:[[joinReqs objectAtIndex:sender.tag] valueForKey:@"sender_id"] groupID:[[joinReqs objectAtIndex:sender.tag] valueForKey:@"group_id"]];
        
    }

    
}

- (IBAction)rejectPressed:(UIButton*)sender
{
    if (isMygroup)
    {
        [self callAcceptRejectReq:@"0" friendID:[[groupReqs objectAtIndex:sender.tag] valueForKey:@"sender_id"] groupID:[[groupReqs objectAtIndex:sender.tag] valueForKey:@"group_id"]];

    }
    else
    {
        [self callAcceptRejectReq:@"0" friendID:[[joinReqs objectAtIndex:sender.tag] valueForKey:@"sender_id"] groupID:[[joinReqs objectAtIndex:sender.tag] valueForKey:@"group_id"]];

    }
    

}
-(void)callAcceptRejectReq :(NSString*)status friendID:(NSString*)friendID groupID:(NSString*)groupID
{
    //access_token
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"status":status,
                                   @"sender_id":friendID,
                                   @"group_id":groupID

                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsAcceptOrRejectGroupReq:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    
                    [self callMyGroupsApi];
                    [_groupRequestView setHidden:YES];

                    
                }
                else
                {
                    NSDictionary *options = @{
                                              kCRToastTextKey : kServiceFailure,
                                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                              kCRToastBackgroundColorKey : [UIColor redColor],
                                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                              };
                    [CRToastManager showNotificationWithOptions:options
                                                completionBlock:^{
                                                    NSLog(@"Completed");
                                                }];

                    
                }
            }];
            
        } failureBlock:^(BOOL succeeded, NSArray *failureArray)
         {
             
             [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                 
                 [KAppdelegate stopLoader:self.view];
                 NSDictionary *options = @{
                                           kCRToastTextKey : kServiceFailure,
                                           kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                           kCRToastBackgroundColorKey : [UIColor redColor],
                                           kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                           kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                           kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                           kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                           };
                 [CRToastManager showNotificationWithOptions:options
                                             completionBlock:^{
                                                 NSLog(@"Completed");
                                             }];

             }];
             
             
         }];
    }
    else
    {
        NSDictionary *options = @{
                                  kCRToastTextKey : kNetworkAlert,
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey : [UIColor redColor],
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                  };
        [CRToastManager showNotificationWithOptions:options
                                    completionBlock:^{
                                        NSLog(@"Completed");
                                    }];

    }
    
    
}





//*****************
// SEARCH BAR
//*****************

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    //NSLog(@"searchBar ... text.length: %d", text.length);
    
    if(text.length == 0)
    {
        isSearchResult=NO;
        isSearchBegin=NO;
       // [_mainCollectionView reloadData];
        
    }
    else
    {
        
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //User hit Search button on Keyboard
    isSearchResult=YES;
    
    NSString*searchGroup;
    if ([selectionString isEqualToString:@"1"])
    {
        if (isMygroup)
        {
            searchGroup=@"mygroup";
        }
        else
        {
            searchGroup=@"myjoined";

            
        }
        
    }
    else if ([selectionString isEqualToString:@"2"])
    {
        searchGroup=@"open";

    }
    else if ([selectionString isEqualToString:@"3"])
    {
        searchGroup=@"all";

    }

    [self callGetSearchGroup:searchBar.text groupType:searchGroup] ;
    [searchBar resignFirstResponder];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    isSearchBegin=YES;
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isSearchBegin=NO;
    isSearchResult=NO;
    searchBar.text=@"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [_mainTableView reloadData];
    
}



#pragma mark GetSearchGroup Api
-(void)callGetSearchGroup :(NSString*)userString groupType:(NSString*)groupType

{
    NSDate*date=[NSDate date];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDateFormatter *dateFormatterNew = [[NSDateFormatter alloc] init];
    [dateFormatterNew setLocale:enUSPOSIXLocale];
    [dateFormatterNew setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *stringForNewDate =[dateFormatterNew stringFromDate:date];
  
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"search_group":userString,
                                   @"group_type":@"all",
                                   @"device_time":stringForNewDate

                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsSearchGroups:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    
                    [noGroupFoundAlert setHidden:YES];

                    [noGroupsFoundLbl setHidden:YES];
                    [_mainTableView setHidden:NO];
                    _searchGroupPostsArray=[resultArray valueForKey:@"data"];
                    
                    const NSInteger numberOfTableViewRows = [_searchGroupPostsArray  count];
                    
                    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:numberOfTableViewRows];
                    
                    for (NSInteger tableViewRow = 0; tableViewRow < numberOfTableViewRows; tableViewRow++)
                    {
                        NSMutableArray *colorArray = [NSMutableArray arrayWithCapacity:[[[_searchGroupPostsArray objectAtIndex:tableViewRow]valueForKey:@"group_posts"] count]];
                        
                        for (NSInteger collectionViewItem = 0; collectionViewItem < [[[_searchGroupPostsArray objectAtIndex:tableViewRow]valueForKey:@"group_posts"] count]; collectionViewItem++)
                        {
                            [colorArray addObject:[[[_searchGroupPostsArray objectAtIndex:tableViewRow]valueForKey:@"group_posts"] objectAtIndex:collectionViewItem]];
                        }
                        
                        [mutableArray addObject:colorArray];
                    }
                    
                    self.searchGroupArray = [NSArray arrayWithArray:mutableArray];
                    self.searchGroupDict = [NSMutableDictionary dictionary];
                    
                    [_mainTableView reloadData];
                }
                else
                {
                    if ([[resultArray valueForKey:@"code"] integerValue]==201 ) {
                        
                        [noGroupFoundAlert setHidden:NO];

                        [noGroupsFoundLbl setHidden:NO];
                        noGroupsFoundLbl.text=@"No Group found!";
                        [_mainTableView setHidden:YES];
                        
                    }
                    else
                    {
                        NSDictionary *options = @{
                                                  kCRToastTextKey : kServiceFailure,
                                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                                  kCRToastBackgroundColorKey : [UIColor redColor],
                                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                                  };
                        [CRToastManager showNotificationWithOptions:options
                                                    completionBlock:^{
                                                        NSLog(@"Completed");
                                                    }];
                        
                    }
                    
                    
                }
            }];
            
        } failureBlock:^(BOOL succeeded, NSArray *failureArray)
         {
             
             [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                 
                 [KAppdelegate stopLoader:self.view];
                 NSDictionary *options = @{
                                           kCRToastTextKey : kServiceFailure,
                                           kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                           kCRToastBackgroundColorKey : [UIColor redColor],
                                           kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                           kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                           kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                           kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                           };
                 [CRToastManager showNotificationWithOptions:options
                                             completionBlock:^{
                                                 NSLog(@"Completed");
                                             }];
                 
             }];
             
             
         }];
    }
    else
    {
        NSDictionary *options = @{
                                  kCRToastTextKey : kNetworkAlert,
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey : [UIColor redColor],
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                  };
        [CRToastManager showNotificationWithOptions:options
                                    completionBlock:^{
                                        NSLog(@"Completed");
                                    }];
        
    }
    
    
}

#pragma mark GetScan SearchGroup Api
-(void)callScanGroupSearch:(NSString*)userString

{
    NSDate*date=[NSDate date];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDateFormatter *dateFormatterNew = [[NSDateFormatter alloc] init];
    [dateFormatterNew setLocale:enUSPOSIXLocale];
    [dateFormatterNew setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *stringForNewDate =[dateFormatterNew stringFromDate:date];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                   @"qr_code":userString,
                                   @"device_time":stringForNewDate
                                   };
    
    
    if ([KAppdelegate hasInternetConnection])
    {
        
        [KAppdelegate startLoader:self.view withTitle:@"Loading..."];
        
        [KSharedParsing wsSearchScanGroup:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                
                [KAppdelegate stopLoader:self.view];
                
                [self.view endEditing:YES];
                if ([[resultArray valueForKey:@"result"] integerValue]==1)
                {
                    
                    [noGroupFoundAlert setHidden:YES];
                    
                    [noGroupsFoundLbl setHidden:YES];
                    [_mainTableView setHidden:NO];
                    _searchGroupPostsArray=[NSArray arrayWithObjects:[resultArray valueForKey:@"data"], nil];
                    
                    const NSInteger numberOfTableViewRows = [_searchGroupPostsArray  count];
                    
                    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:numberOfTableViewRows];
                    
                    for (NSInteger tableViewRow = 0; tableViewRow < numberOfTableViewRows; tableViewRow++)
                    {
                        NSMutableArray *colorArray = [NSMutableArray arrayWithCapacity:[[[_searchGroupPostsArray objectAtIndex:tableViewRow]valueForKey:@"group_posts"] count]];
                        
                        for (NSInteger collectionViewItem = 0; collectionViewItem < [[[_searchGroupPostsArray objectAtIndex:tableViewRow]valueForKey:@"group_posts"] count]; collectionViewItem++)
                        {
                            [colorArray addObject:[[[_searchGroupPostsArray objectAtIndex:tableViewRow]valueForKey:@"group_posts"] objectAtIndex:collectionViewItem]];
                        }
                        
                        [mutableArray addObject:colorArray];
                    }
                    
                    self.searchGroupArray = [NSArray arrayWithArray:mutableArray];
                    self.searchGroupDict = [NSMutableDictionary dictionary];
                    
                    [_mainTableView reloadData];
                }
                else
                {
                    if ([[resultArray valueForKey:@"code"] integerValue]==201 ) {
                        
                        [noGroupFoundAlert setHidden:NO];
                        
                        [noGroupsFoundLbl setHidden:NO];
                        noGroupsFoundLbl.text=@"No Group found!";
                        [_mainTableView setHidden:YES];
                        
                    }
                    else
                    {
                        NSDictionary *options = @{
                                                  kCRToastTextKey : kServiceFailure,
                                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                                  kCRToastBackgroundColorKey : [UIColor redColor],
                                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                                  };
                        [CRToastManager showNotificationWithOptions:options
                                                    completionBlock:^{
                                                        NSLog(@"Completed");
                                                    }];
                        
                    }
                    
                    
                }
            }];
            
        } failureBlock:^(BOOL succeeded, NSArray *failureArray)
         {
             
             [RunOnMainThread runBlockInMainQueueIfNecessary:^{
                 
                 [KAppdelegate stopLoader:self.view];
                 NSDictionary *options = @{
                                           kCRToastTextKey : kServiceFailure,
                                           kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                           kCRToastBackgroundColorKey : [UIColor redColor],
                                           kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                           kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                           kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                           kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                           };
                 [CRToastManager showNotificationWithOptions:options
                                             completionBlock:^{
                                                 NSLog(@"Completed");
                                             }];
                 
             }];
             
             
         }];
    }
    else
    {
        NSDictionary *options = @{
                                  kCRToastTextKey : kNetworkAlert,
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey : [UIColor redColor],
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                  };
        [CRToastManager showNotificationWithOptions:options
                                    completionBlock:^{
                                        NSLog(@"Completed");
                                    }];
        
    }
    
    
}


- (IBAction)memberOnePressed:(UIButton*)sender
{
    
//    NSMutableDictionary* dict;
//    NSMutableArray* listItems = [[NSMutableArray alloc]init];
//    
//    if (isSearchBegin)
//    {
//        dict=[_searchGroupPostsArray objectAtIndex:sender.tag];
//        
//    }
//    else
//    {
//        
//        if ([selectionString isEqualToString:@"1"])
//        {
//            
//            if (isMygroup)
//            {
//                dict=[_myGroupsPostsArray objectAtIndex:sender.tag];
//                
//            }
//            else
//            {
//                
//                dict=[_myJoinedPostsArray objectAtIndex:sender.tag];
//                
//                
//            }
//            
//            
//        }
//        else if ([selectionString isEqualToString:@"2"])
//            
//        {
//            
//            dict=[_openGroupPostsArray objectAtIndex:sender.tag];
//            
//        }
//        else if ([selectionString isEqualToString:@"3"])
//        {
//            dict=[_discoverGroupPostsArray objectAtIndex:sender.tag];
//            
//        }
//    }
//    
//    NSArray*groupMembers=[dict objectForKey:@"group_members"];
//    FriendsProfileViewController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendsProfileViewControllerID"];
//    tabBarController.friendID=[[groupMembers objectAtIndex:0] valueForKey:@"id"];
//    [self.navigationController pushViewController:tabBarController animated:YES];
}


- (IBAction)memberTwoPressed:(UIButton*)sender
{
//    NSMutableDictionary* dict;
//    NSMutableArray* listItems = [[NSMutableArray alloc]init];
//    
//    if (isSearchBegin)
//    {
//        dict=[_searchGroupPostsArray objectAtIndex:sender.tag];
//        
//    }
//    else
//    {
//        
//        if ([selectionString isEqualToString:@"1"])
//        {
//            
//            if (isMygroup)
//            {
//                dict=[_myGroupsPostsArray objectAtIndex:sender.tag];
//                
//            }
//            else
//            {
//                
//                dict=[_myJoinedPostsArray objectAtIndex:sender.tag];
//                
//                
//            }
//            
//            
//        }
//        else if ([selectionString isEqualToString:@"2"])
//            
//        {
//            
//            dict=[_openGroupPostsArray objectAtIndex:sender.tag];
//            
//        }
//        else if ([selectionString isEqualToString:@"3"])
//        {
//            dict=[_discoverGroupPostsArray objectAtIndex:sender.tag];
//            
//        }
//    }
//    
//    NSArray*groupMembers=[dict objectForKey:@"group_members"];
//    
//    FriendsProfileViewController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendsProfileViewControllerID"];
//    tabBarController.friendID=[[groupMembers objectAtIndex:1] valueForKey:@"id"];
//    [self.navigationController pushViewController:tabBarController animated:YES];
    
}


- (IBAction)memberThreePressed:(UIButton*)sender
{
//    NSMutableDictionary* dict;
//    NSMutableArray* listItems = [[NSMutableArray alloc]init];
//    
//    if (isSearchBegin)
//    {
//        dict=[_searchGroupPostsArray objectAtIndex:sender.tag];
//        
//    }
//    else
//    {
//        
//        if ([selectionString isEqualToString:@"1"])
//        {
//            
//            if (isMygroup)
//            {
//                dict=[_myGroupsPostsArray objectAtIndex:sender.tag];
//                
//            }
//            else
//            {
//                
//                dict=[_myJoinedPostsArray objectAtIndex:sender.tag];
//                
//                
//            }
//            
//            
//        }
//        else if ([selectionString isEqualToString:@"2"])
//            
//        {
//            
//            dict=[_openGroupPostsArray objectAtIndex:sender.tag];
//            
//        }
//        else if ([selectionString isEqualToString:@"3"])
//        {
//            dict=[_discoverGroupPostsArray objectAtIndex:sender.tag];
//            
//        }
//    }
//    
//    NSArray*groupMembers=[dict objectForKey:@"group_members"];
//    
//    FriendsProfileViewController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendsProfileViewControllerID"];
//    tabBarController.friendID=[[groupMembers objectAtIndex:2] valueForKey:@"id"];
//    [self.navigationController pushViewController:tabBarController animated:YES];
}


- (IBAction)otherMemberPressed:(UIButton*)sender
{
    
    NSMutableDictionary* dict;
    NSMutableArray* listItems = [[NSMutableArray alloc]init];
    
    if (isSearchBegin)
    {
        dict=[_searchGroupPostsArray objectAtIndex:sender.tag];
        
    }
    else
    {
        
        if ([selectionString isEqualToString:@"1"])
        {
            
            if (isMygroup)
            {
                dict=[_myGroupsPostsArray objectAtIndex:sender.tag];
                
            }
            else
            {
                
                dict=[_myJoinedPostsArray objectAtIndex:sender.tag];
                
                
            }
            
            
        }
        else if ([selectionString isEqualToString:@"2"])
            
        {
            
            dict=[_openGroupPostsArray objectAtIndex:sender.tag];
            NSLog(@"_openGroupPostsArray%@",dict);
            
        }
        else if ([selectionString isEqualToString:@"3"])
        {
            dict=[_discoverGroupPostsArray objectAtIndex:sender.tag];
            
        }
    }
    
        NSArray*groupMembers=[dict objectForKey:@"group_members"];
    
        for (int i=0; i<[groupMembers count]; i++)
        {
            NSDictionary*dict=[groupMembers objectAtIndex:i];
            [listItems addObject:[dict valueForKey:@"name"]];
    
        }
    
        [YBPopupMenu showRelyOnView:sender titles:listItems icons:nil menuWidth:150 otherSettings:^(YBPopupMenu *popupMenu) {
    
    
            popupMenu.priorityDirection = YBPopupMenuPriorityDirectionLeft;
            popupMenu.borderWidth = 1;
            popupMenu.borderColor = [UIColor blackColor];
            popupMenu.delegate=self;
        }];


}

-(IBAction)scanGroup:(id)sender
{
    
            isSearchBegin =YES;
            isSearchResult=YES;

            QRCodeReaderViewController *reader = [QRCodeReaderViewController new];
            reader.modalPresentationStyle = UIModalPresentationFormSheet;
            reader.delegate = self;
                
                __weak typeof (self) wSelf = self;
                [reader setCompletionWithBlock:^(NSString *resultAsString)
                 {
                     if ([resultAsString length]!=0 || resultAsString!=nil) {
                         
                         [self callScanGroupSearch:resultAsString];

                     }
                     

                     
                     [wSelf dismissViewControllerAnimated:YES completion:^{
                         
                     }];
                     
                         
                     
                     
                     
                     
                     
                 }];
                
                [self presentViewController:reader animated:YES completion:^{
                    
                }];;
                
                
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
