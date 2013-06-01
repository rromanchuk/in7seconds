//
//  NavigationTopViewController.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "NotificationHandler.h"
#import "NotificationBanner.h"

@interface NavigationTopViewController : UINavigationController <NotificationDisplayModalDelegate>
@property (strong, nonatomic) User *currentUser;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NotificationBanner *notificationBanner;
@property BOOL isChildNavigationalStack;

@end
