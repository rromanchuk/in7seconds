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
	// Do any additional setup after loading the view.
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
    ((MenuViewController *)self.slidingViewController.underLeftViewController).delegate = self;
    ((MenuViewController *)self.slidingViewController.underLeftViewController).currentUser = self.currentUser;
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}


#pragma mark - LogoutDelegate delegate methods
- (void) didLogout
{
    ALog(@"in logout");
    [RestUser resetIdentifiers];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) resetCoreData];
    [[Vkontakte sharedInstance] logout];
    self.currentUser = nil;
    //[[UAPush shared] setAlias:nil];
    //[[UAPush shared] updateRegistration];
    
    //[FBSession.activeSession closeAndClearTokenInformation];
    //[self dismissModalViewControllerAnimated:YES];
    
    [self performSegueWithIdentifier:@"Login" sender:self];
}

- (void)didUpdateSettings {
    self.currentUser = [User currentUser:self.managedObjectContext];
    NavigationTopViewController *nc = ((NavigationTopViewController *)self.topViewController);
    ((IndexViewController *)nc.topViewController).currentUser = self.currentUser;
    
}

- (void)didChangeFilters {
    ALog(@"in change filters");
    self.currentUser = [User currentUser:self.managedObjectContext];
    [self.currentUser removeHookups:self.currentUser.hookups];
    [self saveContext];
    
    [RestHookup load:^(NSMutableArray *possibleHookups) {
        NSMutableSet *_restHookups = [[NSMutableSet alloc] init];
        for (RestHookup *restHookup in possibleHookups) {
            ALog(@"adding resthookup %@", restHookup);
            [_restHookups addObject:[Hookup hookupWithRestHookup:restHookup inManagedObjectContext:self.managedObjectContext]];
        }
        [self.currentUser addHookups:_restHookups];
        ALog(@"hookups are%@", self.currentUser.hookups);
        [self saveContext];
        NavigationTopViewController *nc = ((NavigationTopViewController *)self.topViewController);
        ((IndexViewController *)nc.topViewController).currentUser = self.currentUser;
    } onError:^(NSError *error) {
        
    }];
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
