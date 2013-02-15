//
//  MatchesViewController.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/27/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "User+REST.h"
@interface MatchesViewController : CoreDataTableViewController <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
               // The saved state of the search UI if a memory warning removed the view.
        NSString        *savedSearchTerm_;
        NSInteger       savedScopeButtonIndex_;
        BOOL            searchWasActive_;
}


@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) User *currentUser;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *searchFetchedResultsController;

@property BOOL fromMenu;
@end
