//
//  NotificationsViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/14/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "NotificationsViewController.h"
#import "BaseUIView.h"
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
    self.tableView.backgroundView = [[BaseUIView alloc] init];
    [self setupFetchedResultsController];
    [self fetchResults];
}


- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Notification"];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"isRead" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO], nil];
    request.predicate = [NSPredicate predicateWithFormat:@"user = %@", self.currentUser, YES];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (void)fetchResults {
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
        } onError:^(NSError *error) {
            
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
    
    DLog(@"users name is %@", notification.sender.fullName);
    NSString *text;
//    if ([notification.notificationType integerValue] == NotificationTypeNewComment ) {
//        text = [NSString stringWithFormat:@"%@ %@ %@.", notification.sender.fullName, NSLocalizedString(@"LEFT_A_COMMENT", @"Copy for commenting"), notification.placeTitle];
//    } else if ([notification.notificationType integerValue] == NotificationTypeNewFriend) {
//        text = [NSString stringWithFormat:@"%@ %@.", notification.sender.fullName, NSLocalizedString(@"FOLLOWED_YOU", @"Copy for following")];
//    }
    cell.notficationLabel.text = notification.message;
    cell.notficationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    cell.notficationLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.notficationLabel.numberOfLines = 0;
    
    if (notification.sender) {
        DLog(@"sender is %@", notification.sender);
        cell.profilePhotoView.hidden = NO;
        [cell.profilePhotoView setProfilePhotoWithURL:notification.sender.photoUrl];
    } else {
        cell.profilePhotoView.hidden = YES;
    }
    //[cell.profilePhotoView setProfileImageForUser:notification.sender];
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    Notification *notification = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    notification.isRead = [NSNumber numberWithBool:YES];
//    NSError *error;
//    [self.managedObjectContext save:&error];
//    [self.tableView reloadData];
//    if ([notification.notificationType integerValue] == NotificationTypeNewComment) {
//        [self performSegueWithIdentifier:@"CheckinShow" sender:notification];
//    } else {
//        [self performSegueWithIdentifier:@"UserShow" sender:notification.sender];
//    }
//    
//}


@end
