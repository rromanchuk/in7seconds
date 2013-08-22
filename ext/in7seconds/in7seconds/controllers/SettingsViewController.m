//
//  SettingsViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 8/11/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "SettingsViewController.h"

#import "Location.h"
#import "AppDelegate.h"
#import "RestUser.h"
#import "Vkontakte.h"

#import <ViewDeck/IIViewDeckController.h>


@interface SettingsViewController ()
@property BOOL isFetching;
@property BOOL filtersChanged;
@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewDeckController.panningMode = IIViewDeckNoPanning;
  
    
    self.ageSlider.minimumValue = 15;
    self.ageSlider.maximumValue = 60;
    
    self.ageSlider.lowerValue = 16;
    self.ageSlider.upperValue = 30;
    
    self.ageSlider.minimumRange = 10;

    
    self.currentUser = [User currentUser:self.managedObjectContext];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 20;
    self.navigationItem.leftBarButtonItems = @[space, [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"sidebar_button"] target:self action:@selector(revealMenu:)]];
    

    
    if ([self.currentUser.lookingForGender integerValue] == LookingForBoth) {
        self.lookingForMenSwitch.selected = YES;
        self.lookingForWomenSwitch.selected = YES;
    } else if ([self.currentUser.lookingForGender integerValue] == LookingForMen) {
        self.lookingForMenSwitch.selected = YES;
        self.lookingForWomenSwitch.selected = NO;
    } else {
        self.lookingForWomenSwitch.selected = YES;
        self.lookingForWomenSwitch.selected = NO;
    }

    self.notificationEmailSwitch.on = [self.currentUser.emailOptIn boolValue];
    self.notificationPushSwitch.on = [self.currentUser.pushOptIn boolValue];
    
}



- (void)updateSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
    lowerCenter.x = (self.ageSlider.lowerCenter.x + self.ageSlider.frame.origin.x);
    lowerCenter.y = (self.ageSlider.center.y - 30.0f);
    self.lowerLabel.center = lowerCenter;
    self.lowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.ageSlider.lowerValue];
    
    CGPoint upperCenter;
    upperCenter.x = (self.ageSlider.upperCenter.x + self.ageSlider.frame.origin.x);
    upperCenter.y = (self.ageSlider.center.y - 30.0f);
    self.upperLabel.center = upperCenter;
    self.upperLabel.text = [NSString stringWithFormat:@"%d", (int)self.ageSlider.upperValue];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SSSettingsSectionTypeGender) {
        
    } else if (indexPath.section == SSSettingsSectionTypeDistance) {
        
    } else if (indexPath.section == SSSettingsSectionTypeAge) {
        
    } else if (indexPath.section == SSSettingsSectionTypePush) {
        
    } else if (indexPath.section == SSSettingsSectionTypeLogout) {
        [self didLogout];
    }
}

- (IBAction)revealMenu:(id)sender
{
    [self.viewDeckController toggleLeftView];
}

- (void)update {
    [self.managedObjectContext performBlock:^{
        _isFetching  = YES;
        [RestUser update:self.currentUser onLoad:^(RestUser *restUser) {
            [SVProgressHUD dismiss];
            self.currentUser = [User userWithRestUser:restUser inManagedObjectContext:self.managedObjectContext];
            
            NSError *error;
            [self.managedObjectContext save:&error];
            
            AppDelegate *sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [sharedAppDelegate writeToDisk];
            
            if (_filtersChanged) {
                _filtersChanged = NO;
            }
            _isFetching = NO;
        } onError:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            _isFetching = NO;
        }];
    }];
    
}


- (IBAction)didTapLogout:(id)sender {
    //ALog(@"did tap logout sending to delegate %@", self.delegate);
    [self didLogout];
}

- (void)didLogout
{
    ALog(@"in logout");
    [[Location sharedLocation] stopUpdatingLocation:@"logout"];
    [[[RestClient sharedClient] operationQueue] cancelAllOperations];
    [RestUser resetIdentifiers];
    [[Vkontakte sharedInstance] logout];
    
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) resetCoreData];
    AppDelegate *sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [sharedAppDelegate resetWindowToInitialView];
    
    
}

- (IBAction)lookingForChanged:(id)sender {
    if ((self.lookingForMenSwitch.on && self.lookingForWomenSwitch.on) || (!self.lookingForMenSwitch.on && !self.lookingForWomenSwitch.on)) {
        self.currentUser.lookingForGender = @(LookingForBoth);
    } else if (self.lookingForMenSwitch.on) {
        self.currentUser.lookingForGender = @(LookingForMen);
    } else if (self.lookingForWomenSwitch.on) {
        self.currentUser.lookingForGender = @(LookingForWomen);
    }
    
    [self update];
}

- (IBAction)notificationSettingsChanged:(id)sender {
    _filtersChanged = YES;
    UISwitch *mySwitch = (UISwitch *)sender;
    if (mySwitch == self.notificationEmailSwitch) {
        self.currentUser.emailOptIn = @(self.notificationEmailSwitch.on);
    } else {
        self.currentUser.pushOptIn = @(self.notificationPushSwitch.on);
    }
    [self update];
}

- (IBAction)labelSliderChanged:(id)sender {
    [self updateSliderLabels];
}

@end
