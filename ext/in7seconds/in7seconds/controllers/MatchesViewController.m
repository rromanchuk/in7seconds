//
//  MatchesViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/27/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "MatchesViewController.h"
#import "MatchCell.h"
#import "NoChatsView.h"
#import "CommentViewController.h"
#import "UserProfileViewController.h"
#import "UAPush.h"
#import  <QuartzCore/QuartzCore.h>
#import <ViewDeck/IIViewDeckController.h>

#import "PrivateMessage+REST.h"

#import "RestMatch.h"
#import "Match+REST.h"
#import "User+REST.h"
#import "Notification+REST.h"
#import "AppDelegate.h"

#import "ThreadedUpdates.h"
@interface MatchesViewController () {
    NSDateFormatter *_fm;
    CGFloat _ledgeSize;
    
}
@property (strong, nonatomic) NoChatsView *noResultsFooterView;

@end

@implementation MatchesViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder])
    {
        self.noResultsFooterView = (NoChatsView *)[[NSBundle mainBundle] loadNibNamed:@"NoChatsView" owner:self options:nil][0];
        self.noResultsFooterView.messageLabel.text = NSLocalizedString(@"У тебя еще нет совпадений. Чтобы они появились, просто начни отмечать понравившихся тебе людей :)", @"no matches");
        _fm = [[NSDateFormatter alloc] init];
        [_fm setDateFormat:@"d MMM"];
        
    }
    return self;
}

- (void)checkNoResults {
    if ([[self.fetchedResultsController fetchedObjects] count] == 0) {
        self.tableView.tableFooterView = self.noResultsFooterView;
    } else {
        self.tableView.tableFooterView = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    self.navigationController.navigationBarHidden = NO;
    _ledgeSize = self.viewDeckController.rightLedgeSize;
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    self.currentUser = [User currentUser:self.managedObjectContext];
    
    if (self.fromMenu) {
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
            UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
            space.width = 10;
            self.navigationItem.leftBarButtonItems = @[space, [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"sidebar_button"] target:self action:@selector(revealMenu:)]];
            
        } else {
            self.navigationItem.leftBarButtonItems = @[[UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"sidebar_button"] target:self action:@selector(revealMenu:)]];
        }


    }
    
    self.title = NSLocalizedString(@"Симпатии", nil);

    [[UAPush shared] resetBadge];
    
    
    
    [self setupFetchedResultsController];
    [self fetchResults];
    [self checkNoResults];

	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (_ledgeSize) {
        self.viewDeckController.rightSize = _ledgeSize;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"Matches Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}



#pragma mark CoreData methods
- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Match"];
    request.predicate = [NSPredicate predicateWithFormat:@"self IN %@", self.currentUser.matches];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"matchedAt" ascending:NO]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    
    ALog(@"num of matches on user obj %d", [self.currentUser.matches count]);
    ALog(@"num of matches %d", [[self.fetchedResultsController fetchedObjects] count]);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CommentThread"]) {
        
        CommentViewController *vc = (CommentViewController *)segue.destinationViewController;
        vc.managedObjectContext = self.managedObjectContext;
        vc.currentUser = self.currentUser;
        Match *user = (Match *)sender;
        vc.otherUser = user;
    } else if ([segue.identifier isEqualToString:@"UserProfileFromMatches"]) {
        UserProfileViewController *vc = (UserProfileViewController *)segue.destinationViewController;
        vc.managedObjectContext = self.managedObjectContext;
        vc.otherUser = (Match *)sender;
        vc.currentUser = self.currentUser;
        vc.canRate = NO;

    }
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MatchCell *theCell = [self.tableView dequeueReusableCellWithIdentifier:@"MatchCell" forIndexPath:indexPath];
    Match *match = [self.fetchedResultsController objectAtIndexPath:indexPath];

    //[self fetchedResultsController:[self fetchedResultsControllerForTableView:tableView] configureCell:cell atIndexPath:indexPath];
    theCell.nameLabel.text = match.firstName;
    [theCell.profilePhoto setCircleWithUrl:match.photoUrl];
    theCell.profilePhoto.tag = indexPath.row;
    theCell.profilePhoto.userInteractionEnabled = YES;
    UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapProfilePhoto:)];
    [theCell.profilePhoto addGestureRecognizer:tg];
    
