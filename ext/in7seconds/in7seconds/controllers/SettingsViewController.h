//
//  SettingsViewController.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 8/11/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//
#import "User+REST.h"

typedef enum  {
    SSSettingsSectionTypeGender = 0,
    SSSettingsSectionTypeDistance = 1,
    SSSettingsSectionTypeAge = 2,
    SSSettingsSectionTypePush = 3,
    SSSettingsSectionTypeLogout = 4
} SSSettingsSectionType;


typedef enum  {
    LookingForMen = 0,
    LookingForWomen = 1,
    LookingForBoth = 2
} LookingForTypes;

@interface SettingsViewController : UITableViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) User *currentUser;

@property (weak, nonatomic) IBOutlet UISwitch *lookingForMenSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *lookingForWomenSwitch;
@property (weak, nonatomic) IBOutlet UISlider *distanceSlider;

@property (weak, nonatomic) IBOutlet UISlider *ageSlider;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

- (IBAction)lookingForMenChanged:(id)sender;
- (IBAction)lookingForWomenChanged:(id)sender;
- (IBAction)notificationSettingsChanged:(id)sender;

//@property (weak, nonatomic) id <LogoutDelegate> delegate;
//@property (weak, nonatomic) id <UserSettingsDelegate> settingsDelegate;


@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UISwitch *notificationEmailSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *notificationPushSwitch;

@end
