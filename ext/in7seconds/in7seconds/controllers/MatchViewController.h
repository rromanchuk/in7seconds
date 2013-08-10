//
//  MatchViewController.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/8/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "User+REST.h"
#import "ProfilePhotoView.h"

@protocol MatchModalDelegate;
@interface MatchViewController : UIViewController
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) Match *otherUser;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet ProfilePhotoView *currentUserImage;
@property (weak, nonatomic) IBOutlet ProfilePhotoView *otherUserImage;

@property (weak, nonatomic) IBOutlet UIButton *startChatButton;
@property (weak, nonatomic) IBOutlet UIButton *keepSearchingButton;
@property (weak, nonatomic) IBOutlet UILabel *matchTextLabel;

@property (weak) id <MatchModalDelegate> delegate;

- (IBAction)didTapStartChat:(id)sender;
- (IBAction)didTapKeepSearching:(id)sender;
@end

@protocol MatchModalDelegate <NSObject>

@required
- (void)userWantsToChat:(Match *)matchUser;
- (void)userWantsToRate;

@end