//    Match *newMatch = [Match matchWithExternalId:match.externalId inManagedObjectContext:self.managedObjectContext];
//    ALog(@"looking for messages with match user %@", newMatch)
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PrivateMessage"];
//    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]];
//    request.predicate = [NSPredicate predicateWithFormat:@"withMatch == %@", newMatch];
//    NSArray *messages = [self.managedObjectContext executeFetchRequest:request error:nil];
//    ALog(@"found messages %@", messages);
    
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]];
    NSArray *sortedMessages = [match.privateMessages sortedArrayUsingDescriptors:sortDescriptors];
    PrivateMessage *message = [sortedMessages lastObject];
    ALog(@"Message %@", message.message);
    
    if (message.message) {
        theCell.subtitleLabel.text = message.message;
    } else if (match.matchedAt) {
        NSString *matchedAt = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Совпадение от", nil), [_fm stringFromDate:match.matchedAt]];
        theCell.subtitleLabel.text = matchedAt;
    } else if (match.latitude && [match.latitude integerValue] > 0 && [self.currentUser.latitude integerValue] > 0) {
        theCell.subtitleLabel.text = [NSString stringWithFormat:@"в %@ от тебя", [match getDistanceFrom:self.currentUser]];
    } else {
        theCell.subtitleLabel.text = match.fullLocation;
    }

    return theCell;
}

- (void)fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController configureCell:(MatchCell *)theCell atIndexPath:(NSIndexPath *)theIndexPath
{
    // Configure the cell...
    Match *match = [fetchedResultsController objectAtIndexPath:theIndexPath];
    
    theCell.nameLabel.text = match.firstName;
    [theCell.profilePhoto setCircleWithUrl:match.photoUrl];
    theCell.profilePhoto.tag = theIndexPath.row;
    theCell.profilePhoto.userInteractionEnabled = YES;
    UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapProfilePhoto:)];
    [theCell.profilePhoto addGestureRecognizer:tg];
    
    
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]];
    NSArray *sortedMessages = [match.privateMessages sortedArrayUsingDescriptors:sortDescriptors];
    PrivateMessage *message = [sortedMessages lastObject];
    
    
    if (message.message) {
        theCell.subtitleLabel.text = message.message;
    } else if (match.matchedAt) {
        NSString *matchedAt = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Совпадение от", nil), [_fm stringFromDate:match.matchedAt]];
        theCell.subtitleLabel.text = matchedAt;
    } else if (match.latitude && [match.latitude integerValue] > 0 && [self.currentUser.latitude integerValue] > 0) {
        theCell.subtitleLabel.text = [NSString stringWithFormat:@"в %@ от тебя", [match getDistanceFrom:self.currentUser]];
    } else {
        theCell.subtitleLabel.text = match.fullLocation;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Match *match = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"CommentThread" sender:match];
}

//- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView
//{
//    return tableView == self.myTableView ? self.fetchedResultsController : self.searchFetchedResultsController;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 65.0;
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [[[self fetchedResultsControllerForTableView:tableView] fetchedObjects] count];
//}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}





- (void)fetchResults {
    
    NSManagedObjectContext *loadMatchesContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    loadMatchesContext.parentContext = self.managedObjectContext;
    User *user = [User userWithExternalId:self.currentUser.externalId inManagedObjectContext:loadMatchesContext];

    [loadMatchesContext performBlock:^{
        [RestMatch load:^(NSMutableArray *matches) {
            for (RestMatch *restMatch in matches) {
                Match *match = [Match matchWithRestMatch:restMatch inManagedObjectContext:loadMatchesContext];
                
                if (match)
                    [user addMatchesObject:match];
                NSError *error;
                [loadMatchesContext save:&error];
                ALog(@"error %@", error);
            }
            
            
            [self.managedObjectContext performBlock:^{
                self.currentUser = [User currentUser:self.managedObjectContext];
                [self.managedObjectContext save:nil];
                [self checkNoResults];
            }];
            
        } onError:^(NSError *error) {
            
        }];
    }];
    
}


- (IBAction)revealMenu:(id)sender
{
    [self.viewDeckController toggleLeftView];
}

- (IBAction)didTapProfilePhoto:(id)sender {
    NSInteger row = ((UITapGestureRecognizer *)sender).view.tag;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    Match *match = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"UserProfileFromMatches" sender:match];
}


//#pragma mark -
//#pragma mark Content Filtering
//- (void)filterContentForSearchText:(NSString*)searchText scope:(NSInteger)scope
//{
//    // update the filter, in this case just blow away the FRC and let lazy evaluation create another with the relevant search info
//    //self.searchFetchedResultsController.delegate = nil;
//    //self.searchFetchedResultsController = nil;
//    _searchFetchedResultsController.delegate = nil;
//    _searchFetchedResultsController = nil;
//    // if you care about the scope save off the index to be used by the serchFetchedResultsController
//    //self.savedScopeButtonIndex = scope;
//}


//#pragma mark -
//#pragma mark Search Bar
//
//- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView;
//{
//    // search is done so get rid of the search FRC and reclaim memory
//    //self.searchFetchedResultsController.delegate = nil;
//    //self.searchFetchedResultsController = nil;
//    _searchFetchedResultsController.delegate = nil;
//    _searchFetchedResultsController = nil;
//}
//
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    DLog(@"shouldReloadTableForSearchString: %@", searchString);
//    [self filterContentForSearchText:searchString
//                               scope:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
//    
//    // Return YES to cause the search result table view to be reloaded.
//    return YES;
//}
//
//
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
//{
//    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
//                               scope:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
//    
//    // Return YES to cause the search result table view to be reloaded.
//    return YES;
//}


