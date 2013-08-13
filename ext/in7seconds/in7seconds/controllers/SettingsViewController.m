//
//  SettingsViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 8/11/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "SettingsViewController.h"

#import "Location.h"
#import "AppDelegate.h"
#import "RestUser.h"
#import "Vkontakte.h"

#import <ViewDeck/IIViewDeckController.h>


@interface SettingsViewController ()
@property BOOL isFetching;
@property BOOL filtersChanged;
@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentUser = [User currentUser:self.managedObjectContext];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 20;
    self.navigationItem.leftBarButtonItems = @[space, [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"sidebar_button"] target:self action:@selector(revealMenu:)]];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SSSettingsSectionTypeGender) {
        
    } else if (indexPath.section == SSSettingsSectionTypeDistance) {
        
    } else if (indexPath.section == SSSettingsSectionTypeAge) {
        
    } else if (indexPath.section == SSSettingsSectionTypePush) {
        
    } else if (indexPath.section == SSSettingsSectionTypeLogout) {
        [self didLogout];
    }
}

- (IBAction)revealMenu:(id)sender
{
    [self.viewDeckController toggleLeftView];
}

- (void)update {
    [self.managedObjectContext performBlock:^{
        _isFetching  = YES;
        [RestUser update:self.currentUser onLoad:^(RestUser *restUser) {
            [SVProgressHUD dismiss];
            self.currentUser = [User userWithRestUser:restUser inManagedObjectContext:self.managedObjectContext];
            
            NSError *error;
            [self.managedObjectContext save:&error];
            
            AppDelegate *sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [sharedAppDelegate writeToDisk];
            
            if (_filtersChanged) {
                _filtersChanged = NO;
            }
            _isFetching = NO;
        } onError:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            _isFetching = NO;
        }];
    }];
    
}


- (IBAction)didTapLogout:(id)sender {
    //ALog(@"did tap logout sending to delegate %@", self.delegate);
    [self didLogout];
}

- (void)didLogout
{
    ALog(@"in logout");
    [[Location sharedLocation] stopUpdatingLocation:@"logout"];
    [[[RestClient sharedClient] operationQueue] cancelAllOperations];
    [RestUser resetIdentifiers];
    [[Vkontakte sharedInstance] logout];
    
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) resetCoreData];
    
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    //
    //    BaseNavigationViewController *centerViewController = [storyboard instantiateViewControllerWithIdentifier:@"middleViewController"];
    //    self.viewDeckController.centerController = centerViewController;
    //
    //    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    //    self.viewDeckController.leftController = loginViewController;
    //
    AppDelegate *sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [sharedAppDelegate resetWindowToInitialView];
    
    
}

- (IBAction)lookingForMenChanged:(id)sender {
    if ((self.lookingForMenSwitch.on && self.lookingForWomenSwitch.on) || (!self.lookingForMenSwitch.on && !self.lookingForWomenSwitch.on)) {
        self.currentUser.lookingForGender = @(LookingForBoth);
    } else if (self.lookingForMenSwitch.on) {
        self.currentUser.lookingForGender = @(LookingForMen);
    } else if (self.lookingForWomenSwitch.on) {
        self.currentUser.lookingForGender = @(LookingForWomen);
    }
    
}

- (IBAction)notificationSettingsChanged:(id)sender {
    _filtersChanged = YES;
    UISwitch *mySwitch = (UISwitch *)sender;
    if (mySwitch == self.notificationEmailSwitch) {
        self.currentUser.emailOptIn = @(self.notificationEmailSwitch.on);
    } else {
        self.currentUser.pushOptIn = @(self.notificationPushSwitch.on);
    }
    [self update];
}


- (IBAction)lookingForWomenChanged:(id)sender {
}
@end
