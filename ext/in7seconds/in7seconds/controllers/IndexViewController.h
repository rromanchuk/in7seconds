//
//  IndexViewController.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "User+REST.h"
#import "LoginViewController.h"
#import "MenuViewController.h"
#import "ProfileImageView.h"
#import "MatchViewController.h"
#import "AppDelegate.h"
#import "SwipeView.h"
#import <ViewDeck/IIViewDeckController.h>

@interface IndexViewController : UIViewController <ImageLoadedDelegate, MatchModalDelegate, ApplicationLifecycleDelegate, SwipeViewDelegate, IIViewDeckControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet ProfileImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *mutualFriendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *mutualGroupsLabel;

@property (weak, nonatomic) IBOutlet UIButton *unlikeButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UILabel *noResultsLabel;
@property (weak, nonatomic) IBOutlet UIView *infoBanner;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (strong, nonatomic) IBOutlet SwipeView *swipeView;
@property (weak, nonatomic) IBOutlet UILabel *photosCountLabel;

- (IBAction)didTapUnlike:(id)sender;
- (IBAction)didTapLike:(id)sender;
- (IBAction)didTapInfo:(id)sender;
- (IBAction)didTapPhoto:(id)sender;

@end
