//
//  UserProfileViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/10/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = [NSString stringWithFormat:@"%@", self.otherUser.firstName];
    
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.otherUser.photoUrl]];
    [self.mutalFriendsButton setTitle:[NSString stringWithFormat:@"%@", self.otherUser.mutualFriends] forState:UIControlStateNormal];
    [self.mutualGroupsButton setTitle:[NSString stringWithFormat:@"%@", self.otherUser.mutualGroups] forState:UIControlStateNormal];
    
    self.mutualGroupsLabel.text = self.otherUser.mutualGroupNames;
    [self.mutualGroupsLabel sizeToFit];
    
    self.friendsLabel.text = self.otherUser.mutualFriendNames;
    [self.friendsLabel sizeToFit];
    
    self.userGroupsLabel.text = self.otherUser.groupNames;
    [self.userGroupsLabel sizeToFit];
    
    self.educationLabel.text = self.otherUser.schoolInfo;
    [self.educationLabel sizeToFit];
    
    self.vkUrlTextView.text = self.otherUser.vkUrl;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"back_icon"] target:self action:@selector(back)];
    
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
