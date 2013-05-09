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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Remove the default black bottom border
    UIView *overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
    [overlayView setBackgroundColor:RGBCOLOR(223.0, 223.0, 223.0)];
    [self.navigationBar addSubview:overlayView]; // navBar is your UINavigationBar instance
    self.navigationBar.clipsToBounds = YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@end
