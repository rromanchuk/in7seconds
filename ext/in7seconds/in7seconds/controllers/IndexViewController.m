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
#import "CircleCounterView.h"
#import "CircleDownCounter.h"
#import "CommentViewController.h"
#import "UserProfileViewController.h"

@interface IndexViewController () {
    NSInteger _numberOfAttempts;
    BOOL _noResults;
}

@property (strong, nonatomic) User *otherUser;
@end

@implementation IndexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"settings_icon"] target:self action:@selector(revealMenu:)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"chat_icon"] target:self action:@selector(didTapMatches:)];
    
    //((MenuViewController *)self.slidingViewController.underLeftViewController).delegate = self;
    //((MenuViewController *)self.slidingViewController.underLeftViewController).managedObjectContext = self.managedObjectContext;

    self.userImageView.delegate = self;
    self.userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userImageView.layer.borderWidth = 3;
    _numberOfAttempts = 0;
   	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogout)
                                                 name:@"UserNotAuthorized" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topDidAppear) name:@"ECSlidingViewTopDidReset" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftViewWillAppear) name:@"ECSlidingViewUnderLeftWillAppear" object:nil];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation-logo"]];
    
}

- (void)leftViewWillAppear {
    ALog(@"left fiew will appear with user");
    [self stopCountdown];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.currentUser) {
        [self performSegueWithIdentifier:@"Login" sender:self];
        return;
    }
    [self topDidAppear];
}


- (void)getDistance {
    CLLocation *targetLocation = [[CLLocation alloc] initWithLatitude: [self.currentUser.latitude doubleValue] longitude:[self.currentUser.longitude doubleValue]];
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:[self.otherUser.latitude doubleValue] longitude:[self.otherUser.longitude doubleValue]];
    //place.distance = [NSNumber numberWithDouble:[targetLocation distanceFromLocation:currentLocation]];
    DLog(@"%@ is %g meters away", place.title, [place.distance doubleValue]);

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Login"]) {
        [self stopCountdown];
        LoginViewController *vc = (LoginViewController *)segue.destinationViewController;
        vc.managedObjectContext = self.managedObjectContext;
        vc.currentUser = self.currentUser;
        vc.delegate = self;
    } else if ([segue.identifier isEqualToString:@"Matches"]) {
        [self stopCountdown];
        MatchesViewController *vc = (MatchesViewController *)segue.destinationViewController;
        vc.managedObjectContext = self.managedObjectContext;
        vc.currentUser = self.currentUser;
    } else if ([segue.identifier isEqualToString:@"NewMatch"]) {
        [self stopCountdown];
        MatchViewController *vc = (MatchViewController *)segue.destinationViewController;
        vc.currentUser = self.currentUser;
        vc.otherUser = self.otherUser;
        vc.managedObjectContext = self.managedObjectContext;
        vc.delegate = self;
    } else if ([segue.identifier isEqualToString:@"DirectToChat"]) {
        CommentViewController *vc = (CommentViewController *)segue.destinationViewController;
        vc.managedObjectContext = self.managedObjectContext;
        vc.currentUser = self.currentUser; 
        vc.otherUser = self.otherUser;
    } else if ([segue.identifier isEqualToString:@"UserProfile"]) {
        [self stopCountdown];
        UserProfileViewController *vc = (UserProfileViewController *)segue.destinationViewController;
        vc.managedObjectContext = self.managedObjectContext;
        vc.currentUser = self.currentUser;
        vc.otherUser = self.otherUser;
    }
}

- (IBAction)revealMenu:(id)sender
{
    [self stopCountdown];
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)didTapUnlike:(id)sender {
    [self stopCountdown];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Загрузка...", @"Loading...")];
    [RestUser rejectUser:self.otherUser onLoad:^(RestUser *restUser) {
        [SVProgressHUD dismiss];
        [self setupNextHookup];
    } onError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)topDidAppear {
    [((MenuViewController *)self.slidingViewController.underLeftViewController).view endEditing:YES];
    if (self.otherUser) {
        [self startCountdown];
    } else if ([self.currentUser.hookups count] > 0) {
        [self setupNextHookup];
    }
    else {
        [self fetchPossibleHookups];
    }
}

- (void)stopCountdown {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[CircleDownCounter circleViewInView:self.countdownView] stop];
}

- (void)startCountdown {
    ALog(@"Starting countdown");
    [[CircleDownCounter circleViewInView:self.countdownView] startWithSeconds:7];
    [self performSelector:@selector(didTapUnlike:) withObject:self afterDelay:8.0];
}

- (IBAction)didTapLike:(id)sender {
    [self stopCountdown];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Загрузка...", @"Loading...")];
    [RestUser flirtWithUser:self.otherUser onLoad:^(RestUser *restUser) {
        [SVProgressHUD dismiss];
        if (restUser) {
            [self performSegueWithIdentifier:@"NewMatch" sender:self];
            return;
        }
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
            [self noResultsLeft];
            ALog(@"No more results found");
            return;
        }
        if (_noResults)
            [self foundResults];
        
        [self.userImageView setProfilePhotoWithURL:self.otherUser.photoUrl];
        self.locationLabel.text = self.otherUser.fullLocation;
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - LogoutDelegate delegate methods
- (void) didLogout
{
    
    [RestUser resetIdentifiers];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) resetCoreData];
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

- (void)imageLoaded {
    if (self.otherUser) {
        [CircleDownCounter showCircleDownWithSeconds:7.0f
                                              onView:self.countdownView
                                            withSize:kDefaultCounterSize
                                             andType:CircleDownCounterTypeIntegerIncre];
        [self performSelector:@selector(didTapUnlike:) withObject:self afterDelay:8.0];
    }
    
}


#pragma mark - CircleCounterViewDelegate methods
- (void)counterDownFinished:(CircleCounterView *)circleView; {
    ALog(@"countdown finished");
}


- (void)foundResults {
    _noResults = NO;
    self.likeButton.hidden = self.unlikeButton.hidden = NO;
}

- (void)noResultsLeft {
    [self stopCountdown];
    _noResults = YES;
    self.likeButton.hidden = self.unlikeButton.hidden = YES;
    self.nameLabel.text = @"владимир путин, 60 лет";
    self.locationLabel.text = @"Москва, Россия";
    [self.userImageView setWithImage:[UIImage imageNamed:@"sadputin.jpeg"]];
    
}

#pragma mark MatchModalDelegate methods
- (void)userWantsToChat {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self performSegueWithIdentifier:@"DirectToChat" sender:self.otherUser];
    self.otherUser = nil;
}

- (void)userWantsToRate {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self setupNextHookup];
}

- (IBAction)didTapInfo:(id)sender {
    [self performSegueWithIdentifier:@"UserProfile" sender:self];
}
@end
