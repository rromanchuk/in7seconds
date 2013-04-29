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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
//{
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Notification"];
//    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"isRead" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO], nil];
//    request.predicate = [NSPredicate predicateWithFormat:@"user = %@", self.currentUser, YES];
//    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
//                                                                        managedObjectContext:self.managedObjectContext
//                                                                          sectionNameKeyPath:nil
//                                                                                   cacheName:nil];
//}
//
- (void)fetchResults:(id)refreshControl {
    [self.managedObjectContext performBlock:^{
        [RestNotification load:^(NSSet *notificationItems) {
            for (RestNotification *restNotification in notificationItems) {
                Notification *notification = [Notification notificatonWithRestNotification:restNotification inManagedObjectContext:self.managedObjectContext];
                [self.currentUser addNotificationsObject:notification];
                
            }
            NSError *error;
            [self.managedObjectContext save:&error];
            [refreshControl endRefreshing];
            AppDelegate *sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [sharedAppDelegate writeToDisk];
            [self.tableView reloadData];
            
        } onError:^(NSError *error) {
            DLog(@"Problem loading notifications %@", error);
            [refreshControl endRefreshing];
        }];
        
    }];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
