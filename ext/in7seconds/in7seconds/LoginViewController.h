//
//  LoginViewController.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "Vkontakte.h"
#import "User+REST.h"
#import "FacebookHelper.h"
#import "GAITrackedViewController.h"

@protocol LoginDelegate;
@interface LoginViewController : GAITrackedViewController <VkontakteDelegate, FacebookHelperDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (strong, nonatomic) UIViewController *vkController;

@property (weak, nonatomic) IBOutlet UIButton *vkLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *fbLoginButton;
@property (weak, nonatomic) id <LoginDelegate> delegate;

- (IBAction)didTapVkLogin:(id)sender;
- (IBAction)didTapFbLogin:(id)sender;

@end


@protocol LoginDelegate <NSObject>

@required
- (void)didVkLogin:(User *)user;
- (void)didFbLogin:(User *)user;
@end