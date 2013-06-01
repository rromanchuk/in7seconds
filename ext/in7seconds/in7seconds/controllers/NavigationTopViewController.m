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
    
}

- (void)presentNotificationApplicationLaunch:(NSDictionary *)customData {
    
}


#pragma mark - Notification banner methods

- (void)showNotificationBanner {
    [self.notificationBanner setupView];
    
    
    self.notificationBanner.alpha = 0.0;
    if ([self.visibleViewController respondsToSelector:@selector(tableView)] || [self.visibleViewController respondsToSelector:@selector(collectionView)]) {
        ALog(@"has table view!!!!");
        //[self.visibleViewController.view.superview addSubview:self.notificationBanner];
        [self.visibleViewController.view.superview insertSubview:self.notificationBanner aboveSubview:self.visibleViewController.view.superview];
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


@end
