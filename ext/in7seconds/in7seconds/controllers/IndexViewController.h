//
//  IndexViewController.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "ECSlidingViewController.h"
#import "User+REST.h"
#import "LoginViewController.h"
#import "MenuViewController.h"
#import "ProfileImageView.h"
#import "MatchViewController.h"

@interface IndexViewController : ECSlidingViewController <LoginDelegate, LogoutDelegate, ImageLoadedDelegate, MatchModalDelegate>
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet ProfileImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *mutualFriendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *mutualGroupsLabel;

@property (weak, nonatomic) IBOutlet UIButton *unlikeButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
- (IBAction)didTapUnlike:(id)sender;
- (IBAction)didTapLike:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *didTapLike;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *countdownView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
- (IBAction)didTapInfo:(id)sender;

@end
