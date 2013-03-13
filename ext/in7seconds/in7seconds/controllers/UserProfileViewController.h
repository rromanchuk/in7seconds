//
//  UserProfileViewController.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/10/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "User+REST.h"
#import "ProfileImageView.h"
@interface UserProfileViewController : UITableViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) User *otherUser;
@property (weak, nonatomic) IBOutlet ProfileImageView *profileImage;


@property (weak, nonatomic) IBOutlet UILabel *mutualFriendsHeader;
@property (weak, nonatomic) IBOutlet UIButton *mutalFriendsButton;
@property (weak, nonatomic) IBOutlet UILabel *mutualFriendsLabel;

@property (weak, nonatomic) IBOutlet UIButton *mutualGroupsButton;
@property (weak, nonatomic) IBOutlet UILabel *mutualGroupsHeading;
@property (weak, nonatomic) IBOutlet UILabel *mutualGroupsLabel;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UILabel *userGroupsLabel;
@property (weak, nonatomic) IBOutlet UILabel *userGroupsHeader;

@property (weak, nonatomic) IBOutlet UILabel *educationLabel;
@property (weak, nonatomic) IBOutlet UILabel *educationHeader;


@property (weak, nonatomic) IBOutlet UITextView *vkUrlTextView;
@end
