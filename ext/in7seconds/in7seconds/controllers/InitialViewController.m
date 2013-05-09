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
#import "Location.h"
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
    nc.managedObjectContext = self.managedObjectContext;
    ((IndexViewController *)nc.topViewController).managedObjectContext = self.managedObjectContext;
    ((IndexViewController *)nc.topViewController).currentUser = self.currentUser;
    ((MenuViewController *)nc.slidingViewController.underLeftViewController).delegate = self;
    
}

#pragma mark LoginDelegate methods
- (void)didVkLogin:(User *)user {
    self.currentUser = user;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didFbLogin:(User *)user {
    self.currentUser = user;
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - LogoutDelegate delegate methods
- (void) didLogout
{
    ALog(@"in logout");
    [[Location sharedLocation] stopUpdatingLocation:@"logout"];
    [[[RestClient sharedClient] operationQueue] cancelAllOperations];
    [RestUser resetIdentifiers];
    [[Vkontakte sharedInstance] logout];
    
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) resetCoreData];
    AppDelegate *sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [sharedAppDelegate resetWindowToInitialView];
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
