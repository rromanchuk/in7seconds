//
//  UserProfileViewController.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/10/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "User+REST.h"
#import "ProfilePhotoView.h"
@interface UserProfileViewController : UITableViewController <UIScrollViewDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) Hookup *otherUser;
@property (weak, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *interestsScrollView;
@property (weak, nonatomic) IBOutlet ProfilePhotoView *firstInterestImage;
@property (weak, nonatomic) IBOutlet UIScrollView *friendsScrollView;
@property (weak, nonatomic) IBOutlet ProfilePhotoView *firstFriendScroll;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
- (IBAction)didTapClose:(id)sender;
- (IBAction)didTapLike:(id)sender;
- (IBAction)didTapUnlike:(id)sender;

@end
