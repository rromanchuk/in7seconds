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

@interface MenuViewController ()

@end

@implementation MenuViewController

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
    [self.logoutButton setTitle:NSLocalizedString(@"Выйти", @"logout button text") forState:UIControlStateNormal];
    
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    self.view.backgroundColor = [UIColor darkBackgroundColor];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    self.versionLabel.text = [NSString stringWithFormat:@"Version %@ (%@)", majorVersion, minorVersion];
	// Do any additional setup after loading the view.
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
    self.lookingForWomen.selected = !self.lookingForWomen.selected;
    [self setLookingFor];
}


- (IBAction)didTapMen:(id)sender {
    self.lookingForMen.selected = !self.lookingForMen.selected;
    [self setLookingFor];
}

- (void)setLookingFor {
    if (self.lookingForMen.selected && self.lookingForMen) {
        self.currentUser.lookingForGender = [NSNumber numberWithInteger:LookingForBoth];
    } else if (self.lookingForWomen) {
        self.currentUser.lookingForGender = [NSNumber numberWithInteger:LookingForWomen];
    } else {
        self.currentUser.lookingForGender = [NSNumber numberWithInteger:LookingForMen];
    }
    
    [self update];
}

- (void)update {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Загрузка...", @"Loading...")];
    [RestUser update:self.currentUser onLoad:^(RestUser *restUser) {
        [SVProgressHUD dismiss];
        self.currentUser = [User userWithRestUser:restUser inManagedObjectContext:self.managedObjectContext];
        [self saveContext];
    } onError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (IBAction)genderChanged:(id)sender {
    self.currentUser.gender = [NSNumber numberWithInteger:self.genderSegmentControl.selectedSegmentIndex];
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
@end
