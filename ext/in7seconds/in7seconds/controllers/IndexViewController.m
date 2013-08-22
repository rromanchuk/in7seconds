//
//  IndexViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "IndexViewController.h"
#import "BaseNavigationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MatchesViewController.h"
#import "CommentViewController.h"
#import "NotificationsViewController.h"
#import "RestHookup.h"
#import "Hookup+REST.h"
#import "Match+REST.h"


typedef enum  {
    LookingForMen = 0,
    LookingForWomen = 1,
    LookingForBoth = 2
} LookingForTypes;

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
@property BOOL *firstLoad;

@end

@implementation IndexViewController

- (void)touchesDidBegin {
    ALog(@"TOUCHES DID BEGIN");
    self.viewDeckController.panningMode = IIViewDeckNoPanning;
}

- (void)touchesDidEnd {
    ALog(@"TOUCHES DID END");
    self.viewDeckController.panningMode = IIViewDeckNavigationBarPanning;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.firstLoad = YES;
    self.hookups = [[NSMutableSet alloc] init];
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    self.currentUser = [User currentUser:self.managedObjectContext];
    _isFetching = NO;
    _numberOfAttempts = 0;
    self.swipeView.delegate = self;
    
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 20;
    self.navigationItem.leftBarButtonItems = @[space, [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"sidebar_button"] target:self action:@selector(revealMenu:)]];
    
    if (self.currentUser.numberOfUnreadNotifications > 0) {
    //if (YES) {
        UIBarButtonItem *notifButton = [UIBarButtonItem notificationBarItemWithImage:[UIImage imageNamed:@"chats_button_with_bubble"] target:self action:@selector(revealChats:) title:[NSString stringWithFormat:@"%d", self.currentUser.numberOfUnreadNotifications]];
        self.navigationItem.rightBarButtonItems = @[space, notifButton];
        
    } else {
        self.navigationItem.rightBarButtonItems = @[space, [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"chats_button"] target:self action:@selector(revealChats:)]];
    }
    
    
    
    self.userImageView.delegate = self;
    self.viewDeckController.delegate = self;
    
    UIImage *notificationsImage = [UIImage imageNamed:@"in7sec_logo"];
    UIButton *notificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [notificationButton addTarget:self action:@selector(didSelectNotifications:) forControlEvents:UIControlEventTouchUpInside];
    
    [notificationButton setBackgroundImage:notificationsImage forState:UIControlStateNormal];
    [notificationButton setFrame:CGRectMake(0, 0, 115, 27)];
    
    self.navigationItem.titleView = notificationButton;
    AppDelegate *sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    sharedAppDelegate.delegate = self;
    
    
    self.userImageView.notifyImageLoad = YES;
    _secondsLeft = 8;
    self.countdownLabel.text = @"7";
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(updateCountdownLabel) userInfo:nil repeats:YES];
    
    if (self.currentUser) {
        [self noResultsLeft];
        [self fetchHookups];
    }
    
    UITapGestureRecognizer *tr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapPhoto:)];
    [self.swipeView addGestureRecognizer:tr];
}

- (void)viewDeckController:(IIViewDeckController*)viewDeckController didShowCenterViewFromSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated {
    ALog(@"did show center view from side");
    [self topDidAppear];
}

//- (void)view

- (void)leftViewWillAppear {
    ALog(@"left view will appear with user");
    //self.viewDeckController.centerhiddenInteractivity = YES;
    [self stopCountdown];
}

