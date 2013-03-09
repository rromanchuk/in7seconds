//
//  CommentViewController.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/6/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "User+REST.h"
#import "HPGrowingTextView.h"

@interface CommentViewController : UIViewController <HPGrowingTextViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;
@property BOOL debug;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) User *otherUser;

@property (nonatomic, weak) HPGrowingTextView *commentView;


- (void)performFetch;

@end
