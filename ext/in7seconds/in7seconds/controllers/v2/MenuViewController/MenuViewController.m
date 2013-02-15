//
//  MenuViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 8/7/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "MenuViewController.h"
#import "SettingsViewController.h"
#import "MyProfileViewController.h"
#import "MatchesViewController.h"
#import "IndexViewController.h"
#import <ViewDeck/IIViewDeckController.h>
#import "User+REST.h"
typedef enum {
    SSMenuRowSpace1,
    SSMenuRowRecommendations,
    SSMenuRowMatches,
    SSMenuRowSpace2,
    SSMenuRowSpace3,
    SSMenuRowSettings,
    SSMenuRowProfile,
    SSMenuRowShare,
    numSSMenuRow
} SSMenuRow;

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_sidebar"]];
    self.navigationController.navigationBarHidden = YES;
    [self setupNotifications];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.currentUser) {
        self.currentUser = [User currentUser:self.managedObjectContext];
    }
    [self.profilePhoto setCircleWithUrl:self.currentUser.photoUrl];
}

- (void)setupNotifications {
    NSInteger numNotifications = [self.currentUser numberOfUnreadNotifications];
    if (numNotifications == 0) {
        self.notificationsLabel.hidden = YES;
    } else {
        self.numNotificationsLabel.text = [NSString stringWithFormat:@"%d", [self.currentUser numberOfUnreadNotifications]];
        self.notificationsLabel.hidden = NO;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];

    if (indexPath.row == SSMenuRowRecommendations) {
        UINavigationController *nc =  (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"middleViewController"];
        ((IndexViewController *)nc.topViewController).managedObjectContext = self.managedObjectContext;
        self.viewDeckController.centerController = nc;

    } else if (indexPath.row == SSMenuRowMatches) {
        UINavigationController *nc =  (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"matchesControllerFromMenu"];
        ((MatchesViewController *)nc.topViewController).managedObjectContext = self.managedObjectContext;
        ((MatchesViewController *)nc.topViewController).fromMenu = YES;
        self.viewDeckController.centerController = nc;

    } else if (indexPath.row == SSMenuRowSettings) {
        UINavigationController *nc =  (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"settings"];
        ((SettingsViewController *)nc.topViewController).managedObjectContext = self.managedObjectContext;
        self.viewDeckController.centerController = nc;

    } else if (indexPath.row == SSMenuRowProfile) {
        UINavigationController *nc =  (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"profile"];
        ((MyProfileViewController *)nc.topViewController).managedObjectContext = self.managedObjectContext;
        ((MyProfileViewController *)nc.topViewController).currentUser = self.currentUser;

        self.viewDeckController.centerController = nc;
    }
    [self.viewDeckController toggleLeftView];
}


@end




