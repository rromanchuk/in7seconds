//
//  MatchesViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/27/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "MatchesViewController.h"
#import "MatchCell.h"
#import "BaseUIView.h"
#import "NoChatsView.h"
#import "CommentViewController.h"
@interface MatchesViewController ()
@property (strong, nonatomic) NoChatsView *noResultsFooterView;

@end

@implementation MatchesViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder])
    {
        self.noResultsFooterView = (NoChatsView *)[[[NSBundle mainBundle] loadNibNamed:@"NoChatsView" owner:self options:nil] objectAtIndex:0];
        self.noResultsFooterView.messageLabel.text = NSLocalizedString(@"У тебя еще нет совпадений. Чтобы они появились, просто начни отмечать понравившихся тебе людей :)", @"no matches");
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
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"back_icon"] target:self action:@selector(back)];
    self.title = NSLocalizedString(@"Симпатии", nil);
    self.tableView.backgroundView = [[BaseUIView alloc] init];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupFetchedResultsController];
    [self checkNoResults];
}

#pragma mark CoreData methods
- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    ALog(@"setting up frc with hookups %@", self.currentUser.hookups);
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"self IN %@", self.currentUser.hookups];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]];
    
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
        User *user = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        vc.otherUser = user;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    MatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MatchCell"];
    cell.nameLabel.text = user.fullName;
    [cell.profileImage setProfilePhotoWithURL:user.photoUrl];
    cell.previewLabel.text = user.fullLocation;
    return cell;
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)fetchResults {
    
}
@end
