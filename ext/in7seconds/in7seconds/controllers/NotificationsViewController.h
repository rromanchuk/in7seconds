//
//  NotificationsViewController.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/14/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "User+REST.h"

@interface NotificationsViewController : CoreDataTableViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) User *currentUser;
@end
