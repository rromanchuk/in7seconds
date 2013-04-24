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
#import "RestHookup.h"
#import "Hookup+REST.h"
@interface IndexViewController () {
    NSInteger _numberOfAttempts;
    BOOL _noResults;
    BOOL _modalOpen;
}

@property (strong, nonatomic) JDFlipNumberView *countdown;
@property (strong, nonatomic) Hookup *otherUser;
@end

@implementation IndexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self noResultsLeft];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"settings_icon"] target:self action:@selector(revealMenu:)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"chat_icon"] target:self action:@selector(didTapMatches:)];
    

    self.userImageView.delegate = self;
    _numberOfAttempts = 0;
   	// Do any additional setup after loading the view.
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topDidAppear) name:@"ECSlidingViewTopDidReset" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftViewWillAppear) name:@"ECSlidingViewUnderLeftWillAppear" object:nil];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation-logo"]];
    AppDelegate *sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    sharedAppDelegate.delegate = self;
    
    self.countdown = [[JDFlipNumberView alloc] initWithDigitCount:1];
    CGRect frame = CGRectOffset(self.likeButton.frame, 100, 0);
    self.countdown.frame = frame;
    [self.view addSubview:self.countdown];
    self.countdown.delegate = self;
    self.userImageView.notifyImageLoad = YES;
}

- (void)leftViewWillAppear {
    ALog(@"left fiew will appear with user");
    [self stopCountdown];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _modalOpen = NO;

    if (self.currentUser) {
        [self topDidAppear];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopCountdown];
}


- (NSString *)getDistance {
    CLLocation *targetLocation = [[CLLocation alloc] initWithLatitude: [self.currentUser.latitude doubleValue] longitude:[self.currentUser.longitude doubleValue]];
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:[self.otherUser.latitude doubleValue] longitude:[self.otherUser.longitude doubleValue]];
    int distance = [[NSNumber numberWithDouble:[targetLocation distanceFromLocation:currentLocation]] integerValue];
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
        MatchesViewController *vc = (MatchesViewController *)segue.destinationViewController;
        vc.managedObjectContext = self.managedObjectContext;
        vc.currentUser = self.currentUser;
    } else if ([segue.identifier isEqualToString:@"NewMatch"]) {
        [Flurry logEvent:@"Found_New_Match"];
        [self stopCountdown];
        MatchViewController *vc = (MatchViewController *)segue.destinationViewController;
        vc.currentUser = self.currentUser;
        vc.otherUser = (User *)sender;
        vc.managedObjectContext = self.managedObjectContext;
        vc.delegate = self;
    } else if ([segue.identifier isEqualToString:@"DirectToChat"]) {
        [self stopCountdown];
        CommentViewController *vc = (CommentViewController *)segue.destinationViewController;
        vc.managedObjectContext = self.managedObjectContext;
        vc.currentUser = self.currentUser; 
        vc.otherUser = self.otherUser;
    } else if ([segue.identifier isEqualToString:@"UserProfile"]) {
        [Flurry logEvent:@"View_User_Profile"];
        [self stopCountdown];
        _modalOpen = YES;
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



- (void)topDidAppear {
    [((MenuViewController *)self.slidingViewController.underLeftViewController).view endEditing:YES];
    
    if (self.otherUser) {
        if (_modalOpen == NO) {
            [self startCountdown];
        }
    } else if ([self.currentUser.hookups count] > 0) {
        [self setupNextHookup];
    }
    else {
        [self fetchPossibleHookups];
    }
}

- (void)stopCountdown {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.countdown stopAnimation];
}

- (void)startCountdown {
    ALog(@"Starting countdown");
    self.countdown.value = 7;
    [self performSelector:@selector(startCountdownAnimation) withObject:self afterDelay:1.0];
}

- (void)startCountdownAnimation {
    [self.countdown animateDownWithTimeInterval: 1.0];
}

- (IBAction)didTapLike:(id)sender {
    [Flurry logEvent:@"Like_Tapped"];
    [self stopCountdown];
    if (!self.otherUser) {
        [self setupNextHookup];
        return;
    }
    Hookup *otherUser = self.otherUser;
    [self.currentUser removeHookupsObject:self.otherUser];
    [self saveContext];
    [self setupNextHookup];
    [RestUser flirtWithUser:otherUser onLoad:^(RestUser *restUser) {
        if (restUser) {
            [self performSegueWithIdentifier:@"NewMatch" sender:otherUser];
            return;
        }
    } onError:^(NSError *error) {
        [self setupNextHookup];
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
    [self.currentUser removeHookupsObject:self.otherUser];
    [self saveContext];
    [self setupNextHookup];
    [RestUser rejectUser:otherUser onLoad:^(BOOL success) {
        
    } onError:^(NSError *error) {
    }];
}

- (IBAction)didTapMatches:(id)sender {
    [self performSegueWithIdentifier:@"Matches" sender:nil];
}

- (void)setupNextHookup {
    self.otherUser = nil;    
    if (self.currentUser && self.currentUser.hookups) {
        [self foundResults];
        self.otherUser = [self.currentUser.hookups anyObject];
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
        
        //ALog(@"latitude is %f", self.otherUser.latitude);
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
        
    }
}

- (void)fetchPossibleHookups {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Загрузка...", @"Loading...") maskType:SVProgressHUDMaskTypeGradient];
    _numberOfAttempts++;
    
    [RestHookup load:^(NSMutableArray *possibleHookups) {
        NSMutableSet *_restHookups;
        for (RestHookup *restHookup in possibleHookups) {
            [_restHookups addObject:[Hookup hookupWithRestHookup:restHookup inManagedObjectContext:self.managedObjectContext]];
        }
        [self.currentUser addHookups:_restHookups];
        [self saveContext];
        [self setupNextHookup];
        [SVProgressHUD dismiss];
    } onError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
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
    if (self.otherUser && (self.isViewLoaded && self.view.window)) {
        [self startCountdown];
    }
    
}

- (void)foundResults {
    _noResults = NO;
    self.likeButton.hidden = self.unlikeButton.hidden = self.nameLabel.hidden = self.locationLabel.hidden = self.countdown.hidden = self.userImageView.hidden = self.infoBanner.hidden = NO;
    self.noResultsLabel.hidden = YES;
}

- (void)noResultsLeft {
    [self stopCountdown];
    _noResults = YES;
    self.likeButton.hidden = self.unlikeButton.hidden = self.nameLabel.hidden = self.locationLabel.hidden = self.countdown.hidden = self.userImageView.hidden = self.infoBanner.hidden  = YES;
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


#pragma mark - JDFlipNumberViewDelegate
- (void)flipNumberView:(JDFlipNumberView *)flipNumberView didChangeValueAnimated:(BOOL)animated {
    ALog(@"delegate callback %d", flipNumberView.value);
    if (flipNumberView.value == 0) {
        [self didTapUnlike:self];
    }
    
}

@end
