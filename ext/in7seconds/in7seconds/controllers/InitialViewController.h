//
//  InitialViewController.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "IIViewDeckController.h"

#import "User+REST.h"
#import "LoginViewController.h"
#import "MenuViewController.h"

@interface InitialViewController : IIViewDeckController <LoginDelegate, LogoutDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) User *currentUser;
@end
