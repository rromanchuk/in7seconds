//
//  IndexViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "IndexViewController.h"
#import "AppDelegate.h"
@interface IndexViewController ()
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
    ((MenuViewController *)self.slidingViewController.underLeftViewController).delegate = self;
    self.otherUser = [self.currentUser.possibleHookups anyObject];
    [self.userImageView setImageWithURL:[NSURL URLWithString:self.otherUser.photoUrl]];
	// Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.currentUser) {
        [self performSegueWithIdentifier:@"Login" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Login"]) {
        LoginViewController *vc = (LoginViewController *)segue.destinationViewController;
        vc.managedObjectContext = self.managedObjectContext;
        vc.currentUser = self.currentUser;
        vc.delegate = self;
    }
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)didTapUnlike:(id)sender {
    
}

- (IBAction)didTapLike:(id)sender {
    
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
    self.currentUser = nil;
    [[Vkontakte sharedInstance] logout];
    //[[UAPush shared] setAlias:nil];
    //[[UAPush shared] updateRegistration];
    
    //[FBSession.activeSession closeAndClearTokenInformation];
    //[self dismissModalViewControllerAnimated:YES];
    [self performSegueWithIdentifier:@"Login" sender:self];
}

@end
