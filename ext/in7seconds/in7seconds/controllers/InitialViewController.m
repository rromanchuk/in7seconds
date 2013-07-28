//
//  InitialViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "InitialViewController.h"
#import "IndexViewController.h"
#import "BaseNavigationViewController.h"
#import "MenuViewController.h"
#import "IndexViewController.h"

#import "RestHookup.h"
#import "Hookup+REST.h"
#import "Location.h"


@interface InitialViewController ()

@end

@implementation InitialViewController


- (id)initWithCoder:(NSCoder *)aDecoder
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    self = [super initWithCenterViewController:[storyboard instantiateViewControllerWithIdentifier:@"middleViewController"]
                                leftViewController:[storyboard instantiateViewControllerWithIdentifier:@"leftViewController"]];
        
    if (self) {
        
    }
    return self;
}



//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogout)
//                                                 name:@"UserNotAuthorized" object:nil];
//
//}
//
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setup];
}
//
//
//
- (void)setup {
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
    }
    
    User *currentUser = [User currentUser:self.managedObjectContext];
    if (currentUser) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        MenuViewController *menu = [storyboard instantiateViewControllerWithIdentifier:@"leftViewController"];
        menu.managedObjectContext = self.managedObjectContext;
        menu.currentUser = currentUser;
        self.viewDeckController.leftController = menu;
    } else {
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        loginViewController.managedObjectContext = self.managedObjectContext;
        loginViewController.currentUser = currentUser;
    }

// Do any additional setup after loading the view.
//ALog(@"moc: %@ currentUser: %@", self.managedObjectContext, self.currentUser);
//    ((IndexViewController *)nc.topViewController).managedObjectContext = self.managedObjectContext;
//    ((IndexViewController *)nc.topViewController).currentUser = self.currentUser;
//    ((MenuViewController *)nc.slidingViewController.underLeftViewController).delegate = self;
    
    BaseNavigationViewController *leftController = (BaseNavigationViewController *)self.viewDeckController.leftController;
    BaseNavigationViewController *centerController = (BaseNavigationViewController *)self.viewDeckController.centerController;
    ((MenuViewController *)leftController.topViewController).managedObjectContext = self.managedObjectContext;
    ((MenuViewController *)leftController.topViewController).currentUser = self.currentUser;

    ((IndexViewController *)centerController.topViewController).managedObjectContext = self.managedObjectContext;
    ((IndexViewController *)centerController.topViewController).currentUser = self.currentUser;

}
//
//#pragma mark LoginDelegate methods
//- (void)didVkLogin:(User *)user {
//    self.currentUser = user;
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)didFbLogin:(User *)user {
//    self.currentUser = user;
//    //[self dismissViewControllerAnimated:YES completion:nil];
//    [self dismissModalViewControllerAnimated:YES];
//}
//
//#pragma mark - LogoutDelegate delegate methods
//- (void) didLogout
//{
//    ALog(@"in logout");
//    [[Location sharedLocation] stopUpdatingLocation:@"logout"];
//    [[[RestClient sharedClient] operationQueue] cancelAllOperations];
//    [RestUser resetIdentifiers];
//    [[Vkontakte sharedInstance] logout];
//    
//    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) resetCoreData];
//    AppDelegate *sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [sharedAppDelegate resetWindowToInitialView];
//}
//
//- (void)saveContext
//{
//    NSError *error = nil;
//    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil) {
//        if ([_managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//            // Replace this implementation with code to handle the error appropriately.
//            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        }
//    }
//    
//    AppDelegate *sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [sharedAppDelegate writeToDisk];
//}

@end
