//
//  InitialViewController.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "ECSlidingViewController.h"
#import "User+REST.h"
#import "LoginViewController.h"
#import "MenuViewController.h"
#import "NotificationBanner.h"
@interface InitialViewController : ECSlidingViewController <LoginDelegate, LogoutDelegate>

@property (strong, nonatomic) NotificationBanner *notificationBanner;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) User *currentUser;
@end
