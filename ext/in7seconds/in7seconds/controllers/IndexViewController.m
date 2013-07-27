//
//  IndexViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "IndexViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MatchesViewController.h"
#import "CommentViewController.h"
#import "UserProfileViewController.h"
#import "NotificationsViewController.h"
#import "RestHookup.h"
#import "Hookup+REST.h"
#import "Match+REST.h"


@interface IndexViewController () {
    NSInteger _numberOfAttempts;
    BOOL _noResults;
    BOOL _modalOpen;
    BOOL _isFetching;
    NSInteger _secondsLeft;
}

@property (strong, nonatomic) Hookup *otherUser;
@property (strong, nonatomic) NSMutableSet *hookups;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation IndexViewController

- (void)touchesDidBegin {
    ALog(@"TOUCHES DID BEGIN");
    //self.viewDeckController.delegateMode
    //[self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
    self.viewDeckController.panningMode = IIViewDeckNoPanning;
}

- (void)touchesDidEnd {
    ALog(@"TOUCHES DID END");
    //[self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    self.viewDeckController.panningMode = IIViewDeckPanningViewPanning;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.swipeView.delegate = self;
    _isFetching = NO;
    [self noResultsLeft];
    
    self.hookups = [[NSMutableSet alloc] init];
    
    [self fetchHookups];
        
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"settings_icon"] target:self action:@selector(revealMenu:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"chat_icon"] target:self action:@selector(didTapMatches:)];
    

    self.userImageView.delegate = self;
    _numberOfAttempts = 0;
    //self.viewDeckController ad
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topDidAppear) name:@"ECSlidingViewTopDidReset" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftViewWillAppear) name:@"ECSlidingViewUnderLeftWillAppear" object:nil];
    
    ((MenuViewController *)self.viewDeckController.leftController).settingsDelegate = self;
    
    UIImage *notificationsImage = [UIImage imageNamed:@"navigation-logo"];
    UIButton *notificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [notificationButton addTarget:self action:@selector(didSelectNotifications:) forControlEvents:UIControlEventTouchUpInside];
    
    [notificationButton setBackgroundImage:notificationsImage forState:UIControlStateNormal];
    [notificationButton setFrame:CGRectMake(0, 0, 125, 27)];

    self.navigationItem.titleView = notificationButton;
    AppDelegate *sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    sharedAppDelegate.delegate = self;
    
    
    self.userImageView.notifyImageLoad = YES;
    [self fetchHookups];
    
    self.countdownLabel.text = @"7";
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(updateCountdownLabel) userInfo:nil repeats:YES];
}

- (void)viewDeckController:(IIViewDeckController*)viewDeckController didShowCenterViewFromSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated {
    
}

- (void)leftViewWillAppear {
    ALog(@"left view will appear with user");
    [self stopCountdown];
}

- (void)viewWillAppear:(BOOL)animated {
    //[self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _modalOpen = NO;
    if (self.currentUser) {
        [self topDidAppear];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopCountdown];
}

- (void)viewDidUnload {
    [self setActivityIndicator:nil];
    [self setCountdownLabel:nil];
    [self setSwipeView:nil];
    [super viewDidUnload];
}


- (void)startCountdown {
    ALog(@"starting countdown");
    _secondsLeft = 8;
    if (self.timer.isValid) {
        ALog(@"countdown is running");
    } else {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(updateCountdownLabel) userInfo:nil repeats:YES];
        ALog(@"countdown is not running");
    }
}

-(void)stopCountdown {
    ALog(@"stopping countdown");
    [_timer invalidate];
}


- (void)updateCountdownLabel {
    _secondsLeft--;
    self.countdownLabel.text = [NSString stringWithFormat:@"%d", _secondsLeft];
    if (_secondsLeft == 0) {
        [self didTapUnlike:self];
        [self.timer invalidate];
    }
}

