//
//  inviteFriendsGroupCell.m
//  PhotoBunch
//
//  Created by Gorav Grover on 31/05/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import "inviteFriendsGroupCell.h"

@implementation inviteFriendsGroupCell
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        self.backgroundColor = [UIColor darkGrayColor];
        [self.selectedTic setHighlighted:NO];
    } else {
        self.backgroundColor = [UIColor whiteColor];
        [self.selectedTic setHighlighted:YES];

    }
}
@end
