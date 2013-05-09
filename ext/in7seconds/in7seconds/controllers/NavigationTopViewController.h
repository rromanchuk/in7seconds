//
//  NavigationTopViewController.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "ECSlidingViewController.h"
#import "MenuViewController.h"
@interface NavigationTopViewController : UINavigationController
@property (strong, nonatomic) User *currentUser;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
