//
//  InitialViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "InitialViewController.h"
#import "NavigationTopViewController.h"
#import "IndexViewController.h"
@interface InitialViewController ()

@end

@implementation InitialViewController

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
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
    }

	// Do any additional setup after loading the view.
    ALog(@"managed object is %@", self.managedObjectContext);
    self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationTop"];
    NavigationTopViewController *nc = ((NavigationTopViewController *)self.topViewController);
    ((IndexViewController *)nc.topViewController).managedObjectContext = self.managedObjectContext;
    ((IndexViewController *)nc.topViewController).currentUser = self.currentUser;
    
    self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    ((MenuViewController *)self.slidingViewController.underLeftViewController).delegate = ((IndexViewController *)nc.topViewController);
}



@end
