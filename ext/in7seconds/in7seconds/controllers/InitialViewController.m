//
//  InitialViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "InitialViewController.h"
#import "NavigationTopViewController.h"
#import "IndexViewController.h"
#import "RestHookup.h"
#import "Hookup+REST.h"
@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Login"]) {        
        LoginViewController *vc = (LoginViewController *)segue.destinationViewController;
        vc.managedObjectContext = self.managedObjectContext;
        vc.currentUser = self.currentUser;
        vc.delegate = self;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogout)
                                                 name:@"UserNotAuthorized" object:nil];

    [self setup];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.currentUser) {
        [self setup];
    } else {
        [self performSegueWithIdentifier:@"Login" sender:self];
    }
}

- (void)setup {
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
    }

    // Do any additional setup after loading the view.
    ALog(@"moc: %@ currentUser: %@", self.managedObjectContext, self.currentUser);
    self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationTop"];
    NavigationTopViewController *nc = ((NavigationTopViewController *)self.topViewController);
    ((IndexViewController *)nc.topViewController).managedObjectContext = self.managedObjectContext;
    ((IndexViewController *)nc.topViewController).currentUser = self.currentUser;
    
    self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    ((MenuViewController *)self.slidingViewController.underLeftViewController).delegate = self;
    ((MenuViewController *)self.slidingViewController.underLeftViewController).currentUser = self.currentUser;
    
}

#pragma mark LoginDelegate methods
- (void)didVkLogin:(User *)user {
    self.currentUser = user;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - LogoutDelegate delegate methods
- (void) didLogout
{
    DLog(@"in logout");
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
    } onError:^(NSError *error) {
        
    }];

    
    NavigationTopViewController *nc = ((NavigationTopViewController *)self.topViewController);
    ((IndexViewController *)nc.topViewController).currentUser = self.currentUser;
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
