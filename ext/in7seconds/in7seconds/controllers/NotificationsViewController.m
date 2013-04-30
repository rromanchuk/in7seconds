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
#import "AppDelegate.h"

@interface NotificationsViewController ()

@end

@implementation NotificationsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
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



@end
