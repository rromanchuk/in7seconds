//
//  MenuViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "MenuViewController.h"
#import "RestUser.h"
#import "AppDelegate.h"
#import "User+REST.h"
#import "IndexViewController.h"
@interface MenuViewController () {
    BOOL _filtersChanged;
}
@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.logoutButton setTitle:NSLocalizedString(@"Выйти", @"logout button text") forState:UIControlStateNormal];
    
    [self.slidingViewController setAnchorRightRevealAmount:295.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    self.view.backgroundColor = [UIColor darkBackgroundColor];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    self.versionLabel.text = [NSString stringWithFormat:@"Version %@ (%@)", majorVersion, minorVersion];
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftViewWillAppear) name:@"ECSlidingViewUnderLeftWillAppear" object:nil];
    AppDelegate *sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = sharedAppDelegate.managedObjectContext;
    
    //[self.genderSegmentControl setFrame:CGRectMake(self.genderSegmentControl.frame.origin.x, self.genderSegmentControl.frame.origin.y, 249, 44)];
    UIImage *segmentSelected = [[UIImage imageNamed:@"selected_control"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 8, 9, 8) resizingMode:UIImageResizingModeStretch];
    UIImage *segmentUnselected = [[UIImage imageNamed:@"unselected_control"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 8, 9, 8) resizingMode:UIImageResizingModeStretch];
    
    UIImage *segmentSelectedUnselected = [[UIImage imageNamed:@"center_left_select"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 0, 5, 0)];
    UIImage *segUnselectedSelected = [[UIImage imageNamed:@"center_right_select"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 0, 5, 0)];
    UIImage *segmentUnselectedUnselected = [[UIImage imageNamed:@"center_noselect"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 0, 5, 0)];
    [self.genderSegmentControl setBackgroundImage:segmentUnselected forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.genderSegmentControl setBackgroundImage:segmentSelected forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
//    [[UISegmentedControl appearance] setBackgroundImage:segmentUnselected forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [[UISegmentedControl appearance] setBackgroundImage:segmentSelected forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setDividerImage:segmentUnselectedUnselected forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:segmentSelectedUnselected forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:segUnselectedSelected forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
//    [self.genderSegmentControl setBackgroundImage:[[UIImage imageNamed:@"segment"] resizableImageWithCapInsets:UIEdgeInsetsMake(9, 0, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [self.genderSegmentControl setBackgroundImage:[UIImage imageNamed:@"segment-selected"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
}


- (void)leftViewWillAppear {
    ALog(@"left view will appear with user %@ and managedObject %@", self.user, self.managedObjectContext);
    if (!self.user && [RestUser currentUserToken] && self.managedObjectContext) {
        [self fetch];
    }
}


- (void)setupProfile {
    ALog(@"setting up profile for %@", self.user);
    [self.profileImage setProfilePhotoWithURL:self.user.photoUrl];
    self.nameTextField.text = self.user.fullName;
    self.emailTextField.text = self.user.email;
    // Do any additional setup after loading the view.
    if ([self.user.lookingForGender integerValue] == LookingForBoth) {
        self.lookingForMen.selected = YES;
        self.lookingForWomen.selected = YES;
    } else if ([self.user.lookingForGender integerValue] == LookingForMen) {
        self.lookingForMen.selected = YES;
    } else {
        self.lookingForWomen.selected = YES;
    }
    self.genderSegmentControl.selectedSegmentIndex = [self.user.gender integerValue];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapLogout:(id)sender {
    [self.delegate didLogout];
}

- (IBAction)didTapWomen:(id)sender {
    _filtersChanged = YES;
    self.lookingForWomen.selected = !self.lookingForWomen.selected;
    [self setLookingFor];
    [self update];
}


- (IBAction)didTapMen:(id)sender {
    _filtersChanged = YES;
    self.lookingForMen.selected = !self.lookingForMen.selected;
    [self setLookingFor];
    [self update];
}

- (void)setLookingFor {
    if ((self.lookingForMen.selected && self.lookingForWomen.selected) || (!self.lookingForMen.selected && !self.lookingForWomen.selected)) {
        self.user.lookingForGender = [NSNumber numberWithInteger:LookingForBoth];
    } else if (self.lookingForWomen.selected) {
        self.user.lookingForGender = [NSNumber numberWithInteger:LookingForWomen];
    } else {
        self.user.lookingForGender = [NSNumber numberWithInteger:LookingForMen];
    }    
}

- (void)fetch {
    ALog(@"in fetch user for menu controller");
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Загрузка...", @"Loading...")];
    [RestUser reload:^(RestUser *restUser) {
        User *user = [User userWithRestUser:restUser inManagedObjectContext:self.managedObjectContext];
        ALog(@"returning from coredate helper with user %@", user);
        [self saveContext];
        self.user = user;
        [self setupProfile];
        [SVProgressHUD dismiss];
    } onError:^(NSError *error) {
        ALog(@"got error %@", error);
        [SVProgressHUD dismiss];
    }];
}
- (void)update {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Загрузка...", @"Loading...")];
    [RestUser update:self.user onLoad:^(RestUser *restUser) {
        [SVProgressHUD dismiss];
        self.user = [User userWithRestUser:restUser inManagedObjectContext:self.managedObjectContext];
        [self saveContext];
        if (_filtersChanged) {
            [self.delegate didChangeFilters];
            _filtersChanged = NO;
        }
    } onError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (IBAction)genderChanged:(id)sender {
    self.user.gender = [NSNumber numberWithInteger:self.genderSegmentControl.selectedSegmentIndex];
    [self update];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.user.email = self.emailTextField.text;
    NSArray *chunks = [self.nameTextField.text componentsSeparatedByString: @" "];
    if ([chunks count] == 2) {
        self.user.lastName = chunks[1];
        self.user.firstName = chunks[0];
    }
    [textField resignFirstResponder];
    [self update];
    return YES;
}

@end
