//
//  UserProfileViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/10/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "UserProfileViewController.h"
#import "BaseUIView.h"
#import  <QuartzCore/QuartzCore.h>

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundView = [[BaseUIView alloc] init];
    if (self.otherUser.birthday && [self.otherUser.yearsOld integerValue] > 0) {
        self.title = [NSString stringWithFormat:@"%@, %@", self.otherUser.firstName, self.otherUser.yearsOld];
    } else {
        self.title = [NSString stringWithFormat:@"%@", self.otherUser.lastName];
    }
    
    
    [self.profileImage setProfilePhotoWithURL:self.otherUser.photoUrl];
    [self.mutalFriendsButton setTitle:[NSString stringWithFormat:@"%@", self.otherUser.mutualFriendsNum] forState:UIControlStateNormal];
    [self.mutualGroupsButton setTitle:[NSString stringWithFormat:@"%@", self.otherUser.mutualGroups] forState:UIControlStateNormal];
    
    if (self.otherUser.mutualFriendNames.length == 0) {
        self.mutualFriendsLabel.text = @"отсутствующий";
    } else {
        self.mutualFriendsLabel.text = self.otherUser.mutualFriendNames;
    }
    
    if (self.otherUser.mutualGroupNames.length == 0) {
        self.mutualGroupsLabel.text =  @"отсутствующий";
    } else {
        self.mutualGroupsLabel.text = self.otherUser.mutualGroupNames;
    }
        
    
       
    if (self.otherUser.groupNames.length == 0) {
        self.userGroupsLabel.text = @"отсутствующий";
    } else {
        self.userGroupsLabel.text = self.otherUser.groupNames;
        [self.userGroupsLabel sizeToFit];
    }
    
    self.educationLabel.text = self.otherUser.schoolInfo;
    [self.educationLabel sizeToFit];
    
    self.vkUrlTextView.text = self.otherUser.vkUrl;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"back_icon"] target:self action:@selector(back)];
    
    [self setupMutualFriends];
    
}

- (void)setupMutualFriends {
    int offsetX = 15;
    //OstronautFilterType filterType;
    //ALog(@"other user %@", self.otherUser);
    //ALog(@"current user is %@", self.currentUser);
    for (User *mutualFriend in self.otherUser.mutalFriendObjects) {
        ALog(@"in mutal friend loop");
        ProfileImageView *userImageView = [[ProfileImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        userImageView.layer.borderWidth = 1;
        [userImageView setProfilePhotoWithURL:mutualFriend.photoUrl];
        
        [self.scrollView addSubview:userImageView];
        
        UILabel *userNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(offsetX, userImageView.frame.size.height + 4, userImageView.frame.size.width, 10.0)];
        userNameLabel.text = mutualFriend.firstName;
        userNameLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:10.0];
        userNameLabel.textAlignment = NSTextAlignmentCenter;
        userNameLabel.backgroundColor = [UIColor clearColor];
        userNameLabel.textColor = RGBCOLOR(159, 169, 172);
        [self.scrollView addSubview:userNameLabel];
        offsetX += 10 + userNameLabel.frame.size.width;
    }
    
    [self.scrollView setContentSize:CGSizeMake(offsetX, 70)];
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
