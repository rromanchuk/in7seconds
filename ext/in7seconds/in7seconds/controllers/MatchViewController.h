//
//  MatchViewController.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/8/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "User+REST.h"

@interface MatchViewController : UIViewController
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) User *otherUser;

@property (weak, nonatomic) IBOutlet UIImageView *currentUserImage;
@property (weak, nonatomic) IBOutlet UIImageView *otherUserImage;

@property (weak, nonatomic) IBOutlet UIButton *startChatButton;
@property (weak, nonatomic) IBOutlet UIButton *keepSearchingButton;
- (IBAction)didTapStartChat:(id)sender;
- (IBAction)didTapKeepSearching:(id)sender;
@end