//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
//{
//    UITableView *tableView = controller == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;
//    [tableView beginUpdates];
//}
//
//
//- (void)controller:(NSFetchedResultsController *)controller
//  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
//           atIndex:(NSUInteger)sectionIndex
//     forChangeType:(NSFetchedResultsChangeType)type
//{
//    UITableView *tableView = controller == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;
//    
//    switch(type)
//    {
//        case NSFetchedResultsChangeInsert:
//            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
//}
//
//
//- (void)controller:(NSFetchedResultsController *)controller
//   didChangeObject:(id)anObject
//       atIndexPath:(NSIndexPath *)theIndexPath
//     forChangeType:(NSFetchedResultsChangeType)type
//      newIndexPath:(NSIndexPath *)newIndexPath
//{
//    UITableView *tableView = controller == self.fetchedResultsController ? self.myTableView : self.searchDisplayController.searchResultsTableView;
//    
//    switch(type)
//    {
//        case NSFetchedResultsChangeInsert:
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:theIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeUpdate:
//            if (theIndexPath.section != 0 || [self.searchDisplayController isActive]) {
//                [self fetchedResultsController:controller configureCell:(MatchCell *)[tableView cellForRowAtIndexPath:theIndexPath] atIndexPath:theIndexPath];
//            }
//            break;
//            
//        case NSFetchedResultsChangeMove:
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:theIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
//}
//
//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
//{
//    UITableView *tableView = controller == self.fetchedResultsController ? self.myTableView : self.searchDisplayController.searchResultsTableView;
//    
//    if (self.beganUpdates) [tableView endUpdates];
//}
//
//
//
//
//
//- (NSFetchedResultsController *)newFetchedResultsControllerWithSearch:(NSString *)searchString
//{
//    
//    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO]];
//    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"self IN %@", self.currentUser.matches];
//    
//    ALog(@"FETCH FOR USER: %i", [self.currentUser.matches count])
//    
//    /*
//     Set up the fetched results controller.
//     */
//    // Create the fetch request for the entity.
//    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Match"];
//    
//    NSMutableArray *predicateArray = [NSMutableArray array];
//    if(searchString.length)
//    {
//        DLog(@"New NFRC with search string: %@", searchString);
//        // your search predicate(s) are added to this array
//        [predicateArray addObject:[NSPredicate predicateWithFormat:@"firstName CONTAINS[cd] %@ OR lastName CONTAINS[cd] %@", searchString, searchString]];
//        // finally add the filter predicate for this view
//        if(filterPredicate)
//        {
//            filterPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:filterPredicate, [NSCompoundPredicate orPredicateWithSubpredicates:predicateArray], nil]];
//        }
//        else
//        {
//            filterPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicateArray];
//        }
//    }
//    
//    [fetchRequest setPredicate:filterPredicate];
//    
//    // Set the batch size to a suitable number.
//    [fetchRequest setFetchBatchSize:20];
//    
//    [fetchRequest setSortDescriptors:sortDescriptors];
//    
//    // Edit the section name key path and cache name if appropriate.
//    // nil for section name key path means "no sections".
//    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
//                                                                                                managedObjectContext:self.managedObjectContext
//                                                                                                  sectionNameKeyPath:nil
//                                                                                                           cacheName:nil];
//    aFetchedResultsController.delegate = self;
//    
//    
//    NSError *error = nil;
//    if (![aFetchedResultsController performFetch:&error])
//    {
//        /*
//         Replace this implementation with code to handle the error appropriately.
//         
//         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
//         */
//        DLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    
//    return aFetchedResultsController;
//}
//
//- (NSFetchedResultsController *)fetchedResultsController
//{
//    if (_fetchedResultsController != nil)
//    {
//        return _fetchedResultsController;
//    }
//    _fetchedResultsController = [self newFetchedResultsControllerWithSearch:nil];
//    return _fetchedResultsController;
//}
//
//- (NSFetchedResultsController *)searchFetchedResultsController
//{
//    if (_searchFetchedResultsController != nil)
//    {
//        return _searchFetchedResultsController;
//    }
//    _searchFetchedResultsController = [self newFetchedResultsControllerWithSearch:self.searchDisplayController.searchBar.text];
//    return _searchFetchedResultsController;
//}
//
//
//- (void)endSuspensionOfUpdatesDueToContextChanges
//{
//    _suspendAutomaticTrackingOfChangesInManagedObjectContext = NO;
//}
//
//- (void)setSuspendAutomaticTrackingOfChangesInManagedObjectContext:(BOOL)suspend
//{
//    if (suspend) {
//        _suspendAutomaticTrackingOfChangesInManagedObjectContext = YES;
//    } else {
//        [self performSelector:@selector(endSuspensionOfUpdatesDueToContextChanges) withObject:0 afterDelay:0];
//    }
//}



@end
