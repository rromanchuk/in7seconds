//
//  NavigationTopViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "NavigationTopViewController.h"
#import "AppDelegate.h"
#import "Vkontakte.h"
#import "Hookup+REST.h"
#import "Match+REST.h"
#import "RestHookup.h"
#import "IndexViewController.h"
@interface NavigationTopViewController ()

@end

@implementation NavigationTopViewController 

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder])
    {
        self.notificationBanner = (NotificationBanner *)[[[NSBundle mainBundle] loadNibNamed:@"NotificationBanner" owner:self options:nil] objectAtIndex:0];
        [self.notificationBanner.dismissButton addTarget:self action:@selector(didDismissNotificationBanner:) forControlEvents:UIControlEventTouchUpInside];
        [self.notificationBanner.notificationTextLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapNotificationBanner:)]];
        //self.isChildNavigationalStack = NO;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [NotificationHandler shared].delegate = self;
    // Remove the default black bottom border
    UIView *overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
    [overlayView setBackgroundColor:RGBCOLOR(223.0, 223.0, 223.0)];
    [self.navigationBar addSubview:overlayView]; // navBar is your UINavigationBar instance
    self.navigationBar.clipsToBounds = YES;

}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    //((MenuViewController *)self.slidingViewController.underLeftViewController).delegate = self;
    ((MenuViewController *)self.slidingViewController.underLeftViewController).currentUser = self.currentUser;
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
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


#pragma mark - NotificationDisplayModalDelegate methods
- (void)presentIncomingNotification:(NSDictionary *)customData notification:(NSDictionary *)notification {
    NSString *type = [[customData objectForKey:@"extra"] objectForKey:@"type"];
    NSString *alert = [[notification objectForKey:@"aps"] objectForKey:@"alert"];
    self.notificationBanner = (NotificationBanner *)[[[NSBundle mainBundle] loadNibNamed:@"NotificationBanner" owner:self options:nil] objectAtIndex:0];
    [self.notificationBanner.dismissButton addTarget:self action:@selector(didDismissNotificationBanner:) forControlEvents:UIControlEventTouchUpInside];
    [self.notificationBanner.notificationTextLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapNotificationBanner:)]];

    
    ALog(@"got alert %@", alert);
    ALog(@"got notification %@ and customData %@", customData, notification);
    if([type isEqualToString:@"private_message"]) {
        [[NotificationHandler shared].managedObjectContext performBlock:^{            
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
                Match *match = [Match matchWithExternalId:[[customData objectForKey:@"extra"] objectForKey:@"sender_id"] inManagedObjectContext:[NotificationHandler shared].managedObjectContext];
                ALog(@"found other match user %@", match);
                self.notificationBanner.sender = match;
                self.notificationBanner.notificationTextLabel.text = alert;
                self.notificationBanner.segueTo = @"DirectToChat";
                
                [self showNotificationBanner];

                
            } onError:^(NSError *error) {
                
            }];
        }];
    }
}

- (void)presentNotificationApplicationLaunch:(NSDictionary *)customData {
    ALog(@"Reacting to notification received ");
    NSString *type = [[customData objectForKey:@"extra"] objectForKey:@"type"];
    
    if ([type isEqualToString:@"private_message"]) {
        [self popToRootViewControllerAnimated:NO];
        
        ALog(@"fetching for item %@", [[customData objectForKey:@"extra"] objectForKey:@"feed_item_id"]);
        [SVProgressHUD show];
        [[NotificationHandler shared].managedObjectContext performBlock:^{
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
                Match *match = [Match matchWithExternalId:[[customData objectForKey:@"extra"] objectForKey:@"user_id"] inManagedObjectContext:[NotificationHandler shared].managedObjectContext];
                [self.visibleViewController performSegueWithIdentifier:@"CommentThread" sender:match];
                [SVProgressHUD dismiss];
                
            } onError:^(NSError *error) {
                [SVProgressHUD dismiss];
            }];
        }];

    }
}


#pragma mark - Notification banner methods

- (void)showNotificationBanner {
    [self.notificationBanner setupView];
    
    
    self.notificationBanner.alpha = 0.0;
    if ([self.visibleViewController respondsToSelector:@selector(tableView)] || [self.visibleViewController respondsToSelector:@selector(collectionView)]) {
        ALog(@"has table view!!!!");
        //[self.visibleViewController.view.superview addSubview:self.notificationBanner];
        //[self.visibleViewController.view.superview insertSubview:self.notificationBanner aboveSubview:self.visibleViewController.view.superview];
        //[self.navigationController.view.superview addSubview:self.notificationBanner];
        [self.view addSubview:self.notificationBanner];
    } else {
        ALog(@"has no table view!!!");
        [self.visibleViewController.view insertSubview:self.notificationBanner aboveSubview:self.visibleViewController.view];
    }
    
    
    [NotificationBanner animateWithDuration:2.0
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     self.notificationBanner.alpha = 1.0;
                                 }
                                 completion:^(BOOL finished) {
                                     [self performSelector:@selector(hideNotificationBanner) withObject:nil afterDelay:5.0];
                                 }
     ];
}

- (void)hideNotificationBanner {
    
    [NotificationBanner animateWithDuration:2.0
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     self.notificationBanner.alpha = 0.0;
                                 }
                                 completion:^(BOOL finished) {
                                     [self.notificationBanner removeFromSuperview];
                                 }
     ];
    
}

- (IBAction)didDismissNotificationBanner:(id)sender {
    [self hideNotificationBanner];
}

- (IBAction)didTapNotificationBanner:(id)sender {
    // Don't allow the user to interupt his checkin flow. maybe change this when we know how to handle this better
    if (!self.isChildNavigationalStack) {
        [self popToRootViewControllerAnimated:NO];
        [self.visibleViewController performSegueWithIdentifier:self.notificationBanner.segueTo sender:self.notificationBanner.sender];
    }
}


@end