- (NSString *)getDistance {
    CLLocation *targetLocation = [[CLLocation alloc] initWithLatitude: [self.currentUser.latitude doubleValue] longitude:[self.currentUser.longitude doubleValue]];
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:[self.otherUser.latitude doubleValue] longitude:[self.otherUser.longitude doubleValue]];
    int distance = [@([targetLocation distanceFromLocation:currentLocation]) integerValue];
    DLog(@"%@ is %g meters away", place.title, [place.distance doubleValue]);
    NSString *measurement;
    if (distance > 1000) {
        distance = distance / 1000;
        measurement = NSLocalizedString(@"км", nil);
    } else {
        measurement = NSLocalizedString(@"м", nil);
    }
    
    return [NSString stringWithFormat:@"%d%@", distance, measurement];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Matches"]) {
        [self stopCountdown];
        _modalOpen = YES;
        MatchesViewController *vc = (MatchesViewController *)segue.destinationViewController;
        vc.managedObjectContext = self.managedObjectContext;
        vc.currentUser = self.currentUser;
    } else if ([segue.identifier isEqualToString:@"NewMatch"]) {
        [Flurry logEvent:@"Found_New_Match"];
        _modalOpen = YES;
        [self stopCountdown];
        MatchViewController *vc = (MatchViewController *)segue.destinationViewController;
        vc.currentUser = self.currentUser;
        vc.otherUser = (Match *)sender;
        vc.managedObjectContext = self.managedObjectContext;
        vc.delegate = self;
    } else if ([segue.identifier isEqualToString:@"DirectToChat"]) {
        [self stopCountdown];
        _modalOpen = YES;
        CommentViewController *vc = (CommentViewController *)segue.destinationViewController;
        vc.managedObjectContext = self.managedObjectContext;
        vc.currentUser = self.currentUser; 
        vc.otherUser = (Match *)sender;
        ALog(@"set other user as %@", vc.otherUser);
    } else if ([segue.identifier isEqualToString:@"UserProfile"]) {
        [Flurry logEvent:@"View_User_Profile"];
        [self stopCountdown];
        _modalOpen = YES;
        UserProfileViewController *vc = (UserProfileViewController *)segue.destinationViewController;
        vc.managedObjectContext = self.managedObjectContext;
        vc.currentUser = self.currentUser;
        vc.otherUser = self.otherUser;
    } else if ([segue.identifier isEqualToString:@"Notifications"]) {
        _modalOpen = YES;
        [self stopCountdown];
        NotificationsViewController *vc = (NotificationsViewController *)segue.destinationViewController;
        vc.managedObjectContext = self.managedObjectContext;
        vc.currentUser = self.currentUser;
    }
}

- (IBAction)revealMenu:(id)sender
{
    [self stopCountdown];
    [self.viewDeckController toggleLeftView];
}

- (void)topDidAppear {
    [((MenuViewController *)self.viewDeckController.leftController).view endEditing:YES];
    ALog(@"Top did appear");
    if (self.otherUser) {
        if (_modalOpen == NO) {
            [self startCountdown];
            ALog(@"resuming countdown");
        }
        ALog(@"modal says was open");
        [self startCountdown];
    } else if ([self.hookups count] > 0) {
        ALog(@"setting up next hookup")
        [self setupNextHookup];
    }
    else if(!_isFetching) {
        ALog(@"fetching possible hookups from top did appear");
        [self fetchPossibleHookups];
    } else {
        ALog(@"Doing nothing");
        [self fetchPossibleHookups];
    }    
}

- (void)setupNextHookup {
    if ([self.hookups count] < 10 && !_isFetching) {
        [self fetchPossibleHookups];
    }
    
    self.otherUser = nil;    
    if (self.currentUser && [self.hookups count] > 0) {
        self.otherUser = [self.hookups anyObject];
        //ALog(@"other user is setup %@", self.otherUser);
        //ALog(@"hookups are %@", self.hookups);
        [self foundResults];
        
        [self.userImageView setProfilePhotoWithURL:self.otherUser.photoUrl];
        if (self.otherUser.latitude && [self.otherUser.latitude integerValue] > 0) {
            self.locationLabel.text = [NSString stringWithFormat:@"Примерно в %@ от тебя", [self getDistance]];
        } else {
          self.locationLabel.text = self.otherUser.fullLocation;
        }
        
        self.mutualFriendsLabel.text = [NSString stringWithFormat:@"%@ общих друзей", self.otherUser.mutualFriendsNum];
        self.mutualGroupsLabel.text = [NSString stringWithFormat:@"%@ общих интересов", self.otherUser.mutualGroups];
        ALog(@"birthday %@", self.otherUser.birthday);
        if (self.otherUser.birthday && [self.otherUser.yearsOld integerValue] > 0) {
            self.nameLabel.text = [NSString stringWithFormat:@"%@ %@, %@ %@", self.otherUser.lastName, self.otherUser.firstName, self.otherUser.yearsOld, NSLocalizedString(@"лет", @"years old")];
        } else {
            self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.otherUser.lastName, self.otherUser.firstName];
        }
    } else {
        if (_numberOfAttempts < 3) 
            [self fetchPossibleHookups];

        [self noResultsLeft];
    }
}

#pragma mark - Server fetching
- (void)fetchPossibleHookups {
    ALog(@"is fetching possible hookups");
    if (_isFetching || _numberOfAttempts > 5)
        return;
    
    _numberOfAttempts++;
    _isFetching = YES;
    [self.managedObjectContext performBlock:^{
        if(_noResults) {
            ALog(@"no results start animating");
            [self.activityIndicator startAnimating];
        }
        ALog(@"about to load hookups from rest");
        [RestHookup load:^(NSMutableArray *possibleHookups) {
            //ALog(@"Found %d possible hookups", [possibleHookups count]);
            NSMutableSet *_restHookups = [[NSMutableSet alloc] init];
            for (RestHookup *restHookup in possibleHookups) {
                [_restHookups addObject:[Hookup hookupWithRestHookup:restHookup inManagedObjectContext:self.managedObjectContext]];
            }
            [self.currentUser addHookups:_restHookups];
            
            if ([_restHookups count] > 0 )
                _numberOfAttempts = 0;
            
            NSError *error;
            [self.managedObjectContext save:&error];
            
            AppDelegate *sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [sharedAppDelegate writeToDisk];
            [self fetchHookups];
            [self.activityIndicator stopAnimating];
            _isFetching = NO;
            
        } onError:^(NSError *error) {
            ALog(@"Error fetching hookups %@", error);
            [self.activityIndicator stopAnimating];
            _isFetching = NO;
        }];
    }];
}

