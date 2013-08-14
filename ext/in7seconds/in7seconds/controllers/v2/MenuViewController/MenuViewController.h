//
//  MenuViewController.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 8/7/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//


#import "User+REST.h"
#import "ProfilePhotoView.h"
@interface MenuViewController : UITableViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet ProfilePhotoView *profilePhoto;
@property (strong, nonatomic) User *currentUser;
@end



#import "User+REST.h"
#import "FeedUserImage.h"
#import "TDDatePickerController.h"



//@protocol LogoutDelegate;
//@protocol UserSettingsDelegate;
//
//@interface MenuViewController : UIViewController <UITableViewDataSource, UITabBarControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
//
//
//@property (weak, nonatomic) IBOutlet UILabel *iAmLabel;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentControl;
//@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
//
//@property (weak, nonatomic) IBOutlet UIButton *lookingForMen;
//@property (weak, nonatomic) IBOutlet UIButton *lookingForWomen;
//@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
//@property (weak, nonatomic) id <LogoutDelegate> delegate;
//@property (weak, nonatomic) id <UserSettingsDelegate> settingsDelegate;


//@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
//@property (weak, nonatomic) IBOutlet ProfileImageView *profileImage;
//
//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//@property (weak, nonatomic) IBOutlet UISwitch *notificationEmailSwitch;
//@property (strong, nonatomic) TDDatePickerController *datePicker;
//@property (weak, nonatomic) IBOutlet UISwitch *notificationPushSwitch;
//@property (weak, nonatomic) IBOutlet UIButton *birthdayButton;
//- (IBAction)notificationSettingsChanged:(id)sender;
//- (IBAction)didTapBirthday:(id)sender;
//
//- (IBAction)didTapLogout:(id)sender;
//- (IBAction)didTapWomen:(id)sender;
//- (IBAction)didTapMen:(id)sender;
//- (IBAction)genderChanged:(id)sender;
//- (void)setupProfile;
//
//@end

//@protocol LogoutDelegate <NSObject>

//@required
//- (void)didLogout;
//
//@end
//
//@protocol UserSettingsDelegate <NSObject>
//
//@required
//- (void)didChangeFilters;
//
//@end