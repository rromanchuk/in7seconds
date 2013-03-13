//
//  UserProfileViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/10/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "UserProfileViewController.h"
#import "BaseUIView.h"
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
    [self.mutalFriendsButton setTitle:[NSString stringWithFormat:@"%@", self.otherUser.mutualFriends] forState:UIControlStateNormal];
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
    
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupMutualFriends {
//    sampleFilterImages = [[NSMutableSet alloc] init];
//    int offsetX = 10;
//    //OstronautFilterType filterType;
//    for (NSString *filter in self.filters) {
//        DLog(@"Setting up filter %@", filter);
//        FilterButtonView *filterButton = [FilterButtonView buttonWithType:UIButtonTypeCustom];
//        filterButton.frame = CGRectMake(offsetX, 5.0, 50.0, 50.0);
//        filterButton.filterName = filter;
//        NSString *filename = [NSString stringWithFormat:@"%@.png", filter];
//        UIImage *filteredSampleImage  = [UIImage imageNamed:filename];
//        
//              
//        [filterButton setImage:filteredSampleImage forState:UIControlStateNormal];
//        [filterButton addTarget:self action:@selector(didChangeFilter:) forControlEvents:UIControlEventTouchUpInside];
//        filterButton.opaque = YES;
//        filterButton.alpha = 1.0;
//        [self.filterScrollView addSubview:filterButton];
//        
//        UILabel *filterNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(offsetX, filterButton.frame.size.height + 8, filterButton.frame.size.width, 10.0)];
//        filterNameLabel.text = filter;
//        filterNameLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:12.0];
//        filterNameLabel.textAlignment = UITextAlignmentCenter;
//        filterNameLabel.backgroundColor = [UIColor clearColor];
//        filterNameLabel.textColor = [UIColor whiteColor];
//        filterButton.label = filterNameLabel;
//        [self.filterScrollView addSubview:filterNameLabel];
//        offsetX += 10 + filterButton.frame.size.width;
//    }
//    
//    DLog(@"number of photos is %d", [sampleFilterImages count]);
//    //[self saveSampleFilters];
//    //self.filterScrollView.backgroundColor = [UIColor blueColor];
//    [self.filterScrollView setContentSize:CGSizeMake(offsetX, 70)];
    
}

@end
