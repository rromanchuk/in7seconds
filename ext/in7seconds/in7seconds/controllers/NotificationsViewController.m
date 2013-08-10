//
//  NotificationsViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/14/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "NotificationsViewController.h"
#import "CommentViewController.h"
#import "RestNotification.h"
#import "Notification+REST.h"
#import "Match+REST.h"

#import "AppDelegate.h"

#import "NotificationCell.h"

@interface NotificationsViewController ()
@end

@implementation NotificationsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Уведомления";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"back_icon"] target:self action:@selector(back)];
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchResults:) forControlEvents:UIControlEventValueChanged];
    
    [self setupFetchedResultsController];
    [self fetchResults:nil];
}


- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Notification"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"isRead" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO]];
    request.predicate = [NSPredicate predicateWithFormat:@"user = %@", self.currentUser, YES];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   if ([segue.identifier isEqualToString:@"DirectToChat"]) {
        CommentViewController *vc = (CommentViewController *)segue.destinationViewController;
        vc.managedObjectContext = self.managedObjectContext;
        vc.currentUser = self.currentUser;
        vc.otherUser = (Match *)sender;
    } 
}


- (void)fetchResults:(id)refreshControl {
    [self.managedObjectContext performBlock:^{
        [RestNotification reload:^(NSArray *notifications) {
            for (RestNotification *restNotification in notifications) {
                Notification *notification = [Notification notificationWithRestNotification:restNotification inManagedObjectContext:self.managedObjectContext];
                [self.currentUser addNotificationsObject:notification];
            }
            NSError *error;
            [self.managedObjectContext save:&error];
            
            AppDelegate *sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [sharedAppDelegate writeToDisk];
            [refreshControl endRefreshing];
        } onError:^(NSError *error) {
            [refreshControl endRefreshing];
        }];
    }];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NotificationCell";
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[NotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    Notification *notification = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (![notification.isRead boolValue]) {
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = RGBCOLOR(245, 201, 216);
        cell.backgroundView = bgColorView;
        cell.notficationLabel.backgroundColor = RGBCOLOR(245, 201, 216);
        cell.isNotRead = YES;
    } else {
        cell.backgroundView = nil;
        cell.notficationLabel.backgroundColor = [UIColor backgroundColor];
        cell.isNotRead = NO;
    }
    
    ALog(@"users name is %@", notification.sender.fullName);
    ALog(@"sender is %@", notification.sender);
    cell.notficationLabel.text = notification.message;
    cell.notficationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    cell.notficationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.notficationLabel.numberOfLines = 0;
    
    if (notification.sender) {
        cell.profilePhotoView.hidden = NO;
        //[cell.profilePhotoView setProfileImageWithUrl:notification.sender.photoUrl];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.profilePhotoView.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Notification *notification = [self.fetchedResultsController objectAtIndexPath:indexPath];
    notification.isRead = @YES;
    NSError *error;
    [self.managedObjectContext save:&error];
    [self.tableView reloadData];
    if (notification.sender) {
        [self performSegueWithIdentifier:@"DirectToChat" sender:notification.sender];
    } 
    
}


@end
