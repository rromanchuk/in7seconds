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
@interface IndexViewController : ECSlidingViewController <LoginDelegate, LogoutDelegate>
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UIButton *unlikeButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
- (IBAction)didTapUnlike:(id)sender;
- (IBAction)didTapLike:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *didTapLike;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
