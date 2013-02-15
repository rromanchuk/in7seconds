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
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"User Profile Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
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
    
    self.statusLabel.text = self.otherUser.status;
    
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
