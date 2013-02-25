//
//  MenuViewController.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "ECSlidingViewController.h"
#import "User+REST.h"

typedef enum  {
    LookingForMen = 0,
    LookingForWomen = 1,
    LookingForBoth = 2
    } LookingForTypes;

@protocol LogoutDelegate;
@interface MenuViewController : UIViewController <UITableViewDataSource, UITabBarControllerDelegate>
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UILabel *iAmLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentControl;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (weak, nonatomic) IBOutlet UIButton *lookingForMen;
@property (weak, nonatomic) IBOutlet UIButton *lookingForWomen;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) id <LogoutDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;


- (IBAction)didTapLogout:(id)sender;
- (IBAction)didTapWomen:(id)sender;
- (IBAction)didTapMen:(id)sender;
- (IBAction)genderChanged:(id)sender;

@end

@protocol LogoutDelegate <NSObject>

@required
- (void)didLogout;
- (void)didUpdateSettings;

@end