- (void)imageLoaded {
    if (self.otherUser && (self.isViewLoaded && self.view.window) && !_modalOpen) {
        [self startCountdown];
    }
}

- (void)foundResults {
    ALog(@"foundResults");
    _noResults = NO;
    self.likeButton.hidden = self.unlikeButton.hidden = self.nameLabel.hidden = self.locationLabel.hidden = self.countdownLabel.hidden = self.userImageView.hidden = self.infoBanner.hidden = NO;
    self.noResultsLabel.hidden = YES;
}

- (void)noResultsLeft {
    ALog(@"noResultsLeft");
    [self stopCountdown];
    _noResults = YES;
    self.likeButton.hidden = self.unlikeButton.hidden = self.nameLabel.hidden = self.locationLabel.hidden = self.countdownLabel.hidden = self.userImageView.hidden = self.infoBanner.hidden = YES;
    self.noResultsLabel.hidden = NO;
}

#pragma mark ApplicationLifecycleDelegate methods
- (void)applicationWillExit {
    [self stopCountdown];
}

- (void)applicationWillWillStart {
    _numberOfAttempts = 0;
    if (self.otherUser) {
        [self startCountdown];
    }
}


#pragma mark MatchModalDelegate methods
- (void)userWantsToChat:(Match *)matchUser {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self performSegueWithIdentifier:@"DirectToChat" sender:matchUser];
    self.otherUser = nil;
}

- (void)userWantsToRate {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self setupNextHookup];
}


#pragma mark - UserSettingsDelegate
- (void)didChangeFilters {
    ALog(@"in change filters");
    self.currentUser = [User currentUser:self.managedObjectContext];
    AppDelegate *sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    sharedAppDelegate.currentUser = self.currentUser;
    
    self.otherUser = nil;
    self.hookups = [[NSMutableSet alloc] init];
    [self fetchPossibleHookups];
    [self fetchHookups];
}

#pragma mark - user events

- (IBAction)didTapMatches:(id)sender {
    [self performSegueWithIdentifier:@"Matches" sender:nil];
}


- (IBAction)didSelectNotifications:(id)sender {
    [self performSegueWithIdentifier:@"Notifications" sender:self];
}

- (IBAction)didTapInfo:(id)sender {
    [self performSegueWithIdentifier:@"UserProfile" sender:self];
}

- (IBAction)didTapLike:(id)sender {
    [Flurry logEvent:@"Like_Tapped"];
    [self stopCountdown];
    if (!self.otherUser) {
        [self setupNextHookup];
        return;
    }
    Hookup *otherUser = self.otherUser;
    [self.hookups removeObject:self.otherUser];
    self.otherUser.didRate = @YES;
    [self saveContext];
    [self setupNextHookup];
    [RestUser flirtWithUser:otherUser onLoad:^(RestMatch *restMatch) {
        if (restMatch) {
            Match *match = [Match matchWithRestMatch:restMatch inManagedObjectContext:self.managedObjectContext];
            [self.currentUser addMatchesObject:match];
            [self performSegueWithIdentifier:@"NewMatch" sender:match];
            return;
        }
    } onError:^(NSError *error) {
        
    }];
}

- (IBAction)didTapUnlike:(id)sender {
    [Flurry logEvent:@"Unlike_Tapped"];
    [self stopCountdown];
    if (!self.otherUser) {
        [self setupNextHookup];
        return;
    }
    Hookup *otherUser = self.otherUser;
    [self.hookups removeObject:self.otherUser];
    self.otherUser.didRate = @YES;
    [self saveContext];
    [self setupNextHookup];
    [RestUser rejectUser:otherUser onLoad:^(BOOL success) {
        
    } onError:^(NSError *error) {
    }];
}

#pragma mark - setup hookups
- (void)fetchHookups {
    NSArray *lookingFor;
    if ([self.currentUser.lookingForGender integerValue] == LookingForBoth) {
        lookingFor = @[@(LookingForMen), @(LookingForWomen)];
    } else if ([self.currentUser.lookingForGender integerValue] == LookingForMen) {
        lookingFor = @[@(LookingForMen)];
    } else {
        lookingFor = @[@(LookingForWomen)];
    }
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hookup"];
    request.predicate = [NSPredicate predicateWithFormat:@"user == %@ AND didRate == %@ AND gender IN %@", self.currentUser, @NO, lookingFor];
    //request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO]];
    NSError *error;
    NSArray *hookups = [self.managedObjectContext executeFetchRequest:request error:&error];
    ALog(@"Found hookups %@", hookups);
    [self.hookups addObjectsFromArray:hookups];
    for (Hookup *hookup in self.hookups) {
        ALog(@"User %@ gender %@", hookup.fullName, hookup.gender );
    }
    if (!self.otherUser) {
        [self setupNextHookup];
    }
}

#pragma mark - Coredata saving
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
