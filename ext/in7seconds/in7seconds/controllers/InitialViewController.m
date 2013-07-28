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
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    self.currentUser = [User currentUser:self.managedObjectContext];
    if (self.currentUser) {
        self = [super initWithCenterViewController:[storyboard instantiateViewControllerWithIdentifier:@"middleViewController"]
                                leftViewController:[storyboard instantiateViewControllerWithIdentifier:@"leftViewController"]];
    } else {
        self = [super initWithCenterViewController:[storyboard instantiateViewControllerWithIdentifier:@"middleViewController"]
                                leftViewController:[storyboard instantiateViewControllerWithIdentifier:@"loginViewController"]];
    }
            
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