- (void)viewWillAppear:(BOOL)animated {
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

- (void)stopCountdown {
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
    } else if ([segue.identifier isEqualToString:@"FeedUserProfileModal"]) {
        [Flurry logEvent:@"View_User_Profile"];
        [self stopCountdown];
        _modalOpen = YES;
        UserProfileViewController *vc = (UserProfileViewController *)segue.destinationViewController;
        vc.managedObjectContext = self.managedObjectContext;
        vc.currentUser = self.currentUser;
        vc.otherUser = self.otherUser;
        vc.delegate = self;
        vc.canRate = YES;
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

- (IBAction)revealChats:(id)sender
{
    if (self.currentUser) {
        [self stopCountdown];
        [self.viewDeckController toggleRightView];
    } else {
        [self.viewDeckController toggleLeftView];
    }
}


- (void)topDidAppear {
    [((MenuViewController *)self.viewDeckController.leftController).view endEditing:YES];
    ALog(@"Top did appear");
    if (self.otherUser) {
        if (_modalOpen == NO) {
            //[self startCountdown];
            ALog(@"resuming countdown");
        }
        ALog(@"modal says was open");
        //[self startCountdown];
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
//        if (self.otherUser.latitude && [self.otherUser.latitude integerValue] > 0) {
//            self.locationLabel.text = [NSString stringWithFormat:@"Примерно в %@ от тебя", [self getDistance]];
//        } else {
//          self.locationLabel.text = self.otherUser.fullLocation;
//        }
        
        self.photosCountLabel.text =  [NSString stringWithFormat:@"%d", [self.otherUser.images count] + 1];
        self.mutualFriendsLabel.text = [NSString stringWithFormat:@"%@", self.otherUser.mutualFriendsNum];
        self.mutualGroupsLabel.text = [NSString stringWithFormat:@"%@", self.otherUser.mutualGroups];
        ALog(@"birthday %@", self.otherUser.birthday);
        if (self.otherUser.birthday && [self.otherUser.yearsOld integerValue] > 0) {
            self.nameLabel.text = [NSString stringWithFormat:@"%@ %@, %@ %@", self.otherUser.lastName, self.otherUser.firstName, self.otherUser.yearsOld, NSLocalizedString(@"лет", @"years old")];
        } else {
            self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.otherUser.lastName, self.otherUser.firstName];
        }
    } else {
        if (_numberOfAttempts < 3 && !_isFetching)
            [self fetchPossibleHookups];

        if (!_isFetching) {
            [self noResultsLeft];
        }
        
    }
}

#pragma mark - Server fetching
- (void)fetchPossibleHookups {
    
    if (!self.currentUser)
        return;
    
    ALog(@"is fetching possible hookups");
    if (_isFetching || _numberOfAttempts > 5)
        return;
    
    _numberOfAttempts++;
    _isFetching = YES;        
    
    [self.managedObjectContext performBlock:^{
        if(_noResults) {
            ALog(@"no results start animating");
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        }
        ALog(@"about to load hookups from rest");
        [RestHookup load:^(NSMutableArray *possibleHookups) {
            //ALog(@"Found %d possible hookups", [possibleHookups count]);
            NSMutableSet *_restHookups = [[NSMutableSet alloc] init];
            for (RestHookup *restHookup in possibleHookups) {
                [_restHookups addObject:[Hookup hookupWithRestHookup:restHookup inManagedObjectContext:self.managedObjectContext]];
                ALog(@"adding user %@", restHookup.firstName);
            }
            [self.currentUser addHookups:_restHookups];
            ALog(@"user has %d", [self.currentUser.hookups count]);

            
            if ([_restHookups count] > 0 )
                _numberOfAttempts = 0;
            
            NSError *error;
            [self.managedObjectContext save:&error];
            
            AppDelegate *sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [sharedAppDelegate writeToDisk];
            [self fetchHookups];
            [SVProgressHUD dismiss];
            _isFetching = NO;
            
        } onError:^(NSError *error) {
            ALog(@"Error fetching hookups %@", error);
            [SVProgressHUD dismiss];
            _isFetching = NO;
        }];
    }];
}

- (void)imageLoaded {
    if (self.otherUser && (self.isViewLoaded && self.view.window) && !_modalOpen) {
        //[self startCountdown];
    }
}

- (void)foundResults {
    ALog(@"foundResults");
    _noResults = NO;
    self.likeButton.hidden = self.unlikeButton.hidden = self.nameLabel.hidden = self.infoButton.hidden = self.countdownLabel.hidden = self.userImageView.hidden = self.infoBanner.hidden = NO;
    self.noResultsLabel.hidden = YES;
}

- (void)noResultsLeft {
    ALog(@"noResultsLeft");
    [self stopCountdown];
    _noResults = YES;
    self.likeButton.hidden = self.unlikeButton.hidden = self.nameLabel.hidden = self.infoButton.hidden = self.countdownLabel.hidden = self.userImageView.hidden = self.infoBanner.hidden = YES;
    self.noResultsLabel.hidden = NO;
}

#pragma mark ApplicationLifecycleDelegate methods
- (void)applicationWillExit {
    [self stopCountdown];
}

- (void)applicationWillWillStart {
    _numberOfAttempts = 0;
    if (self.otherUser) {
        //[self startCountdown];
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
    if (self.currentUser) {
        [self performSegueWithIdentifier:@"Matches" sender:nil];
    } else {
        [self revealMenu:self];
    }
}


- (IBAction)didSelectNotifications:(id)sender {
    //[self performSegueWithIdentifier:@"Notifications" sender:self];
}

- (IBAction)didTapInfo:(id)sender {
    if (self.currentUser) {
        [self performSegueWithIdentifier:@"FeedUserProfileModal" sender:self];
    } else {
        [self revealMenu:nil];
    }
    
}

- (IBAction)didTapPhoto:(id)sender {
    [self didTapInfo:self];
}

- (IBAction)didTapLike:(id)sender {
    if (!self.currentUser) {
        [self revealMenu:self];
        return;
    }
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
    if (!self.currentUser) {
        [self revealMenu:self];
        return;
    }
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
    for (Hookup *hookup in self.currentUser.hookups) {
        ALog(@"hookup's gender is %@, didrate is %@ name %@", hookup.gender, hookup.didRate, hookup.firstName);
    }
    request.predicate = [NSPredicate predicateWithFormat:@"didRate == %@ AND gender IN %@", @NO, lookingFor];
    ALog(@"request predicate is %@", request.predicate);
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


- (void)didUnlikeFromProfile {
    [self didTapUnlike:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didLikeFromProfile {
    [self didTapLike:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
