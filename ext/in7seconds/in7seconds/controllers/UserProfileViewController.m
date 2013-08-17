//
//  UserProfileViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/10/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "UserProfileViewController.h"

#import  <QuartzCore/QuartzCore.h>
#import "Hookup+REST.h"
#import "Image+REST.h"
#import "MutualFriend+REST.h"
#import "Group+REST.h"
@interface UserProfileViewController () {
}
@end

@implementation UserProfileViewController

- (void)setupPhotos {
    
   
    //self.imageBrowser.backgroundColor = [UIColor blackColor];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    [images addObject:self.otherUser.photoUrl];
    for (Image *image in self.otherUser.images) {
        [images addObject:image.photoUrl];
    }
    ALog(@"images are %@", images);
    
    NSInteger ctr = 1;
    int offsetX = 0;
    
    for (NSString *imageUrl in images) {
        if (ctr == 1) {
            [self.firstImage setImageWithURL:[NSURL URLWithString:imageUrl]];
        } else {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX, 0, 320, 343)];
            [imageView setImageWithURL:[NSURL URLWithString:imageUrl]];
            [self.imagesScrollView addSubview:imageView];
        }
        ctr++;
        offsetX += 320;
    }
    [self.imagesScrollView setContentSize:CGSizeMake(offsetX, 343)];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.imagesScrollView) {
        
        CGFloat pageWidth = self.imagesScrollView.frame.size.width;
        float fractionalPage = self.imagesScrollView.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        self.pageControl.currentPage = page;
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupPhotos];
    [self setupMutualFriends];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.yesButton.hidden = self.noButton.hidden = !self.canRate;
    self.pageControl.numberOfPages = [self.otherUser.images count] + 1;
    self.imagesScrollView.delegate = self;
    //[self setupPhotos];
       
    if (self.otherUser.birthday && [self.otherUser.yearsOld integerValue] > 0) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@, %@", self.otherUser.firstName, self.otherUser.yearsOld];
    } else {
        self.nameLabel.text = [NSString stringWithFormat:@"%@", self.otherUser.lastName];
    }
    
    
//    
//    //[self.userProfileImage setProfilePhotoWithURL:self.otherUser.photoUrl];
//    [self.mutalFriendsButton setTitle:[NSString stringWithFormat:@"%@", self.otherUser.mutualFriendsNum] forState:UIControlStateNormal];
//    [self.mutualGroupsButton setTitle:[NSString stringWithFormat:@"%@", self.otherUser.mutualGroups] forState:UIControlStateNormal];
//    
//    if (self.otherUser.mutualFriendNames.length == 0) {
//        self.mutualFriendsLabel.text = @"отсутствующий";
//    } else {
//        self.mutualFriendsLabel.text = self.otherUser.mutualFriendNames;
//    }
//    
//    if (self.otherUser.mutualGroupNames.length == 0) {
//        self.mutualGroupsLabel.text =  @"отсутствующий";
//    } else {
//        self.mutualGroupsLabel.text = self.otherUser.mutualGroupNames;
//    }
//    [self.mutualGroupsLabel sizeToFit];
//    
//    
//    [self.userGroupsHeader setFrame:CGRectMake(self.mutualGroupsLabel.frame.origin.x, (self.mutualGroupsLabel.frame.origin.y + self.mutualGroupsLabel.frame.size.height) + 10, self.userGroupsHeader.frame.size.width, self.userGroupsHeader.frame.size.height)];
//    [self.userGroupsLabel setFrame:CGRectMake(self.mutualGroupsLabel.frame.origin.x, (self.userGroupsHeader.frame.origin.y + self.userGroupsHeader.frame.size.height), self.userGroupsLabel.frame.size.width, self.userGroupsLabel.frame.size.height)];
//    if (self.otherUser.groupNames.length == 0) {
//        self.userGroupsLabel.text = @"отсутствующий";
//    } else {
//        self.userGroupsLabel.text = self.otherUser.groupNames;
//    }
//    [self.userGroupsLabel sizeToFit];
//    
//    
//    [self.educationHeader setFrame:CGRectMake(self.userGroupsLabel.frame.origin.x, (self.userGroupsLabel.frame.origin.y + self.userGroupsLabel.frame.size.height) + 10, self.educationHeader.frame.size.width, self.educationHeader.frame.size.height)];
//    [self.educationLabel setFrame:CGRectMake(self.educationHeader.frame.origin.x, (self.educationHeader.frame.origin.y + self.educationHeader.frame.size.height), self.educationLabel.frame.size.width, self.educationLabel.frame.size.height)];
//    self.educationLabel.text = self.otherUser.schoolInfo;
//    [self.educationLabel sizeToFit];
//    
//    [self.vkHeader setFrame:CGRectMake(self.educationLabel.frame.origin.x, (self.educationLabel.frame.origin.y + self.educationLabel.frame.size.height) + 10, self.vkHeader.frame.size.width, self.educationLabel.frame.size.height)];
//    
//    [self.vkUrlTextView setFrame:CGRectMake(self.vkHeader.frame.origin.x, (self.vkHeader.frame.origin.y + self.vkHeader.frame.size.height), self.vkUrlTextView.frame.size.width, self.vkUrlTextView.frame.size.height)];
//    
//    self.vkUrlTextView.text = self.otherUser.socialUrl;
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"back_icon"] target:self action:@selector(back)];
    
    [self setupMutualFriends];
    [self setupMutualInterests];
    //[self setupUserImages];
}


