//
//  MatchesViewController.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/27/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "User+REST.h"
@interface MatchesViewController : CoreDataTableViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) User *currentUser;
@property BOOL fromMenu;
@end
