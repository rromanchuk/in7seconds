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
#import "Thread+REST.h"
#import "AppDelegate.h"
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
    self.navigationController.navigationBarHidden = NO;
    _ledgeSize = self.viewDeckController.rightLedgeSize;
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    self.currentUser = [User currentUser:self.managedObjectContext];
    
    if (self.fromMenu) {
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        space.width = 20;
        self.navigationItem.leftBarButtonItems = @[space, [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"sidebar_button"] target:self action:@selector(revealMenu:)]];

    } else {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"back_icon"] target:self action:@selector(back)];
    }
    
    self.title = NSLocalizedString(@"Симпатии", nil);
    [[UAPush shared] resetBadge];
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchResults:) forControlEvents:UIControlEventValueChanged];
    
    [self fetchResults:nil];
    [self setupFetchedResultsController];
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
    [self saveContext];
}

#pragma mark CoreData methods
- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Match"];
    request.predicate = [NSPredicate predicateWithFormat:@"self IN %@", self.currentUser.matches];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Match *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    MatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MatchCell"];
    cell.nameLabel.text = user.firstName;
    [cell.profilePhoto setCircleWithUrl:user.photoUrl];
    cell.profilePhoto.tag = indexPath.row;
    cell.profilePhoto.userInteractionEnabled = YES;
    UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapProfilePhoto:)];
    [cell.profilePhoto addGestureRecognizer:tg];
    
    
//    if (user.latitude && [user.latitude integerValue] > 0 && [self.currentUser.latitude integerValue] > 0) {
//        cell.previewLabel.text = [NSString stringWithFormat:@"в %@ от тебя", [user getDistanceFrom:self.currentUser]];
//    } else {
//        cell.previewLabel.text = user.fullLocation;
//    }

    
    
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]];
    NSArray *sortedMessages = [user.thread.messages sortedArrayUsingDescriptors:sortDescriptors];
    PrivateMessage *message = [sortedMessages lastObject];
    cell.subtitleLabel.text = message.message;
    
    
//    if (message) {
//        ALog(@"message");
//        cell.dateLabel.text = [_fm stringFromDate:message.createdAt];
//    } else {
//        ALog(@"match created");
//        cell.dateLabel.text = [_fm stringFromDate:user.createdAt];
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Match *match = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"CommentThread" sender:match];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)fetchResults:(id)refreshControl {
    [self.managedObjectContext performBlock:^{
        [RestMatch load:^(NSMutableArray *matches) {
            
            NSMutableSet *_restMatches = [[NSMutableSet alloc] init];
            for (RestMatch *restMatch in matches) {
                [_restMatches addObject:[Match matchWithRestMatch:restMatch inManagedObjectContext:self.managedObjectContext]];
            }
            [self.currentUser addMatches:_restMatches];
            
            NSError *error;
            [self.managedObjectContext save:&error];
            
            AppDelegate *sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [sharedAppDelegate writeToDisk];
            
            [self checkNoResults];
            [refreshControl endRefreshing];
        } onError:^(NSError *error) {
            [refreshControl endRefreshing];
        }];
    }];
}

- (IBAction)revealMenu:(id)sender
{
    [self.viewDeckController toggleLeftView];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([_managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
    
    AppDelegate *sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [sharedAppDelegate writeToDisk];
}

- (IBAction)didTapProfilePhoto:(id)sender {
    NSInteger row = ((UITapGestureRecognizer *)sender).view.tag;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    Match *match = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"UserProfileFromMatches" sender:match];
}


@end