- (void)setupMutualFriends {
    int offsetX = 0;
    NSInteger ctr = 1;
    //OstronautFilterType filterType;
    ALog(@"other user %@", self.otherUser);
    //ALog(@"current user is %@", self.currentUser);
    for (MutualFriend *mutualFriend in self.otherUser.mutualFriends) {
        if (ctr == 1) {
            [self.firstFriendScroll setCircleWithUrl:mutualFriend.photoUrl];
        } else {
            ProfilePhotoView *imageView = [[ProfilePhotoView alloc] initWithFrame:CGRectMake(offsetX, 0, 65, 65)];
            [imageView setCircleWithUrl:mutualFriend.photoUrl];
            [self.friendsScrollView addSubview:imageView];

        }
        ALog(@"in mutal friend loop");
                
//        UILabel *userNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(userImageView.frame.origin.x, userImageView.frame.size.height + 4, userImageView.frame.size.width, 10.0)];
//        userNameLabel.text = mutualFriend.firstName;
//        userNameLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:10.0];
//        userNameLabel.textAlignment = NSTextAlignmentCenter;
//        userNameLabel.backgroundColor = [UIColor clearColor];
//        userNameLabel.textColor = RGBCOLOR(159, 169, 172);
        //[self.scrollView addSubview:userNameLabel];
        offsetX += 5 + 65;
    }
    
    [self.friendsScrollView setContentSize:CGSizeMake(offsetX, 65)];
}

- (void)setupMutualInterests {
    int offsetX = 0;
    NSInteger ctr = 1;
    //OstronautFilterType filterType;
    ALog(@"other user %@", self.otherUser);
    //ALog(@"current user is %@", self.currentUser);
    for (Group *group in self.otherUser.groups) {
        if (ctr == 1) {
            [self.firstInterestImage setCircleWithUrl:group.photo];
        } else {
            ProfilePhotoView *imageView = [[ProfilePhotoView alloc] initWithFrame:CGRectMake(offsetX, 0, 65, 65)];
            [imageView setCircleWithUrl:group.photo];
            [self.interestsScrollView addSubview:imageView];
            
        }
        ALog(@"in mutal group loop");
        offsetX += 5 + 65;
    }
    
    [self.interestsScrollView setContentSize:CGSizeMake(offsetX, 65)];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fetch {
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (IBAction)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapLike:(id)sender {
    [self.delegate didLikeFromProfile];
}

- (IBAction)didTapUnlike:(id)sender {
    [self.delegate didUnlikeFromProfile];
}
@end
