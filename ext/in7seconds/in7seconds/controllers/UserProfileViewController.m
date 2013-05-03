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
#import "Hookup+REST.h"
#import "MutualFriend+REST.h"
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
    [self.mutualGroupsLabel sizeToFit];
    
    
    [self.userGroupsHeader setFrame:CGRectMake(self.mutualGroupsLabel.frame.origin.x, (self.mutualGroupsLabel.frame.origin.y + self.mutualGroupsLabel.frame.size.height) + 10, self.userGroupsHeader.frame.size.width, self.userGroupsHeader.frame.size.height)];
    [self.userGroupsLabel setFrame:CGRectMake(self.mutualGroupsLabel.frame.origin.x, (self.userGroupsHeader.frame.origin.y + self.userGroupsHeader.frame.size.height), self.userGroupsLabel.frame.size.width, self.userGroupsLabel.frame.size.height)];
    if (self.otherUser.groupNames.length == 0) {
        self.userGroupsLabel.text = @"отсутствующий";
    } else {
        self.userGroupsLabel.text = self.otherUser.groupNames;
    }
    [self.userGroupsLabel sizeToFit];
    
    
    [self.educationHeader setFrame:CGRectMake(self.userGroupsLabel.frame.origin.x, (self.userGroupsLabel.frame.origin.y + self.userGroupsLabel.frame.size.height) + 10, self.educationHeader.frame.size.width, self.educationHeader.frame.size.height)];
    [self.educationLabel setFrame:CGRectMake(self.educationHeader.frame.origin.x, (self.educationHeader.frame.origin.y + self.educationHeader.frame.size.height), self.educationLabel.frame.size.width, self.educationLabel.frame.size.height)];
    self.educationLabel.text = self.otherUser.schoolInfo;
    [self.educationLabel sizeToFit];
    
    [self.vkHeader setFrame:CGRectMake(self.educationLabel.frame.origin.x, (self.educationLabel.frame.origin.y + self.educationLabel.frame.size.height) + 10, self.vkHeader.frame.size.width, self.educationLabel.frame.size.height)];
    
    [self.vkUrlTextView setFrame:CGRectMake(self.vkHeader.frame.origin.x, (self.vkHeader.frame.origin.y + self.vkHeader.frame.size.height), self.vkUrlTextView.frame.size.width, self.vkUrlTextView.frame.size.height)];
    self.vkUrlTextView.text = self.otherUser.vkUrl;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"back_icon"] target:self action:@selector(back)];
    
    [self setupMutualFriends];
    
}

- (void)setupUserImages {
    NSInteger page = 1;
    for (Image *_image in self.otherUser.images) {
        int offsetX = (self.profileImage.frame.origin.x + 320) * page;
        ProfileImageView *image = [[ProfileImageView alloc] initWithFrame:CGRectMake(offsetX, self.profileImage.frame.origin.y, self.profileImage.frame.size.width, self.profileImage.frame.size.height)];
        [self.userImagesScrollView addSubview:image];
        page++;
    }
}

- (void)setupMutualFriends {
    int offsetX = 15;
    //OstronautFilterType filterType;
    ALog(@"other user %@", self.otherUser);
    //ALog(@"current user is %@", self.currentUser);
    for (MutualFriend *mutualFriend in self.otherUser.mutualFriends) {
        ALog(@"in mutal friend loop");
        UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX, 0, 50, 50)];
        userImageView.layer.borderWidth = 1;
        [userImageView setImageWithURL:[NSURL URLWithString:mutualFriend.photoUrl]];
        
        [self.scrollView addSubview:userImageView];
        
        UILabel *userNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(userImageView.frame.origin.x, userImageView.frame.size.height + 4, userImageView.frame.size.width, 10.0)];
        userNameLabel.text = mutualFriend.firstName;
        userNameLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:10.0];
        userNameLabel.textAlignment = NSTextAlignmentCenter;
        userNameLabel.backgroundColor = [UIColor clearColor];
        userNameLabel.textColor = RGBCOLOR(159, 169, 172);
        [self.scrollView addSubview:userNameLabel];
        offsetX += 10 + userNameLabel.frame.size.width;
    }
    
    [self.scrollView setContentSize:CGSizeMake(offsetX, 69)];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fetch {
    
}

- (void)viewDidUnload {
    [self setVkHeader:nil];
    [self setUserImagesScrollView:nil];
    [super viewDidUnload];
}
@end
