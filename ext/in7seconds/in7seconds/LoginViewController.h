//
//  LoginViewController.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vkontakte.h"
#import "User+REST.h"
@protocol LoginDelegate;
@interface LoginViewController : UIViewController <VkontakteDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) User *currentUser;

@property (weak, nonatomic) IBOutlet UIButton *vkLoginButton;
@property (weak, nonatomic) id <LoginDelegate> delegate;

- (IBAction)didTapVkLogin:(id)sender;

@end


@protocol LoginDelegate <NSObject>

@required
- (void)didLogin:(User *)users;

@end