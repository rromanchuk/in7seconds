//
//  IndexViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "IndexViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "MatchesViewController.h"
@interface IndexViewController () {
    NSInteger _numberOfAttempts;
}

@property (strong, nonatomic) User *otherUser;
@end

@implementation IndexViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"settings_icon"] target:self action:@selector(revealMenu:)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"chat_icon"] target:self action:@selector(didTapMatches:)];
    
    ((MenuViewController *)self.slidingViewController.underLeftViewController).delegate = self;
    ((MenuViewController *)self.slidingViewController.underLeftViewController).currentUser = self.currentUser;
    ((MenuViewController *)self.slidingViewController.underLeftViewController).managedObjectContext = self.managedObjectContext;

    self.userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userImageView.layer.borderWidth = 3;
    _numberOfAttempts = 0;
   	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogout)
                                                 name:@"UserNotAuthorized" object:nil];
    
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation-logo"]]; 

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.currentUser) {
        [self performSegueWithIdentifier:@"Login" sender:self];
    } else {
        if (self.currentUser && [self.currentUser.possibleHookups count] > 0) {
            [self setupNextHookup];
        } else {
            [self fetchPossibleHookups];
        }
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Login"]) {
        LoginViewController *vc = (LoginViewController *)segue.destinationViewController;
        vc.managedObjectContext = self.managedObjectContext;
        vc.currentUser = self.currentUser;
        vc.delegate = self;
    } else if ([segue.identifier isEqualToString:@"Matches"]) {
        MatchesViewController *vc = (MatchesViewController *)segue.destinationViewController;
        vc.managedObjectContext = self.managedObjectContext;
        vc.currentUser = self.currentUser;
    }
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)didTapUnlike:(id)sender {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Загрузка...", @"Loading...")];
    [RestUser rejectUser:self.otherUser onLoad:^(RestUser *restUser) {
        [SVProgressHUD dismiss];
        [self setupNextHookup];
    } onError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (IBAction)didTapLike:(id)sender {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Загрузка...", @"Loading...")];
    [RestUser flirtWithUser:self.otherUser onLoad:^(RestUser *restUser) {
        [SVProgressHUD dismiss];
        [self setupNextHookup];
    } onError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (IBAction)didTapMatches:(id)sender {
    [self performSegueWithIdentifier:@"Matches" sender:nil];
}

- (void)setupNextHookup {
    if (self.otherUser)
        [self.currentUser removePossibleHookupsObject:self.otherUser];
    
    self.otherUser = nil;
    
    if (self.currentUser && self.currentUser.possibleHookups) {
        self.otherUser = [self.currentUser.possibleHookups anyObject];
        if (!self.otherUser && _numberOfAttempts < 3) {
            [self fetchPossibleHookups];
            return;
        } else if (!self.otherUser){
            //NO RESULTS LEFT
            ALog(@"No more results found");
            return;
        }
        
        [self.userImageView setProfilePhotoWithURL:self.otherUser.photoUrl];
        self.mutualFriendsLabel.text = [NSString stringWithFormat:@"%@ общих друзей", self.otherUser.mutualFriends];
        self.mutualGroupsLabel.text = [NSString stringWithFormat:@"%@ общих интересов", self.otherUser.mutualGroups];
        ALog(@"birthday %@", self.otherUser.birthday);
        if (self.otherUser.birthday && [self.otherUser.yearsOld integerValue] > 0) {
            self.nameLabel.text = [NSString stringWithFormat:@"%@ %@, %@ %@", self.otherUser.lastName, self.otherUser.firstName, self.otherUser.yearsOld, NSLocalizedString(@"лет", @"years old")];
        } else {
            self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.otherUser.lastName, self.otherUser.firstName];
        }
        
    }
}

- (void)fetchPossibleHookups {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Загрузка...", @"Loading...")];
    _numberOfAttempts++;
    [RestUser reload:^(RestUser *restUser) {
        self.currentUser = [User userWithRestUser:restUser inManagedObjectContext:self.managedObjectContext];
        ((MenuViewController *)self.slidingViewController.underLeftViewController).currentUser = self.currentUser;
        
        [self saveContext];
        [self setupNextHookup];
        [SVProgressHUD dismiss];
    } onError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark LoginDelegate methods
- (void)didVkLogin:(User *)user {
    self.currentUser = user;
    ((MenuViewController *)self.slidingViewController.underLeftViewController).currentUser = self.currentUser;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - LogoutDelegate delegate methods
- (void) didLogout
{
    
    [RestUser resetIdentifiers];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) resetCoreData];
    self.currentUser = nil;
    [[Vkontakte sharedInstance] logout];
    //[[UAPush shared] setAlias:nil];
    //[[UAPush shared] updateRegistration];
    
    //[FBSession.activeSession closeAndClearTokenInformation];
    //[self dismissModalViewControllerAnimated:YES];
    [self performSegueWithIdentifier:@"Login" sender:self];
}

- (void)didUpdateSettings {
    [self fetchPossibleHookups];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UserNotAuthorized"
                                                  object:nil];
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
